package m3.forms.inputs;

import js.html.Element;

import m3.jq.JQ;
import m3.jq.JQTooltip;
import m3.widget.Widgets;

import m3.exception.Exception;
import m3.exception.ValidationException;
import m3.log.Logga;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using m3.forms.FormInput;
using m3.forms.FormBuilder;

typedef ACComboBoxOptions = {
	>FormInputOptions,
	@:optional var customCssOnInput: String;
	@:optional var customCssOnSpan: String;
}

class ACComboBoxHelper {
	public static function result(s: ACComboBox): String {
		return s.accomboBox("result");
	}
}

typedef ACComboBoxWidgetDef = {
	@:optional var options: ACComboBoxOptions;
	var _create: Void->Void;
	@:optional var _trigger: String->js.JQuery.JqEvent->Dynamic->Void;
	var result: Void->String;
	var destroy: Void->Void;
	@:optional var input: JQTooltip;
	@:optional var select: JQ;
	@:optional var iconDiv: JQ;

	@:optional var _super: Dynamic;
	@:optional var getDefaultValue: Dynamic;
	@:optional var wrapper: JQ;
}

@:native("$")
extern class ACComboBox extends AbstractInput {
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):ACComboBox{})
	function accomboBox(opts: FormInputOptions): ACComboBox;
	
	@:overload(function( selector: JQ ) : ACComboBox{})
	@:overload(function( selector: Element ) : ACComboBox{})
	override function appendTo( selector: String ): ACComboBox;

	private static function __init__(): Void {
		// untyped ACComboBox = window.jQuery;
		var defineWidget: Void->ACComboBoxWidgetDef = function(): ACComboBoxWidgetDef {
			return {
/*				options: {
					customCssOnInput: ""
				},	*/			
				_create: function(): Void {
					var self: ACComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

	                var commonClasses: String = "text ui-widget-content ui-corner-all filter";
	                var commonProperties: String = "name='test' id='test'";
	                var autocomplete = selfElement.children("ul.ui-autocomplete");

                    self.select = new JQ("<select class=\"text ui-widget-content ui-corner-all filter\"></select>").hide();
                    self.input = null;
					var selected = self.select.children( ":selected" ),
	                    value = selected.val() != null ? selected.text() : "",
	                    wrapper: JQ = self.wrapper = new JQ( "<span>" )
	                        .addClass( "ui-combobox" )
	                        .insertAfter( self.select )
	                        .attr( "style", "white-space:nowrap;margin-right:40px;padding-left:2px;" /*+ M.getX(self.options.customCssOnSpan, "")*/ );                       
	 
	 				selfElement.addClass("center");
	 				self._super();

	 				selfElement.append(self.input);
	 				selfElement.append(self.select).append(wrapper).append(self.iconDiv).show();

/*	                function removeIfInvalid(element: JQ): Dynamic {
	                    var value = element.val(),
	                        matcher = new EReg( "^" + JQ.ui.autocomplete.escapeRegex( value ) + "$", "i" ),
	                        valid = false;
	                    select.children( "option" ).each(function(indexInArray: Int, valueOfElement: Element): Void {
	                        if ( matcher.match(JQ.cur.text()) ) {
	                            cast (JQ.curNoWrap).selected = valid = true;
	                            return null;
	                        }
	                    });
	                    if ( !valid ) {
	                        // remove invalid value, as it didn't match anything
	                        cast(
	                        	new JQ( element )
		                            .val( "" )
		                            .attr( "title", value + " didn't match any item" ),
	                            JQTooltip)
		                            .tooltip( "open" );
	                        select.val( "" );
	                        haxe.Timer.delay(function() {
	                            input.tooltip( "close" ).attr( "title", "" );
	                        }, 2500 );
	                        input.data( "ui-autocomplete" ).term = "";
	                        return false;
	                    }
	                    return null;
	                }*/

					var question: FormItem = self.options.formItem;
	       			var choices: Array<Array<String>> = {
        				if(Reflect.isFunction(question.options)) {
        					question.options();
        				} else {
        					question.options;
        				}
        			}

        			var answer : String = null;
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

        			if(choices != null && choices.length != 0){
			        	for(option in choices) {
			        		var opt: JQ = new JQ("<option></option>")
			        								.attr("value", option[0])
			        								.appendTo(self.select)
			        								.append(option[1]);
			        		if(answers.contains(option[1])) {
			        			opt.attr("selected", "selected");
			        			answer = option[1];
			        		}
			        	}
			        }

                    self.select.change(function(evt: js.JQuery.JqEvent) {
	                    var label = self.select.children('[value="' + self.select.val() + '"]').text();
	                    self.input.val(label); 
	                });

	                self.input = new JQTooltip( "<input>" );
                    self.input.appendTo( wrapper )
	                    .val( value )
	                    .attr( {"title": "" , "style": self.options.customCssOnInput} )
	                    .addClass( "ui-combobox-input" )
	                    //.addClass( "ui-accomboBox-input" )
	                    .autocomplete({
	                        delay: 0,
	                        minLength: 0,
	                        source: function( request, response ) {
	                            var matcher = new EReg( JQ.ui.autocomplete.escapeRegex(request.term), "i" );
	                            response( self.select.children( "option" ).map(function(elementOfArray: JQ, indexInArray:Int): Dynamic {
	                                var text = JQ.cur.text();
	                                var valU = cast (JQ.curNoWrap).value;
	                                if ( valU && ( !request.term || matcher.match(text) ) )
	                                    return {
	                                        label: text.replaceAll(
	                                            new EReg(
	                                                "(?![^&;]+;)(?!<[^<>]*)(" +
	                                                JQ.ui.autocomplete.escapeRegex(request.term) +
	                                                ")(?![^<>]*>)(?![^&;]+;)", "gi"
	                                            ), "<strong>$1</strong>" ),
	                                        value: text,
	                                        option: JQ.curNoWrap
	                                    };
                                    return null;
	                            }) );
	                        },
	                        select: function( event: js.JQuery.JqEvent, ui: Dynamic ): Void {
	                            ui.item.option.selected = true;
	                            self._trigger( "selected", event, {
	                                item: ui.item.option
	                            });
	                            self.select.change();
	                        },
	                        change: function( event: js.JQuery.JqEvent, ui: Dynamic ): Dynamic {
	                            //if ( ui.item == null )
	                                //return removeIfInvalid( JQ.cur );
                                return null;
	                        },
	                        open: function( event: js.JQuery.JqEvent, ui: Dynamic ): Void {
	                        	if(autocomplete == null || autocomplete.length == 0){
	                        		autocomplete = new JQ("ul.ui-autocomplete");
	                        	}                    	
	                        }
	                    })
	                    .addClass( "ui-widget ui-widget-content ui-corner-left" )
	                    .click(function(evt: js.JQuery.JqEvent) {
	                    	JQ.cur.select();
            		});
            		//.appendTo(selfElement.parent());	
                		

					self.input.data( "ui-autocomplete" )._renderItem = function( ul, item ) {
	                    return new JQ( "<li>" )
	                        .data( "item.autocomplete", item )
	                        .append( "<a>" + item.label + "</a>" )
	                        .appendTo( ul );
	                };
	 
	                var a: JQTooltip = new JQTooltip( "<a>" );
                    a.attr({
                		"tabIndex": -1,
                		"title": "Show All Items" 
					});

                    a.tooltip();
                    a.appendTo( wrapper )
                    .button({
                        icons: {
                            primary: "ui-icon-triangle-1-s"
                        },
                        text: false
                    })
                    .removeClass( "ui-corner-all" )
                    .addClass( "ui-corner-right ui-combobox-toggle" )
                    .click(function() {
                        // close if already visible
                        if ( self.input.autocomplete( "widget" ).is( ":visible" ) ) {
                            self.input.autocomplete( "close" );
                            //removeIfInvalid( input );
                            return;
                        }
 
                        // work around a bug (likely same cause as #5265)
                        JQ.cur.blur();
 
                        // pass empty string as value to search for, displaying all results
                        self.input.autocomplete( "search", "" );
                        self.input.focus();
                    });
 
                    self.input.tooltip({
                        position: {
                            of: cast (JQ.curNoWrap).button
                        },
                        tooltipClass: "ui-state-highlight"
                    });
                    if (answer != "") self.input.val(answer);
                    //selfElement.append(autocomplete).show();
		        },

		        result: function(): String {
		        	var self: ACComboBoxWidgetDef = Widgets.getSelf();
					return self.input.val();
	        	},
		        
		        destroy: function() {
		        	var self: ACComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
		        	self.wrapper.remove();
		        	self.input.remove();
		        	self.select.remove();
	                selfElement.show();
	                untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    }
		}
		JQ.widget( "ui.accomboBox", (untyped $.ui.abstractInput), defineWidget());
	}
}