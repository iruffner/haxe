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
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of DateComp Comp must be a div element");
		        	}

		        	selfElement.addClass("_dateComp center");

					self._super();

					var question: FormItem = self.options.formItem;

					self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		var inputElement;
	        		if (question.options != null && question.options.displayInline && question.options.displayInline)//changeThis
	        		{
	        			inputElement = new JQDatepicker("<div class='ui-widget-content ui-corner-all' style='display:inline-flex;margin: 10px;'></div>");
	        		}
	        		else
	        		{
	        			inputElement = new JQDatepicker("<input class='ui-widget-content ui-corner-all helpFilter' type='text'/>");
	        		}

	        		self.input = inputElement.datepicker({
	        				"dateFormat": "yy-mm-dd",
	        				"changeMonth": true,
	        				"changeYear": true,
	        				onSelect: function(ev){
	        					selfElement.validate();
		        			}
	        			});
					if( question.value == null) question.value = DateTools.format(Date.now(), "%Y-%m-%d");
					self.input.val(question.value);
					if(question.disabled) {
						self.input.attr("disabled", "true").addClass("ui-state-active");
						self.iconDiv.show().addClass("locked");
					}

					selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
	        		self.input.blur(function(ev){
	        				selfElement.validate();
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

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.dateComp", (untyped $.ui.abstractInput), defineWidget());
	}
}