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
	@:optional var img: String;
	@:optional var icon: String;
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
		            		img: "/images/generic_profile.png",
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
		        		var iconimg : String = "";

		        		var elemString: String = "<li class=\"ui-state-default\">";
		        		if(um.img != "" && um.img != null){
		        			elemString = elemString + "<img src=\""+um.img+"\">";
		        		}else if(um.icon != "" && um.icon != null){
		        			elemString = elemString + "<i class=\""+um.icon+"\"></i>";
		        		}
		        		elemString = elemString + "&nbsp&nbsp"+um.name+"</li>";

		        		var elem: JQ = new JQ(elemString)
			        		.hover(function(evt: JQEvent){
	                    				if(JQ.cur.hasClass('ui-state-hover')){
	                    					JQ.cur.removeClass('ui-state-hover');
	                    					JQ.cur.addClass('ui-state-default');
	                    				}else{
	                    					JQ.cur.removeClass('ui-state-default');
	                    					JQ.cur.addClass('ui-state-hover');
	                    				}
		                    		})
			        		.click(function(){
			        			if(Reflect.isFunction(um._callback)){
			        				um._callback();
		        				}else{
		        					trace('_callback not a function');
		        				}
        					});
		        		new JQ("#userMenuContent").append(elem);
	        		}

					new JQ("#userMenuBtn").click(function(){
						new JQ("#userMenuContent").toggle();
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