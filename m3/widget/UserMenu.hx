package m3.widget;

import js.html.Element;

import m3.jq.JQ;
import m3.observable.OSet;
import m3.widget.Widgets;

import m3.log.Logga;
import m3.exception.Exception;

using m3.helper.StringHelper;
using m3.helper.StringFormatHelper;
using a8.qubes.model.Zoolander.Menu;
using DateTools;

typedef UserMenuItems = {
	var name: String;
	var _callback: Void->Void;
}

typedef UserMenuOptions = {
	var mdmenus: Array<UserMenuItems>;
}

typedef UserMenuWidgetDef = {
	var options: UserMenuOptions;
	@:optional var menusContainer: JQ;
	
	var _create: Void->Void;
	var destroy: Void->Void;

	var refresh: Void->Void;
	var close: Void->Void;
}

@:native("$")
extern class UserMenu extends JQ {
	@:overload(function(cmd : String):Bool{})
	@:overload(function(cmd : String, arg: Dynamic):Void{})
	@:overload(function(cmd:String, opt:String, newVal:Dynamic):JQ{})
	function userMenu(?opts: UserMenuOptions): UserMenu;

	private static function __init__(): Void {
		var defineWidget: Void->UserMenuWidgetDef = function(): UserMenuWidgetDef {
			return {
		        options: {
		            mdmenus : 
		            	[{
		            		name: "Default", 
		            		_callback: function(){
		            			trace("Default");
		           			}
		           		}]
		        },
		        
		        _create: function(): Void {
		        	var self: UserMenuWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of UserMenu must be a div element");
		        	}

		        	selfElement.addClass("_userMenu secondary");
		        	selfElement.append(new JQ("<ul id=\"userMenuContent\" class=\"ui-state-default\"></ul>").hide());
		        	for(i in 0...self.options.mdmenus.length){
		        		var um: UserMenuItems = self.options.mdmenus[i];
		        		var el: JQ = new JQ("<li class=\"ui-state-default\">"+um.name+"</li>");
		        		new JQ("#userMenuContent").append(
		        			el
		        			.click(um._callback)
			        		.hover(function(evt: JQEvent){
                    				if(el.hasClass('ui-state-hover')){
                    					el.removeClass('ui-state-hover');
                    					el.addClass('ui-state-default');
                    				}else{
                    					el.removeClass('ui-state-default');
                    					el.addClass('ui-state-hover');
                    				}
	                    		})
	                    	);
		        		el.append('<a>').hover(function(){});
	        		}

					new JQ("#userMenuBtn").click(function(){
						new JQ("#userMenuContent").toggle();
					})
					.focusout(function(ev:JQEvent){
						new JQ("#userMenuContent").hide();
					});
		        },

		        refresh: function(){
	        	},

		        close: function(){
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.userMenu", defineWidget());
	}
}