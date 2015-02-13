package m3.forms;

import js.html.Element;

import m3.exception.Exception;
import m3.forms.FormInput;
import m3.forms.FormLayoutPlugin.DefaultFormLayout;
import m3.forms.FormPlugin.IdentityFP;
import m3.forms.inputs.Select;
import m3.jq.JQ;
import m3.widget.Widgets;
import m3.forms.FormValidations;

using m3.forms.FormInput;
using m3.forms.inputs.TextInput;
using m3.forms.inputs.CodeInput;
using m3.helper.StringHelper;
using m3.helper.ArrayHelper;

class InputType {
	public static var SELECT: String = "SELECT";
	public static var TEXT: String = "TEXT";
	public static var TEXTAREA: String = "TEXTAREA";
	public static var CHECKBOX: String = "CHECKBOX";
	public static var COMBOBOX: String = "COMBOBOX";
	public static var ACCOMBOBOX: String = "ACCOMBOBOX";
	public static var DATE: String = "DATE";
	public static var JAVASCRIPT: String = "JAVASCRIPT";
	public static var SQL: String = "SQL";
	public static var JSON: String = "JSON";
	public static var HTML: String = "HTML";
}

class FormError {
	public var input: FormInput;
	public var msg: String;

	public function new(input: FormInput, msg: String) {
		this.input = input;
		this.msg = msg;
	}
}

typedef FormItem = {
	var name: String;
	@:optional var label: String;
	@:optional var type: String; // this is one of the InputType.xxxx values
	@:optional var value: Dynamic;// either a String or Array<String>
	@:optional var required: Bool;
	@:optional var disabled: Bool;
	@:optional var validators: Array<Dynamic->Dynamic>;
	@:optional var options: Dynamic;// Array<Array<String>> or a function returning Array<Array<String>>
}

typedef FormBuilderOptions = {
	@:optional var title: String;
	@:optional var subtitle: String;
	var formItems: Array<FormItem>;
	@:optional var onSubmit: Array<Array<String>>->Void;
	@:optional var onError: Void->Void;
	@:optional var onCancel: Void->Void;
	@:optional var formPlugin: FormPlugin;
	@:optional var formLayoutPlugin: FormLayoutPlugin;
	@:optional var validate: Void->Dynamic;
}

typedef FormBuilderWidgetDef = {
	var options: FormBuilderOptions;

	@:optional var _formInputs: Array<FormInput>;
	var _create: Void->Void;
	var destroy: Void->Void;

	var results: Void->Array<Array<String>>;
	var validate: Void->Array<FormError>;
	var formInputs: Void->Array<FormInput>;
}

class FormBuilderHelper {
	public static function results(fb: FormBuilder): Array<Array<String>> {
		return fb.formBuilder("results");
	}

	public static function validate(fb: FormBuilder): Array<FormError> {
		return fb.formBuilder("validate");
	}

	public static function formInputs(fb: FormBuilder): Array<FormInput> {
		return fb.formBuilder("formInputs");
	}
}

@:native("$")
extern class FormBuilder extends JQ {
	
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):JQ{})
	function formBuilder(opts: FormBuilderOptions): FormBuilder;

	@:overload(function( selector: JQ ) : FormBuilder{})
	@:overload(function( selector: Element ) : FormBuilder{})
	override function appendTo( selector: String ): FormBuilder;

	private static function __init__(): Void {
		
		var defineWidget: Void->FormBuilderWidgetDef = function(): FormBuilderWidgetDef {
			return {

				options: {
					title: "",
					formItems: null,
					onSubmit: function(arg) {},
					formPlugin: new IdentityFP(),
					formLayoutPlugin: new DefaultFormLayout(),
					validate: function() { return null;}
				},

				_create: function(): Void {
		        	var self: FormBuilderWidgetDef = Widgets.getSelf();
					var selfElement: FormBuilder = Widgets.getSelfElement();

					self.options = self.options.formPlugin.preprocessForm(selfElement, self.options);

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of FormBuilder must be a div element");
		        	}

		        	selfElement.addClass("_formBuilder");
		        	
		        	self._formInputs = self.options.formLayoutPlugin.render(selfElement, self.options);

		        	self.options.formPlugin.postprocessForm(selfElement, self.options);
		        },

		        formInputs: function(): Array<FormInput> {
		        	var self: FormBuilderWidgetDef = Widgets.getSelf();
		        	return self._formInputs;
	        	},

		        validate: function(): Array<FormError> {
		        	var self: FormBuilderWidgetDef = Widgets.getSelf();
					var selfElement: FormBuilder = Widgets.getSelfElement();

	        		//validate each input
	        		var errors: Array<FormError> = new Array();
	        		for(fi in self._formInputs) {
	        			errors.addAll(fi.validate());
	        		}
	        		if(!errors.hasValues() && self.options.validate != null) {
	        			errors.addAll(self.options.validate());
	        		}
	        		//validate the form

	        		//render the results
        			self.options.formLayoutPlugin.renderValidation(selfElement, self.options, errors);

	        		return errors;
	        	},
		        
		        results: function(): Array<Array<String>> {
		        	var self: FormBuilderWidgetDef = Widgets.getSelf();
		        	var results: Array<Array<String>> = new Array();
		        	for(formInput in self._formInputs) {
		        		results.push(formInput.result());
		        	}
		        	return results;
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.formBuilder", defineWidget());
	}
}