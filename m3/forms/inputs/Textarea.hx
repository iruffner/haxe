//package ui.widgets.qtype;
package m3.forms.inputs;

import js.html.VideoElement;

import m3.jq.JQ;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;

typedef TextareaWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var validate: Void->Bool;		
	var destroy: Void->Void;
	@:optional var label: JQ;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;	
}

class TextareaHelper {
	public static function result(s: Textarea): String {
		return s.textarea("result");
	}
}

@:native("$")
extern class Textarea extends AbstractInput {
	@:overload(function(cmd : String):String{})
	@:overload(function(cmd : String, arg: Dynamic):Dynamic{})
	@:overload(function(cmd:String, opt:String, newVal:Dynamic):JQ{})
	function textarea(opts: FormInputOptions): Textarea;

	private static function __init__(): Void {
		
		var defineWidget: Void->TextareaWidgetDef = function(): TextareaWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: TextareaWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of TextArea must be a div element");
		        	}

		        	selfElement.addClass("_textarea center");

		        	var question: FormItem = self.options.formItem;

	        		self.label = new JQ("<label for='quest" + question.name + "'>" + question.name + "</label>").appendTo(selfElement)
	        		.css({
	        			"padding-top":"2%",	
        			});

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		var multi: String = "";
	        		self.input = new JQ("<textarea name='" + question.name + "' id='quest" + question.name + "'></textarea>")
	        		.css({
						position: "relative",
						top: -15,
						right: 0,
						bottom: 0,
						left: 0,
						"border": "1px solid black",
						"min-height": "150px",
						"margin-left": "0.8%",
						"vertical-align" : "top",
						"min-width": "89.9%"
					});

	        		if(question.value != null) self.input.val(question.value);
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true").addClass("ui-state-active");
	        			self.iconDiv.show().addClass("locked");
	        		}
	        		
	        		selfElement.append(self.input);
	        		self.input.blur(function(ev){
	        				self.validate();
		        		});
		        },

		        result: function(): String {
		        	var self: TextareaWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
					var value: String = self.input.val();
					if(value.isBlank() && self.options.formItem.required) {
						throw new ValidationException(self.options.formItem.name + " is required");
						self.label.css("color", "red");
					} else if(value.isBlank()) {
						return "";
					} else {
						return value;
					}
	        	},

		        validate: function(): Bool {
		        	var self: TextareaWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	var errors: Array<FormError> = new Array();
		        	if(self.options.formItem.validators.hasValues()) {
		        		for(validator in self.options.formItem.validators) {
		        			var validationResult: Dynamic = validator(self.result());
		        			var processResult = function(result: Dynamic) {
		        				if(result == null) {
			        				//do nothing
			        			} else if(Std.is(result, Bool) && !result) {
			        				errors.push(new FormError(selfElement, "Validation Error"));
			        			} else if(Std.is(result, String) && StringHelper.isNotBlank(result)) {
			        				errors.push(new FormError(selfElement, result));
		        				} else if(Std.is(result, FormError)){ 
		        					errors.push(result);
			        			} else {
			        				Logga.DEFAULT.warn("unexpected return type from validation function");
			        			}
		        			};
		        			if(JQ.isArray(validationResult)) {
		        				var valResArr: Array<Dynamic> = validationResult;
		        				for(res_ in valResArr) {
		        					processResult(res_);
		        				}
		        			} else {
		        				processResult(validationResult);
		        			}
		        		}
	        		}else{
	        			return true;
	        		}

	        		self.options.formItem.formLayoutPlugin.renderInputValidation(selfElement, errors);
	        		return false;
        		},	        	

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.textarea", defineWidget());
	}
}