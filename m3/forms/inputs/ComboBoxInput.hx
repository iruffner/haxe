package m3.forms.inputs;

import js.html.Element;

import m3.jq.ComboBox;
import m3.jq.JQ;
import m3.jq.JQTooltip;
import m3.util.UidGenerator;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;


typedef ComboBoxInputWidgetDef = {
	@:optional var options: FormInputOptions;
	var _create: Void->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var label: JQ;
	@:optional var input: ComboBox;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
	var _processChoices: Array<Array<String>>->Array<String>->Void;
	var _loadOptions: FormInput->JQ->(Dynamic->Void)->Array<Array<String>>;
	var _addOption: FormInput->Array<Array<String>>->Void;
}

class ComboBoxInputHelper {
	public static function result(s: ComboBoxInput): String {
		return s.comboBoxInput("result");
	}
}

@:native("$")
extern class ComboBoxInput extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):ComboBoxInput{})
	function comboBoxInput(opts: FormInputOptions): ComboBoxInput;
	
	@:overload(function( selector: JQ ) : ComboBoxInput{})
	@:overload(function( selector: Element ) : ComboBoxInput{})
	override function appendTo( selector: String ): ComboBoxInput;

	private static function __init__(): Void {

		var defineWidget: Void->ComboBoxInputWidgetDef = function(): ComboBoxInputWidgetDef {
			return {
				_create: function(): Void {
					var self: ComboBoxInputWidgetDef = Widgets.getSelf();
					var selfElement: FormInput = Widgets.getSelfElement();

		        	selfElement.addClass("_ComboBoxInput center");
	 				self._super();

		        	var question: FormItem = self.options.formItem;

	 				self.iconDiv = new JQ("<div class='iconDiv'></div>");
	        		self.iconDiv.hide();

	        		var multi: String = "";
	        		var defaultValue : String = "No data available...";
	        		var checkForDependencyValue: Void->Void = null;

        			var choices: Array<Array<String>> = {
        				if(question.dependency != null) {
		                    var dependency: FormInput = cast Lambda.find(new JQ("._formInput"), function(el: JQ): Bool {
		                    		var formInput: FormInput = cast el;
		                    		var formItem: FormItem = formInput.getFormItem();
		                    		return formItem.name == question.dependency.name;
		                    	});
		                    if(!dependency.exists()) {
		                        Logga.DEFAULT.error("cannot find the dependency " + question.dependency.name);
		                        [];
		                    } else {
		                        dependency.change(function(evt: JQEvent): Void {
		                        	// if(filterDef.type != "multiselect") {
		                            	untyped self.input[0].selectedIndex = -1;
		                            // }
		                            self.input.change();
		                            var newChoices = question.options();
		                            self._processChoices(newChoices, null);
		                        });
		                        checkForDependencyValue = function() {
		                        	if(dependency.result().hasValues()) {
			                            dependency.change();
			                        }
			                    }
		                    }
        					[];
    					} else if(Reflect.isFunction(question.options)) {
        					question.options();
        				} else {
        					question.options;
        				}
        			}

        			if(choices != null && choices.length > 0){
        				defaultValue = "Please choose...";
        			}

	        		self.input = new ComboBox("<select class='ui-combobox-input ui-widget ui-widget-content' name='" + self.options.formItem.name + "' id='" + self.options.formItem.name + "'" + multi + "><option value=''>"+defaultValue+"</option></select>");
	        		if(question.disabled) {
	        			self.input.attr("disabled", "true");
	        			self.iconDiv.show().addClass("locked");
	        		}


	        		var answers: Array<String> = {
	        			if(self.options.formItem.value != null) {
	        				if(Std.is(self.options.formItem.value, Array)) {
	        					self.options.formItem.value;
	        				} else if(Reflect.isFunction(self.options.formItem.value)) {
	        					self.options.formItem.value();
	        				} else {
	        					[self.options.formItem.value];
	        				}
        				} else {
						 	[];
        				};
        			}

        			self._processChoices(choices, answers);

        			if(checkForDependencyValue != null) {
                        checkForDependencyValue();
                    }
        			
	        		selfElement.append("&nbsp;").append(self.input).append(self.iconDiv);

			        self.input.comboBox({
				    	customCssOnInput: "",
				    	customCssOnSpan: "",
				    	wrapAll: true
			    	});

	        		self.input.change(function(ev){
        				selfElement.validate();
	        		});

	        		selfElement.find(".ui-autocomplete-input").blur(function(ev){
        				selfElement.validate();
	        		});

		        },

		        _processChoices: function(choices: Array<Array<String>>, answers: Array<String>): Void {
					var self: ComboBoxInputWidgetDef = Widgets.getSelf();
		        	
		        	if(choices != null && choices.length != 0){
			        	for(option in choices) {
			        		var opt: JQ = new JQ("<option></option>")
			        								.attr("value", option[0])
			        								.appendTo(self.input)
			        								.append(option[1]);
			        		if(answers.contains(option[0])) opt.attr("selected", "selected");
			        	}
			        }
	        	},

		        _addOption: function(el: FormInput, optArray: Array<Array<String>>): Void {
		        	var self: ComboBoxInputWidgetDef = Widgets.getSelf();

	                var settings: FormInputOptions = self.options;
	                var selectHtml: String = "";
	                var firstOptionSelected: String = 'selected="selected"';
	                if(optArray.hasValues()) {
	                    var numberOfOptions: Int = optArray.length;
	                    var wasASelection: Bool = false;
	                    for(i in 0...numberOfOptions) {
	                        var shouldBeSelected = {
	                        	settings.formItem.value == optArray[i][0];
	                        }
	                        var selected = "";
	                        if(shouldBeSelected) {
	                            wasASelection = true;
	                            selected = "selected='selected'";
	                            firstOptionSelected = "";
	                        }
	                        var label = optArray[i][1];
	                        selectHtml += "<option value='" + optArray[i][0] + "'" + selected + ">" + label + "</option>";
	                    }
	                    
	                 //    if(FilterTypeEnum.dropdown.equals(self.options.type)) {
		                //     if(settings.filter.required == true) {
		                //         selectHtml = '<option value="' + settings.unselectedRequiredValue  + '" ' + firstOptionSelected + '>' + settings.unselectedRequiredText + '</option>' + selectHtml;
		                //     } else {
		                //         selectHtml = '<option value="' + settings.unselectedValue  + '" ' + firstOptionSelected + '>' + settings.unselectedText + '</option>' + selectHtml;
		                //     }
		                // }
	                    
	                    var filter = self.input.html(selectHtml);
	                    if(!wasASelection && numberOfOptions == 1) {
	                        filter.children('option:eq(1)').attr('selected', 'selected');
	                    }
	                    filter.change();
	                } else {
	                	self.input.html(selectHtml);
	                }
	            },

		        _loadOptions: function(el: FormInput, dependency: JQ, callbak: Dynamic->Void): Array<Array<String>> {
		        	var self: ComboBoxInputWidgetDef = Widgets.getSelf();

		        	// var t: FormInputOptions = self.options;
		         //    var opts: Array<Array<String>> = null;
		         //    var parameters: Dynamic = {};
		         //    if(t.formItem.dependency != null) {
		         //        var dataType = DataTypeTools.getDataTypeFromName(t.dependsOn);
		         //        var val: String;
		         //        if(dependency.hasClass("_multiselect")) {
		         //        	var values: Array<String> = cast dependency.val();
		         //        	if(values.hasValues()) {
		         //        		if(values.length == 1) {
		         //        			val = values[0];
		         //        		} else {
		         //        			//multiple parent values are not currently supported
		         //        			val = null;
		         //        		}
	          //       		} else {
	          //       			val = null;
	          //       		}
		         //        } else {
		         //        	val = dependency.val();	
		         //        }

		         //        if(val.isBlank()) {
		         //            if(Reflect.isFunction(callbak)) {
		         //                callbak(opts);
		         //            }
		         //            return opts;
		         //        }
		         //        Reflect.setField(parameters, dataType.parameter, val);
		         //        var parentDataType = DataTypeTools.getDataTypeFromName(t.dependsOn);
		         //        while(parentDataType != null && parentDataType.dependsOn != null) {
		         //            var parentDependency: DataType = DataTypeTools.getDataTypeFromName(parentDataType.dependsOn.name);
		         //            if(parentDependency != null) {
		         //                var dependsOn: DataType = parentDataType.dependsOn;
		         //                if(parentDataType.dependsOn != null && t.mdview != null) {
		         //                    var column = t.mdview.getCube().getFieldFromDataType(parentDataType.dependsOn.name);
		         //                    if(column != null) {
		         //                        dependsOn = DataTypeTools.getDataTypeFromName(column.name);
		         //                    }
		         //                }
		         //                var parentDependencyElement = new JQ(dependency).parent("span").siblings("span").children('#' + dependsOn);
		         //                val = parentDependencyElement.val();
		         //                if(val.isBlank()) {
		         //                    if(Reflect.isFunction(callbak)) {
		         //                        callbak(opts);
		         //                    }
		         //                    return opts;
		         //                }
		         //                Reflect.setField(parameters, parentDependency.parameter, val);
		         //                if(parentDependency.dependsOn != null) {
		         //                    parentDataType = DataTypeTools.getDataTypeFromName(parentDependency.name);
		         //                } else {
		         //                    parentDataType = null;
		         //                }
		         //            }
		         //        }
		         //    }
		            
		         //    return DatatypeCache.loadOptions(t.lookupName, parameters, callbak);
		         return null;
		        },

		        result: function(): String {
		        	var self: ComboBoxInputWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},
		        
		        destroy: function() {
	                untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    }
		}
		JQ.widget( "ui.comboBoxInput", (untyped $.ui.abstractInput), defineWidget());
	}
}