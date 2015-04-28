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

typedef DateCompOptions = {
    >FormInputOptions,
    var displayInline: Bool;
    var numberOfMonths: Int;
    var yearRange: String;
}

typedef DateWidgetDef = {
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var input: JQDatepicker;
	@:optional var iconDiv: JQ;
    @:optional var options: DateCompOptions;
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

					self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		var inputElement;
	        		if (self.options.displayInline) {
	        			inputElement = new JQDatepicker("<div class='ui-widget-content ui-corner-all' style='display:inline-flex; margin: 10px;'></div>");
	        		} else {
	        			inputElement = new JQDatepicker("<input class='ui-widget-content ui-corner-all helpFilter' type='text'/>");
	        		}

	        		if(self.options.numberOfMonths == null) {
	        			self.options.numberOfMonths = 1;
	        		}

	        		if(self.options.yearRange == null) {
	        			self.options.yearRange = "c-60:c+20";
	        		}

	        		self.input = inputElement.datepicker({
	        				"dateFormat": "yy-mm-dd",
	        				"changeMonth": true,
	        				"changeYear": true,
	        				"yearRange": self.options.yearRange,
	        				"numberOfMonths": self.options.numberOfMonths,
	        				onSelect: function(ev){
	        					selfElement.validate();
		        			}
	        			});

					if( self.options.formItem.value == null) 
						self.options.formItem.value = DateTools.format(Date.now(), "%Y-%m-%d");
					self.input.val(self.options.formItem.value);
					if(self.options.formItem.disabled) {
						self.input.attr("disabled", "true").addClass("ui-state-active");
						self.iconDiv.show().addClass("locked");
					}

					selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
	        		self.input.blur(function(ev){
	        				selfElement.validate();
		        		});					
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