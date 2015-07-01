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

typedef PasswordInputWidgetDef = {
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

class PasswordInputHelper {
	public static function result(s: PasswordInput): String {
		return s.passwordInput("result");
	}
}

@:native("$")
extern class PasswordInput extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):PasswordInput{})
	function passwordInput(opts: FormInputOptions): PasswordInput;

	@:overload(function( selector: JQ ) : PasswordInput{})
	@:overload(function( selector: Element ) : PasswordInput{})
	override function appendTo( selector: String ): PasswordInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->PasswordInputWidgetDef = function(): PasswordInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: PasswordInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of PasswordInput must be a div element");
		        	}

		        	selfElement.addClass("_PasswordInput center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		self.input = new JQ("<input class='ui-widget-content ui-corner-all helpFilter' type='password' name='" + question.name + "' id='" + question.name + "'/>");
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
		        	var self: PasswordInputWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.passwordInput", (untyped $.ui.abstractInput), defineWidget());
	}
}