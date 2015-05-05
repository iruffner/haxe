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

                    var inputFrom = new JQDatepicker("<input name='dateRangeFrom' class='ui-widget-content helpFilter ui-corner-all' style='min-width:initial'/>");
                    var inputTo = new JQDatepicker("<input name='dateRangeTo' class='ui-widget-content helpFilter ui-corner-all' style='min-width:initial'/>");

                    self.inputFrom = inputFrom.datepicker({
                        "dateFormat": "yy-mm-dd",
                    });
                    self.inputTo = inputTo.datepicker({
                        "dateFormat": "yy-mm-dd",
                    });

                    var dateExp = ~/[0-9]{4}-[0-9]{2}-[0-9]{2}/;

                    if(question.value != null && dateExp.match(question.value))
                    {
                        var valueArray = question.value.split(" - ");
                        self.inputFrom.val(valueArray[0]);
                        self.inputTo.val(valueArray[1]);
                    }

                    var container = new JQ("<div></div>");

                    container.append(self.inputFrom).append('&nbsp<label for="dateRangeTo" style="width:10%" >To</label>');
                    container.append("&nbsp;").append(self.inputTo).append(self.iconDiv);
                    selfElement.append(container);
				},

				result: function(): String {
					var self: DateRangeWidgetDef = Widgets.getSelf();
					var fromValue = self.inputFrom.val();
					var toValue = self.inputTo.val();
		        	return fromValue+" - "+toValue;
	        	},

				destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
			}
		}
		JQ.widget( "ui.dateRange", (untyped $.ui.abstractInput), defineWidget());
	}
}