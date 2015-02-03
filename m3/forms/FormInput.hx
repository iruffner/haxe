package m3.forms;

import js.html.Element;

import m3.forms.FormBuilder.FormError;
import m3.forms.FormBuilder.FormItem;
import m3.forms.FormBuilder.InputType;
import m3.forms.inputs.AbstractInput;
import m3.jq.JQ;
import m3.widget.Widgets;

import m3.log.Logga;
import m3.exception.Exception;
import m3.exception.ValidationException;

using m3.forms.inputs.Select;
using m3.forms.inputs.TextInput;
using m3.forms.inputs.Textarea;
using m3.forms.inputs.CheckboxInput;
using m3.forms.inputs.DateComp;
using m3.forms.inputs.CodeInput;
using m3.helper.ArrayHelper;
using m3.helper.StringHelper;
using Lambda;

typedef FormInputOptions = {
	var formItem: FormItem;
}

typedef FormInputWidgetDef = {
	@:optional var editorDiv: JQ;	
	@:optional var editor: Dynamic;	
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->Array<String>;
	var validate: Void->Array<FormError>;
	@:optional var _getResultFcn: Void->Array<String>;
	var destroy: Void->Void;
}

class FormInputHelper {
	public static function result(c: FormInput): Array<String> {
		return c.formInput("result");
	}

	public static function validate(c: FormInput): Array<FormError> {
		return c.formInput("validate");
	}

	public static function getFormItem(c: FormInput): FormItem {
		return c.formInput("option", "formItem");
	}
}

@:native("$")
extern class FormInput extends JQ {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd:String, opt:String, newVal:Dynamic):JQ{})
	function formInput(opts: FormInputOptions): FormInput;

	@:overload(function( selector: JQ ) : FormInput{})
	@:overload(function( selector: Element ) : FormInput{})
	override function appendTo( selector: String ): FormInput;

	private static function __init__(): Void {
		
		var defineWidget: Void->FormInputWidgetDef = function(): FormInputWidgetDef {
			return {
		        _create: function(): Void {
		        	var self: FormInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of FormInput must be a div element");
		        	}

		        	selfElement.addClass("_formInput");

		        	var formItem: FormItem = self.options.formItem;

		        	if(self.options.formItem.required){
		        		if(self.options.formItem.validators == null){
		        			self.options.formItem.validators = new Array();
		        		}
						self.options.formItem.validators.push(m3.forms.FormValidations.notBlank);
		        	}

		        	var input: AbstractInput = null;

		        	if(formItem.disabled) {
		        		var t: TextInput = new TextInput(selfElement)
	        					.textInput({formItem: formItem});
	        				input = t;
	        				self._getResultFcn = function(): Array<String> {
		        	 			return [t.result()];
		        	 		}
	        		} else {
			        	switch(formItem.type) {
							case InputType.DATE:
								var t: DateComp = new DateComp(selfElement)
									.dateComp({formItem: formItem});
								input = t;
								self._getResultFcn = function(): Array<String> {
									return [t.result()];
								}			
							case InputType.JAVASCRIPT, InputType.JSON, InputType.HTML, InputType.SQL:
	        					var t: CodeInput = new CodeInput(selfElement)
		        					.codeInput({
		        							formItem: formItem,
		        							mode: formItem.type
		        						});
		        				input = t;
		        				self._getResultFcn = function(): Array<String> {
			        	 			return [t.result()];
			        	 		}
		        			case InputType.TEXT:
	        					var t: TextInput = new TextInput(selfElement)
		        					.textInput({formItem: formItem});
		        				input = t;
		        				self._getResultFcn = function(): Array<String> {
			        	 			return [t.result()];
			        	 		}
		        			case InputType.TEXTAREA:
	        					var t: Textarea = new Textarea(selfElement)
		        					.textarea({formItem: formItem});
		        				input = t;
		        				self._getResultFcn = function(): Array<String> {
			        	 			return [t.result()];
			        	 		}
		        			case InputType.CHECKBOX:
	        					var t: CheckboxInput = new CheckboxInput(selfElement)
		        					.checkboxInput({formItem: formItem});
		        				input = t;
		        				self._getResultFcn = function(): Array<String> {
			        	 			return t.result();
			        	 		}
		        			case InputType.SELECT: 
		        				var s: Select = new Select(selfElement)
		        					.selectComp({formItem: formItem});
	        					input = s;
	        					self._getResultFcn = function(): Array<String> {
			        	 			return [s.result()];
			        	 		}
		        			case InputType.COMBOBOX: 
		        				var s: Select = new Select(selfElement)
		        					.selectComp({formItem: formItem});
	        					input = s;
	        					self._getResultFcn = function(): Array<String> {
			        	 			return [s.result()];
			        	 		}
		        			case _:

		        		}
		        	}



		        	// var question: Question = self.options.question;
        			// switch (question.qtype) {
		        	//  	case QuestionType.RADIO: {
		        	//  		var radio: Radio = new Radio("<div></div>");
		        	//  		selfElement.append(radio);
		        	//  		radio.radio(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [radio.result()];
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.CHECKBOX: {
		        	//  		var cb = new Checkbox("<div></div>");
		        	//  		selfElement.append(cb);
		        	//  		cb.checkbox(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return cb.result();
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.SELECT: {
		        	//  		var s: Select = new Select("<div></div>");
		        	//  		selfElement.append(s);
		        	//  		s.selectComp(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [s.result()];
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.TEXT: {
		        	//  		var t: TextComp = new TextComp("<div></div>");
		        	//  		selfElement.append(t);
		        	//  		t.textComp(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [t.result()];
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.DATE: {
		        	//  		var t: DateComp = new DateComp("<div></div>");
		        	//  		selfElement.append(t);
		        	//  		t.dateComp(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [t.result()];
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.TEXTAREA: {
		        	//  		var t: Textarea = new Textarea("<div></div>");
		        	//  		selfElement.append(t);
		        	//  		t.textarea(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [t.result()];
		        	//  		}
		        	//  	}
		        	//  	case QuestionType.URL: {
		        	//  		var t: UrlQ = new UrlQ("<div></div>");
		        	//  		selfElement.append(t);
		        	//  		t.urlQ(self.options);
		        	//  		self._getResultFcn = function(): Array<String> {
		        	//  			return [];
		        	//  		}
		        	//  	}
	        		// }
		        },

		        validate: function(): Array<FormError> {
		        	var self: FormInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	var errors: Array<FormError> = new Array();
		        	if(self.options.formItem.validators.hasValues()) {
		        		for(validator in self.options.formItem.validators) {
		        			var validationResult: Dynamic = validator(self._getResultFcn());
		        			var processResult = function(result: Dynamic) {
		        				if(result == null) {
			        				//do nothing
			        			} else if(Std.is(result, Bool) && !result) {
			        				errors.push(new FormError(selfElement, "Validation Error"));
			        			} else if(Std.is(result, String) && StringHelper.isNotBlank(result)) {
			        				errors.push(new FormError(selfElement, result));
		        				} else if(Std.is(result, FormError)){ 
		        					errors.push(result);
			        			} else {
			        				Logga.DEFAULT.warn("unexpected return type from validation function");
			        			}
		        			};
		        			if(JQ.isArray(validationResult)) {
		        				var valResArr: Array<Dynamic> = validationResult;
		        				for(res_ in valResArr) {
		        					processResult(res_);
		        				}
		        			} else {
		        				processResult(validationResult);
		        			}
		        		}
	        		}
	        		 // else if(self.options.formItem.required)

		        	return errors;
	        	},

		        result: function(): Array<String> {
		        	var self: FormInputWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

	        		var answers: Array<String> = self._getResultFcn();
	        		if(answers.hasValues()) {
	        			answers.unshift(self.options.formItem.name);
	        			return answers;
	        		} else return null;
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.formInput", defineWidget());
	}
}