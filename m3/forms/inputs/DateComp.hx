package m3.forms.inputs;

//import flash.globalization.DateTimeFormatter;
import js.html.Element;

import m3.jq.JQ;
import m3.jq.JQDatepicker;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;

typedef DateWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var validate: Void->Bool;	
	var destroy: Void->Void;
	@:optional var input: JQDatepicker;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;

}

class DateCompHelper {
	public static function result(s: DateComp): String {
		return s.dateComp("result");
	}
}

@:native("$")
extern class DateComp extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):DateComp{})
	function dateComp(opts: FormInputOptions): DateComp;

	private static function __init__(): Void {
		
		var defineWidget: Void->DateWidgetDef = function(): DateWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: DateWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of DateComp Comp must be a div element");
		        	}

		        	selfElement.addClass("_dateComp center");

					self._super();

					var question: FormItem = self.options.formItem;

					self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		self.input = new JQDatepicker("<input class='ui-widget-content ui-corner-all helpFilter' type='text'/>").datepicker({
	        				"dateFormat": "yy-mm-dd",
	        				"changeMonth": true,
	        				"changeYear": true
	        			});
					if( question.value == null) question.value = DateTools.format(Date.now(), "%Y-%m-%d");
					self.input.val(question.value);
					if(question.disabled) {
						self.input.attr("disabled", "true").addClass("ui-state-active");
						self.iconDiv.show().addClass("locked");
					}

					selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
	        		self.input.blur(function(ev){
	        				self.validate();
		        		});					

        			/*try {
	        			if(self.options.answers.hasValues()) {
		        			var dateStr: String = self.options.answers[0].response;
		        			var date: Date = null;
		        				date = dateStr.toDate();
		        			if(date != null)
		        				self.input.val(date.dateYYYY_MM_DD());	
		        			else 
		        			self.input.val(self.options.answers[0].response);

	        			}
        			} catch (exc: Dynamic) { }*/
		        	
	        		// selfElement.append(self.input);
		        },

		        result: function(): String {
					var self: DateWidgetDef = Widgets.getSelf();
					return self.input.val();

	        	},

		        validate: function(): Bool {
		        	var self: DateWidgetDef = Widgets.getSelf();
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
		JQ.widget( "ui.dateComp", (untyped $.ui.abstractInput), defineWidget());
	}
}