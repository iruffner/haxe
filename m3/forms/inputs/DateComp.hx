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
	@:optional var label: JQ;
	@:optional var input: JQ;

	@:optional var _super: Dynamic;

}

class DateCompHelper {
	public static function result(s: DateComp): String {
		return s.dateComp("result");
	}
}

@:native("$")
extern class DateComp extends AbstractInput {
	@:overload(function(cmd : String):String{})
	@:overload(function(cmd : String, arg: Dynamic):Dynamic{})
	@:overload(function(cmd:String, opt:String, newVal:Dynamic):DateComp{})
	function dateComp(opts: FormInputOptions): DateComp;

	private static function __init__(): Void {
		
		var defineWidget: Void->DateWidgetDef = function(): DateWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: DateWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
					var cmd: String = "{ dateFormat: 'dd-mm-yy' }";

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of DateComp Comp must be a div element");
		        	}

		        	selfElement.addClass("_dateComp center");

					self._super();

					var question: FormItem = self.options.formItem;
	        		self.input = new JQDatepicker("<input type='text'/>").datepicker().datepicker('option','dateFormat','yy-mm-dd');
					if( question.value == null) question.value = DateTools.format(Date.now(), "%Y-%m-%d");
					self.input.val(question.value);
					if(question.disabled) {
						self.input.attr("disabled", "true").addClass("ui-state-active");
						//self.iconDiv.show().addClass("locked");
					}

					//selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);

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
		        	
	        		selfElement.append(self.input);
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