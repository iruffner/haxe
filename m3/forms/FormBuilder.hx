package m3.forms;

import js.html.Element;

import m3.exception.Exception;
import m3.forms.FormPlugin.IdentityFP;
import m3.forms.inputs.Select;
import m3.jq.JQ;
import m3.widget.Widgets;

using m3.forms.inputs.FormInput;
using m3.forms.inputs.TextInput;

class InputType {
	public static var SELECT: String = "SELECT";
	public static var TEXT: String = "TEXT";
	public static var COMBOBOX: String = "COMBOBOX";
}

typedef FormItem = {
	var name: String;
	@:optional var label: String;
	var type: String;
	@:optional var value: Dynamic;// either a String or Array<String>
	@:optional var required: Bool;
	@:optional var validate: String->Bool;
	@:optional var options: Dynamic;// Array<Array<String>> or a function returning Array<Array<String>>
}

typedef FormBuilderOptions = {
	@:optional var title: String;
	var formItems: Array<FormItem>;
	@:optional var onSubmit: Void->Void;
	@:optional var onError: Void->Void;
	@:optional var onCancel: Void->Void;
	var formPlugin: FormPlugin;
}

typedef FormBuilderWidgetDef = {
	var options: FormBuilderOptions;

	@:optional var _formInputs: Array<FormInput>;
	var _create: Void->Void;
	var destroy: Void->Void;
}

class FormBuilderHelper {
	// public static function update(dc: FormBuilder, dr: DeviceReport): Void {
	// 	dc.FormBuilder("update", dr);
	// }
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
					onSubmit: JQ.noop,
					formPlugin: new IdentityFP()
				},

				_create: function(): Void {
		        	var self: FormBuilderWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

					self.options = self.options.formPlugin.preprocessForm(self.options);

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of FormBuilder must be a div element");
		        	}

		        	selfElement.addClass("_formBuilder");
		        	
		        	selfElement.append("<h2>" + self.options.title + "</h2>");

		        	var form: JQ = new JQ("<div class='formInputs'></div>").appendTo(selfElement);

		        	for(formItem in self.options.formItems) {
		        		switch(formItem.type) {
		        			case InputType.TEXT: 
		        				var fi: TextInput = new TextInput("<div></div>")
		        					.appendTo(form)
		        					.textInput({formItem: formItem});
		        			case InputType.SELECT: 
		        				var fi: Select = new Select("<div></div>")
		        					.appendTo(form)
		        					.selectComp({formItem: formItem});
		        			// case InputType.COMBOBOX: 
		        			// 	var fi: Select = new Select("<div></div>")
		        			// 		.appendTo(form)
		        			// 		.selectComp({formItem: formItem});
		        			case _:

		        		}
		        	}
		        },

		        // update: function(dr: DeviceReport): Void {
		        // 	if(dr == null) return;
		        // 	var self: FormBuilderWidgetDef = Widgets.getSelf();

		        // 	self._super(dr);

		        // 	switch(dr.msgType) {
		        // 		case MsgType.healthReport: 
		        // 			AppContext.LAST_HEALTH_REPORTS.set(Device.identifier(self.options.device), dr);
	        	// 		case MsgType.dataReport:
		        // 			AppContext.LAST_DATA_REPORTS.set(Device.identifier(self.options.device), dr);
		        // 	}

	        	// },

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.formBuilder", defineWidget());
	}
}