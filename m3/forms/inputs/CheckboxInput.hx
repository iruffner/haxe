package m3.forms.inputs;

import js.html.Element;

import m3.jq.JQ;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;
//using Lambda;


typedef CheckboxInputWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->Array<String>;
	var destroy: Void->Void;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
	
}

class CheckboxInputHelper {
	public static function result(cb: CheckboxInput): Array<String> {
		return cb.checkboxInput("result");
	}
}

@:native("$")
extern class CheckboxInput extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function(cmd : String, arg: Dynamic):Dynamic{})
	@:overload(function(cmd:String, opt:String, newVal:Dynamic):JQ{})
	function checkboxInput(opts: FormInputOptions): CheckboxInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->CheckboxInputWidgetDef = function(): CheckboxInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: CheckboxInputWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of CheckboxInput must be a div element");
		        	}

		        	selfElement.addClass("_CheckboxInput center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

/*	        		var fieldset: JQ = new JQ(	"<fieldset data-role='controlgroup'>" + 
		        									"<legend>" + question.value + "</legend>" + 
		        								"</fieldset>").appendTo(selfElement);
*/
		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		self.input = new JQ( "<input type='checkbox'/>" )
	        								//.attr("id", "ans" + choice.uid)
	        								.attr("value", question.value)
	        								.appendTo(selfElement);

	        		if(self.getDefaultValue() != null) self.input.val(self.options.formItem.value);
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true").addClass("ui-state-active");
	        			self.iconDiv.show().addClass("locked");
	        		}	        								

					selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);	        								

/*		        	for(ans_ in 0...question.options.length) {
		        		var choice: Choice = question.options[ans_];
		        		fieldset.append(input)
		        				.append("<label for='ans" + choice.uid + "'>" + choice.text + "</label>");

		        		if(self.options.answers.hasValues() && self.options.answers.containsComplex(choice.value, function(ans: Answer): String {
									if(ans.question_uid == question.uid) return ans.response;
									else return "nowaynohow";
								})) {
								input.attr("checked", "checked");
							}
		        	}
*/		        },

		        result: function(): Array<String> {
		        	var self: CheckboxInputWidgetDef = Widgets.getSelf();
		        	return [(self.input.val() == "on") ? "Y" : "N"];
		        },
/*					var self: CheckboxInputWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
					var selections: JQ = new JQ(":checked", selfElement);
					var value: Array<String> = {
						if(selections.exists()) {
							Lambda.map(selections,
								function(elem: JQ): String {
										return elem.val();
									}
							).array();
						} else null;
					}
					if(!value.hasValues() && self.options.formItem.required) {
						throw new ValidationException("Valud value is required");
					} else if(!value.hasValues()) {
						return null;
					} else {
						return value;
					}
	        	},
*/
		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.checkboxInput", (untyped $.ui.abstractInput), defineWidget());
	}
}