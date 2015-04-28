package m3.forms.inputs;

import js.html.Element;

import m3.jq.ComboBox;
import m3.jq.JQ;
import m3.jq.JQTooltip;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;


typedef ACComboBoxWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var label: JQ;
	@:optional var input: ComboBox;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
}

class ACComboBoxHelper {
	public static function result(s: ACComboBox): String {
		return s.accomboBox("result");
	}
}

@:native("$")
extern class ACComboBox extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):ACComboBox{})
	function accomboBox(opts: FormInputOptions): ACComboBox;
	
	@:overload(function( selector: JQ ) : ACComboBox{})
	@:overload(function( selector: Element ) : ACComboBox{})
	override function appendTo( selector: String ): ACComboBox;

	private static function __init__(): Void {

		var defineWidget: Void->ACComboBoxWidgetDef = function(): ACComboBoxWidgetDef {
			return {
				_create: function(): Void {
					var self: ACComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	selfElement.addClass("_accomboBox center");
	 				self._super();

		        	var question: FormItem = self.options.formItem;

	 				self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		var multi: String = "";
	        		var defaultValue : String = "No data available...";
        			var choices: Array<Array<String>> = {
        				if(Reflect.isFunction(question.options)) {
        					question.options();
        				} else {
        					question.options;
        				}
        			}

        			if(choices != null && choices.length > 0){
        				defaultValue = "Please choose...";
        			}

	        		self.input = new ComboBox("<select class='ui-combobox-input ui-widget ui-widget-content' name='" + self.options.formItem.name + "' id='" + self.options.formItem.name + "'" + multi + "><option value=''>"+defaultValue+"</option></select>");
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true");
	        			self.iconDiv.show().addClass("locked");
	        		}


	        		var answers: Array<String> = {
	        			if(self.options.formItem.value != null) {
	        				if(Std.is(self.options.formItem.value, Array)) {
	        					self.options.formItem.value;
	        				} else if(Reflect.isFunction(self.options.formItem.value)) {
	        					self.options.formItem.value();
	        				} else {
	        					[self.options.formItem.value];
	        				}
        				} else {
						 	[];
        				};
        			}
        			if(choices != null && choices.length != 0){
			        	for(option in choices) {
			        		var opt: JQ = new JQ("<option></option>")
			        								.attr("value", option[0])
			        								.appendTo(self.input)
			        								.append(option[1]);
			        		if(answers.contains(option[0])) opt.attr("selected", "selected");
			        	}
			        }
	        		selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);

			        self.input.comboBox({
				    	customCssOnInput: "",
				    	customCssOnSpan: "",
				    	wrapAll: true
			    	});

	        		self.input.change(function(ev){
        				selfElement.validate();
	        		});

	        		selfElement.find(".ui-autocomplete-input").blur(function(ev){
        				selfElement.validate();
	        		});

		        },

		        result: function(): String {
		        	var self: ACComboBoxWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},
		        
		        destroy: function() {
	                untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    }
		}
		JQ.widget( "ui.accomboBox", (untyped $.ui.abstractInput), defineWidget());
	}
}