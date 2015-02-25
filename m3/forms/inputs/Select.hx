package m3.forms.inputs;

import js.html.Element;
import m3.jq.JQ;
import m3.util.UidGenerator;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;


using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;

typedef SelectWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var label: JQ;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;
	
	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
}

class SelectHelper {
	public static function result(s: Select): String {
		return s.selectComp("result");
	}
}

@:native("$")
extern class Select extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):Select{})
	function selectComp(opts: FormInputOptions): Select;

	@:overload(function( selector: JQ ) : Select{})
	@:overload(function( selector: Element ) : Select{})
	override function appendTo( selector: String ): Select;

	private static function __init__(): Void {
		
		var defineWidget: Void->SelectWidgetDef = function(): SelectWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: SelectWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of SelectComp must be a div element");
		        	}

		        	selfElement.addClass("_selectComp center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

	        		self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

		        	// var uid: String = UidGenerator.create(8);
	        		// self.label = new JQ("<label for='quest" + uid + "'>" + question.label + "</label>").appendTo(selfElement);
	        		// var multi: String = self.options.multi ? " multiple ": "";
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

	        		self.input = new JQ("<select class='ui-combobox-input ui-widget ui-widget-content' name='" + self.options.formItem.name + "' " + multi + "><option value=''>"+defaultValue+"</option></select>");
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
	        		self.input.blur(function(ev){
	        				selfElement.validate();
		        		});
		        },	        

		        result: function(): String {
		        	var self: SelectWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.selectComp", (untyped $.ui.abstractInput), defineWidget());
	}
}