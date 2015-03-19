package m3.forms.inputs;

import js.html.Element;

import m3.jq.JQ;
import m3.jq.JQDatepicker;
import m3.widget.Widgets;

typedef DateRangeWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var input: JQDatepicker;
	@:optional var iconDiv: JQ;
	@:optional var _super: Dynamic;
}

@:native("$")
extern class DateRange extends AbstractInput {
	private static function __init__(): Void {
		var defineWidget: Void->DateWidgetDef = function(): DateWidgetDef {
			return {
				_create: function(): Void{
					var self: DateRangeWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

					if(!selfElement.is("div")) {
		        		throw new Exception("Root of DateRange must be a div element");
		        	}

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();
				},

				result: function(): String {
					var self: DateRangeWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},

				destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
			}
		}
		JQ.widget( "ui.dateRange", (untyped $.ui.abstractInput), defineWidget());
	}
}