package m3.forms.inputs;

import js.html.Element;
import m3.exception.Exception;
import m3.jq.JQ;
import m3.jq.JQDatepicker;
import m3.widget.Widgets;

using m3.forms.FormBuilder;
using m3.forms.FormInput;

typedef DateRangeWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var inputFrom: JQDatepicker;
    @:optional var inputTo: JQDatepicker;
	@:optional var iconDiv: JQ;
	@:optional var _super: Dynamic;
}

class DateRangeHelper {
	public static function result(s: DateRange): String {
		return s.dateRange("result");
	}
}

@:native("$")
extern class DateRange extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):DateRange{})
	function dateRange(opts: FormInputOptions): DateRange;

	private static function __init__(): Void {
		var defineWidget: Void->DateRangeWidgetDef = function(): DateRangeWidgetDef {
			return {
				_create: function(): Void {
					var self: DateRangeWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

					if(!selfElement.is("div")) {
		        		throw new Exception("Root of DateRange must be a div element");
		        	}

		        	selfElement.addClass("_dateComp center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

                    var inputFrom = new JQDatepicker("<input name='dateRangeFrom' class='ui-widget-content ui-corner-all' style='width:45%'/>");
                    var inputTo = new JQDatepicker("<input name='dateRangeTo' class='ui-widget-content ui-corner-all' style='width:45%'/>");

                    self.inputFrom = inputFrom.datepicker({
                        "dateFormat": "yy-mm-dd",
                    });
                    self.inputTo = inputTo.datepicker({
                        "dateFormat": "yy-mm-dd",
                    });

                    /*selfElement.append("&nbsp;").append(self.inputFrom).append('<label for="dateRangeTo" style="width:10%" >To</label>');
                    selfElement.append("&nbsp;").append(self.inputTo).append(self.iconDiv);*/
				},

				result: function(): String {
					var self: DateRangeWidgetDef = Widgets.getSelf();
					return self.inputFrom.val()+'-'+self.inputTo.val();
	        	},

				destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
			}
		}
		JQ.widget( "ui.dateRange", (untyped $.ui.abstractInput), defineWidget());
	}
}