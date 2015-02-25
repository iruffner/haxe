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
using m3.forms.FormBuilderDialog.FormBuilderDialogOptions;
using m3.widget.CodeEditor;

typedef CodeInputWidgetDef = {
	@:optional var editorDiv: JQ;
	@:optional var editor: Dynamic;	
 	@:optional var options: CodeInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var input: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;

}

typedef CodeInputOptions = {
	>FormInputOptions,
	var mode: String;
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
	function codeInput(opts: CodeInputOptions): CodeInput;

	@:overload(function( selector: JQ ) : CodeInput{})
	@:overload(function( selector: Element ) : CodeInput{})
	override function appendTo( selector: String ): CodeInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->CodeInputWidgetDef = function(): CodeInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: CodeInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of CodeInput must be a div element");
		        	}

		        	selfElement.addClass("_codeInput center");

		        	self._super();

		        	var question: FormItem = self.options.formItem;

		        	self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

					self.editorDiv = new JQ("<div id='aceEditorDiv'></div><");
    				untyped self.editor = ace.edit(self.editorDiv[0]);
    				self.editor.setTheme("ace/theme/chrome");
    				var mode :String = "ace/mode/"+self.options.mode.toLowerCase();
    				self.editor.getSession().setMode(mode);

					self.input = self.editorDiv;
	        		if(self.getDefaultValue() != null) self.editor.setValue(self.options.formItem.value);

    				//set style after we know the dim after content
    				var dialogoffset = 200;
    				var lineheight = 10 * 17.5;
    				var lines = self.editor.session.doc.getAllLines();
    				if(lines.length >= 10) lineheight = lines.length * 17.5;
    				if(lines.length > 30) lineheight = 30 * 17.5;
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
						"height": lineheight,
						"border" : "1px solid",
						"vertical-align" : "top"
						});

					//set icon
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true").addClass("ui-state-active");
	        			self.iconDiv.show().addClass("locked");
	        		}else{//if editor and not locked then popup icon and construct codeeditor for click
	        			new JQ(self.iconDiv.show().addClass("fi-arrow-right")).click(
	        				function(){
	        					var opts : CodeEditorOptions = {
	        						text: self.editor.getValue(),
	        						dialogOptions: {
		        							width: "60%", 
		        							"height": lineheight + dialogoffset
	        							},
	        						cancel: function(){
	        							},
	        						submit: function(value){
	        								self.editor.setValue(value);
	        							},
	        						mode: mode
	        					}
								var t: CodeEditor = new CodeEditor("<div></div>")
									.codeEditor(opts);
								t.codeEditor("showEditor");
	        				}).css({"padding-top" : "1.5%"});
	        		}

	        		selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);
	        		self.input.find(":input").blur(function(ev){
	        				selfElement.validate();
		        		});
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