package m3.forms.inputs;

import js.html.Element;

import m3.jq.JQ;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;
using m3.forms.FormBuilderDialog.FormBuilderDialogOptions;
using embi.plugins.BiFormBuilderPlugin.BiFormBuilderOptions;

typedef CodeInputWidgetDef = {
	@:optional var editorDiv: JQ;
	@:optional var editor: Dynamic;	
 	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;

}

class CodeInputHelper {
	public static function result(s: CodeInput): String {
		return s.codeInput("result");
	}
}

@:native("$")
extern class CodeInput extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):CodeInput{})
	function codeInput(opts: FormInputOptions): CodeInput;

	@:overload(function( selector: JQ ) : CodeInput{})
	@:overload(function( selector: Element ) : CodeInput{})
	override function appendTo( selector: String ): CodeInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->CodeInputWidgetDef = function(): CodeInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: CodeInputWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of CodeInput must be a div element");
		        	}

		        	selfElement.addClass("_codeInput center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

					self.editorDiv = new JQ("<div id='aceEditorDiv'></div><");
					self.editorDiv.css({
						position: "relative",
						top: 0,
						right: 0,
						bottom: 0,
						left: 0,
						"text-align": "left",
						"display": "inline-block",
						"max-width": "90%",
						"min-width": "89.5%",
						"height": "200px",
						"border" : "1px solid",
						"vertical-align" : "top"
						});
					self.input = self.editorDiv;
    				untyped self.editor = ace.edit(self.editorDiv[0]);
    				self.editor.setTheme("ace/theme/chrome");
    				self.editor.getSession().setMode("ace/mode/javascript");
    				self.editor.setValue();

	        		if(self.getDefaultValue() != null) self.editor.setValue(self.options.formItem.value);
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true").addClass("ui-state-active");
	        			self.iconDiv.show().addClass("locked");
	        		}else{
	        			new JQ(self.iconDiv.show().addClass("fi-arrow-right")).click(
	        				function(){
	        					trace(self);
	                            var editForm = new FormBuilderDialog("<div></div>").appendTo(js.Browser.document.body);
	                            var formOpts: BiFormBuilderOptions = {
	                                subtitle: "Edit a row from the view",
	                                //view: self.options,
	                                data: self.options.formItem.value,
	                                formItems: [self.options.formItem],
	                                formPlugin: FormBuilderDialog.DEFAULT_FORM_PLUGIN,
	                                formLayoutPlugin: FormBuilderDialog.DEFAULT_FORM_LAYOUT
	                            }
	                            var dialogOpts : FormBuilderDialogOptions = {
	                                title: "Edit code",
	                                height: 400,
	                                formOptions: formOpts
	                            };
	                            editForm.formBuilderDialog(dialogOpts);
	        				}).css({"padding-top" : "1.5%"});
	        		}

	        		selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
		        },

		        result: function(): String {
		        	var self: CodeInputWidgetDef = Widgets.getSelf();
					return self.editor.getValue();
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.codeInput", (untyped $.ui.abstractInput), defineWidget());
	}
}