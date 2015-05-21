package m3.jq;

import m3.jq.JQ;
import m3.jq.JQTooltip;
import m3.util.M;
import js.html.Element;

import m3.widget.Widgets;

using m3.helper.StringHelper;

typedef ComboBoxOptions = {
	@:optional var customCssOnWrapper: String;
	@:optional var customCssOnInput: String;
	@:optional var customCssOnSpan: String;
	@:optional var wrapAll: Bool;
}

typedef ComboBoxWidgetDef = {
	var options: ComboBoxOptions;
	var _create: Void->Void;
	
	@:optional var _trigger: String->JQEvent->Dynamic->Void;
	@:optional var _on: JQ->Dynamic->Void;
	var destroy: Void->Void;
	
	@:optional var input: JQTooltip;
	@:optional var innerWrapper: JQ;
	@:optional var outerWrapper: JQ;
	@:optional var _delay: (Void->Void)->Int->Void;
	var _createShowAllButton: Void->Void;
	var _createAutocomplete: Void->Void;
	var _removeIfInvalid: JQEvent->Dynamic->Void;
	var _source: Dynamic->Dynamic->Void;

}

@:native("$")
extern class ComboBox extends JQ {

	function comboBox(?opts: ComboBoxOptions): ComboBox;
	
	private static function __init__(): Void {
		var defineWidget: Void->ComboBoxWidgetDef = function(): ComboBoxWidgetDef {
			return {
				options: {
					customCssOnInput: "",
					wrapAll: true
				},
				_create: function(): Void {
					var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();


					self.innerWrapper = new JQ( "<span>" )
						.addClass( "custom-combobox" )
						.insertAfter( selfElement )
	                    .attr( "style", "white-space:nowrap;" + M.getX(self.options.customCssOnSpan, "") );

	                if(self.options.wrapAll) {
                    	self.outerWrapper = new JQ("<div>").insertBefore(selfElement);
                		self.outerWrapper.append(selfElement).append(self.innerWrapper);
						self.outerWrapper.attr("style", M.getX(self.options.customCssOnWrapper, ""));
                		self.innerWrapper.removeClass("ui-combobox").addClass("ui-combobox-span");
                		self.outerWrapper.addClass("ui-combobox");
                    }
			 
			        selfElement.hide();
			        self._createAutocomplete();
			        self._createShowAllButton();
		        },

		        _createAutocomplete: function() {
		        	var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

			        var selected = selfElement.children( ":selected" ),
			          value = selected.val().isNotBlank() ? selected.text() : "";
			 
			        self.input = new JQTooltip( "<input>" );
			        self.input.appendTo( self.innerWrapper )
			          .val( value )
			          .attr( {"title": "" , "style": self.options.customCssOnInput} )
			          .addClass( "ui-combobox-input ui-widget ui-widget-content ui-corner-left" )
			          .autocomplete({
			            delay: 0,
			            minLength: 0,
			            source: JQ.proxy( self, "_source" ),
			            open: function( event: JQEvent, ui: Dynamic ): Void {
			            	var menu: JQ = new JQ(JQ.cur.autocomplete("widget").data().uiMenu.element).zIndex(1000);
			            	var dialogParent: JQ = menu.parents(".ui-dialog");
			            	if(dialogParent.exists()) {
			            		dialogParent.css("overflow", "visible");
			            	}
			          		var tooltip: JQTooltip = new JQTooltip(self.input);
		          			tooltip.tooltip("close");
                        },
                        close: function( event: JQEvent, ui: Dynamic ): Void {
			            	var menu: JQ = new JQ(JQ.cur.autocomplete("widget").data().uiMenu.element);
			            	var dialogParent: JQ = menu.parents(".ui-dialog");
			            	if(dialogParent.exists()) {
			            		dialogParent.css("overflow", "hidden");
			            	}
                        }
			          });
					selfElement.change(function(evt: JQEvent) {
	                    var label: String = selfElement.children('[value="' + selfElement.val() + '"]').text();
	                    self.input.val(label);
	                });
			        self.input.tooltip({
			            tooltipClass: "ui-state-highlight"
			          });
			 		
			 		self.input.focus(function(evt: JQEvent) {
			 				JQ.cur.select();
			 			});
			        self._on( self.input, {
						autocompleteselect: function( event: JQEvent, ui: {item: {label: String, option: Dynamic, value: String, id: String}} ) {
							ui.item.option.selected = true;
							self._trigger( "select", event, {
							  item: ui.item.option
							});
							selfElement.val(ui.item.id);
							selfElement.trigger("change");
						},
			          	autocompletechange: "_removeIfInvalid",
			          	mouseout: function(){
			          		var tooltip: JQTooltip = new JQTooltip(self.input);
		          			tooltip.tooltip("close");
			          	}
			        });
			      },
			 
			      _createShowAllButton: function() {
			      	var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

			        var input = self.input,
			          wasOpen = false;
			 
			        var a_ = new JQTooltip( "<a>" );
			        a_.attr( "tabIndex", "-1" )
			          .attr( "title", "Show All Items" );
			        a_.tooltip()
			          .appendTo( self.innerWrapper )
			          .button({
			            icons: {
			              primary: "ui-icon-triangle-1-s"
			            },
			            text: false
			          })
			          .removeClass( "ui-corner-all" )
			          .addClass( "ui-combobox-toggle ui-corner-right" )
			          .mousedown(function() {
			            wasOpen = input.autocomplete( "widget" ).is( ":visible" );
			          })
			          .click(function() {
			            input.focus();

			 
			            // Close if already visible
			            if ( wasOpen ) {
			          		var tooltip: JQTooltip = new JQTooltip(self.input);
		          			tooltip.tooltip("close");			            	
			              	return;
			            }
			 
			            // Pass empty string as value to search for, displaying all results
			            input.autocomplete( "search", "" );
			          });
			      },
			 
			      _source: function( request: {term: String}, response ) {
			      	// var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

			        var matcher = new EReg( JQ.ui.autocomplete.escapeRegex(request.term), "i" );
			        response( selfElement.children( "option" ).map(function(el: JQ, i: Int) {
			          var text = JQ.cur.text();
                      var valU = JQ.curNoWrap.value;
			          if ( valU && ( request.term.isBlank() || matcher.match(text) ) )
			            return {
			              // label: text.replaceAll(
                 //                    new EReg(
                 //                        "(?![^&;]+;)(?!<[^<>]*)(" +
                 //                        JQ.ui.autocomplete.escapeRegex(request.term) +
                 //                        ")(?![^<>]*>)(?![^&;]+;)", "gi"
                 //                    ), "<strong>$1</strong>" ),
			        	  label: text, //this is the value that shows in the search list
			              value: text, //this is the value that will show up in the text box
			              option: JQ.cur, //this is the html option element
			              id: valU //this is the value that will get applied to the original html select element
			            };
		            	else {
		            		return null;
		            	}
			        }) );
			      },
			 
			      _removeIfInvalid: function( event: JQEvent, ui: {item: Dynamic} ) {
			 		var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

			        // Selected an item, nothing to do
			        if ( ui.item ) {
			          return;
			        }
			 
			        // Search for a match (case-insensitive)
			        var value = self.input.val(),
						valueLowerCase = value.toLowerCase(),
						valid = false;
			        selfElement.children( "option" ).each(function() {
						if ( JQ.cur.text().toLowerCase() == valueLowerCase ) {
							JQ.curNoWrap.selected = valid = true;
							return false;
						}
						return true;
			        });
			 
			        // Found a match, nothing to do
			        if ( valid ) {
			          return;
			        }
			 
			        // Remove invalid value
			        self.input
			          .val( "" )
			          .attr( "title", value + " didn't match any item" );
			        self.input.tooltip( "open" );
			        selfElement.val( "" );
			        self._delay(function() {
			          self.input.tooltip( "close" ).attr( "title", "" );
			        }, 2500 );
			        cast (self.input.autocomplete( "instance" )).term = "";
		      	},
		        
		        destroy: function() {
		        	var self: ComboBoxWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
		        	self.innerWrapper.remove();
	                selfElement.show();
	                untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    }
		}
		JQ.widget( "ui.comboBox", defineWidget());
	}
}