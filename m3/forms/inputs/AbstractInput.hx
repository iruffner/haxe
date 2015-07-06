package m3.forms.inputs;

import js.html.Element;

import m3.exception.Exception;
import m3.jq.JQ;
import m3.widget.Widgets;

using m3.helper.StringFormatHelper;
using m3.helper.StringHelper;
using m3.forms.FormBuilder;

typedef FormInputOptions = {
	var formItem: FormItem;
}

typedef AbstractInputWidgetDef = {
	@:optional var options: FormInputOptions;

	@:optional var label: JQ;
	@:optional var input: JQ;

	var _create: Void->Void;
	var destroy: Void->Void;
	var getDefaultValue: Void->Dynamic;
}

@:native("$")
extern class AbstractInput extends JQ {
	
	private static function __init__(): Void {
		
		var defineWidget: Void->AbstractInputWidgetDef = function(): AbstractInputWidgetDef {
			return {

				_create: function(): Void {
		        	var self: AbstractInputWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of AbstractInput must be a div element");
		        	}

		        	selfElement.addClass("_abstractInput");

		        	var label: String = 
		        		self.options.formItem.label.isNotBlank() ? self.options.formItem.label : self.options.formItem.name.capitalizeFirstLetter();
		        	
		        	self.label = new JQ("<label for='" + self.options.formItem.name + "'>" + label + "</label>").appendTo(selfElement);
		        },

				getDefaultValue: function(): Dynamic {
					var self: AbstractInputWidgetDef = Widgets.getSelf();
					var value: Dynamic;
					if(Reflect.isFunction(self.options.formItem.value)) {
						value = self.options.formItem.value();
					} else {
						value = self.options.formItem.value;
					}
					return value;
				},

		        // update: function(dr: DeviceReport): Void {
		        // 	if(dr == null) return;
		        // 	var self: AbstractInputWidgetDef = Widgets.getSelf();

		        // 	self._super(dr);

		        // 	switch(dr.msgType) {
		        // 		case MsgType.healthReport: 
		        // 			AppContext.LAST_HEALTH_REPORTS.set(Device.identifier(self.options.device), dr);
	        	// 		case MsgType.dataReport:
		        // 			AppContext.LAST_DATA_REPORTS.set(Device.identifier(self.options.device), dr);
		        // 	}

	        	// },

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.abstractInput", defineWidget());
	}
}