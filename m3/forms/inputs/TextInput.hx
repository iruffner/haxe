package m3.forms.inputs;

import js.html.Element;

import m3.jq.JQ;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.jq.JQTooltip;
using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;

typedef TextInputWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	// var validate: Void->Bool;
	var destroy: Void->Void;
	@:optional var blur: Void->Bool;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
	@:optional var _getResultFcn: Void->Array<String>;

}

class TextInputHelper {
	public static function result(s: TextInput): String {
		return s.textInput("result");
	}
}

@:native("$")
extern class TextInput extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):TextInput{})
	function textInput(opts: FormInputOptions): TextInput;

	@:overload(function( selector: JQ ) : TextInput{})
	@:overload(function( selector: Element ) : TextInput{})
	override function appendTo( selector: String ): TextInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->TextInputWidgetDef = function(): TextInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: TextInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of TextInput must be a div element");
		        	}

		        	selfElement.addClass("_textInput center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		self.input = new JQ("<input class='ui-widget-content ui-corner-all helpFilter' type='text' name='" + question.name + "' id='" + question.name + "'/>");
	        		if(self.getDefaultValue() != null) self.input.val(self.options.formItem.value);
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true").addClass("ui-state-active");
	        			self.iconDiv.show().addClass("locked");
	        		}

	        		selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
	        		self.input.blur(function(ev){
	        				selfElement.validate();
		        		});
		        },

		        result: function(): String {
		        	var self: TextInputWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.textInput", (untyped $.ui.abstractInput), defineWidget());
	}
}