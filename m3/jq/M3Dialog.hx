package m3.jq;

import m3.jq.JQ;
import m3.widget.Widgets;
import m3.log.Logga;

typedef M3DialogOptions = {
	@:optional var autoOpen:Bool;
	@:optional var height:Dynamic;
	@:optional var width: Dynamic;
	@:optional var modal: Bool;
	@:optional var title: String;
	@:optional var buttons: Dynamic;
	@:optional var close: Void->Void;
	@:optional var position: Array<Float>;
	@:optional var showMaximizer: Bool;
	@:optional var showHelp: Bool;
	@:optional var buildHelp: Void->Void;
	@:optional var onMaxToggle: Void->Void;
	@:optional var zIndex:Int;
	@:optional var resizable: Bool;
	@:optional var allowInteraction: JQEvent->Bool;
}

typedef M3DialogWidgetDef = {
	var options: M3DialogOptions;
	@:optional var maxIconWrapper: JQ;
	@:optional var restoreIconWrapper: JQ;
	var originalSize: UISize;
	var _create: Void->Void;
	var close: Void->Void;
	var open: Void->Void;
	var restore: Void->Void;
	var maximize: Void->Void;
	var destroy: Void->Void;
	var _allowInteraction: JQEvent->Bool;

	@:optional var _super: Dynamic;
}

class M3DialogHelper {
	public static function close(dlg: M3Dialog): Void {
		dlg.m3dialog("close");
	}

	public static function open(dlg: M3Dialog): Void {
		dlg.m3dialog("open");
	}

	public static function isOpen(dlg: M3Dialog): Bool {
		return dlg.m3dialog("isOpen");
	}
}

@:native("$")
extern class M3Dialog extends JQ {
	
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd:String, opt:String, ?newVal: Dynamic):T{})
	function m3dialog(opts: M3DialogOptions): M3Dialog;

	static var cur(get, null): M3Dialog;
	private static inline function get_cur() : M3Dialog {
		return untyped __js__("$(this)");
	}

	private static function __init__(): Void {
		// untyped M3Dialog = window.jQuery;

		var defineWidget: Void->M3DialogWidgetDef = function(): M3DialogWidgetDef {

			var localStorage = js.Browser.getLocalStorage();

			return {
		        options: {
		            autoOpen: true
			        , height: 320
			        , width: 320
			        , modal: true
			        , buttons: {
			   //      	"Cancel" : function() {
						// 	M3Dialog.cur.M3Dialog("close");
						// }
			        }
			        , showHelp: false
			        , onMaxToggle: JQ.noop
		        },

		        originalSize: {
		        	width: 10,
		        	height: 10
		        },

		        _create: function(): Void {
		        	cast (JQ.curNoWrap)._super('create');
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
					var closeBtn: JQ = selfElement.prev().find(".ui-dialog-titlebar-close");
					var hovers: JQ = new JQ("blah");

					if(self.options.showHelp && false) {
						if(!Reflect.isFunction(self.options.buildHelp)) {
							Logga.DEFAULT.error("Supposed to show help but buildHelp is not a function");
						} else {
							var helpIconWrapper: JQ = new JQ("<a href='#' class='ui-dialog-titlebar-close ui-corner-all' style='margin-right: 18px;' role='button'>");
							var helpIcon: JQ = new JQ("<span class='ui-icon ui-icon-help'>help</span>");
							hovers = hovers.add(helpIconWrapper);
							helpIconWrapper.append(helpIcon);
							closeBtn.before(helpIconWrapper);
							helpIconWrapper.click(function(evt: JQEvent) {
									self.options.buildHelp();
							});
						}

					}
					if(self.options.showMaximizer) {
						self.maxIconWrapper = new JQ("<a href='#' class='ui-dialog-titlebar-close ui-corner-all' style='margin-right: 18px;' role='button'>");
						var maxIcon: JQ = new JQ("<span class='ui-icon ui-icon-extlink'>maximize</span>");
						hovers = hovers.add(self.maxIconWrapper);
						self.maxIconWrapper.append(maxIcon);
						closeBtn.before(self.maxIconWrapper);
						self.maxIconWrapper.click(function(evt: JQEvent) {
								self.maximize();
						});
					}

					self.restoreIconWrapper = new JQ("<a href='#' class='ui-dialog-titlebar-close ui-corner-all' style='margin-right: 18px; display: none;' role='button'>");
					var restoreIcon: JQ = new JQ("<span class='ui-icon ui-icon-newwin'>restore</span>");
					hovers = hovers.add(self.restoreIconWrapper);
					self.restoreIconWrapper.append(restoreIcon);
					closeBtn.before(self.restoreIconWrapper);
					self.restoreIconWrapper.click(function(evt: JQEvent) {
							self.restore();
					});

					hovers.hover(function(evt: JQEvent) {
							JQ.cur.addClass("ui-state-hover");
						}, function(evt: JQEvent) {
							JQ.cur.removeClass("ui-state-hover");
						}
					);
		        },

		        _allowInteraction: function( event ): Bool {
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
		        	var r: Bool = false;
		        	if(self.options.allowInteraction != null) {
		        		r =  !!self.options.allowInteraction(event);
		        	}
		        	return r || self._super( event );
				},

		        restore: function() {
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
					var selfElement: M3Dialog = Widgets.getSelfElement();
 
					//restore the orignal dimensions
					selfElement.m3dialog("option", "height", self.originalSize.height);
					selfElement.m3dialog("option", "width", self.originalSize.width);
					selfElement.parent().position({
							my: "middle",
							at:	"middle",
							of:	js.Browser.window
						});
				 
					//swap the buttons
					self.restoreIconWrapper.hide();
					self.maxIconWrapper.show();
					self.options.onMaxToggle();
				},

				maximize: function() { 
					var self: M3DialogWidgetDef = Widgets.getSelf();
					var selfElement: M3Dialog = Widgets.getSelfElement();

					//Store the original height/width
					self.originalSize = { height: selfElement.parent().height(), width: selfElement.parent().width() };
				 	
				 	var window: JQ = new JQ(js.Browser.window);
				 	var windowDimensions: UISize = { height: window.height(), width: window.width() };
					//expand dialog
					// selfElement.parent().css({
					// 		width: windowDimensions.width * .85, 
					// 		height: windowDimensions.height * .85
					// 	});
					selfElement.m3dialog("option", "height", windowDimensions.height * .85);
					selfElement.m3dialog("option", "width", windowDimensions.width * .85);
					selfElement.parent().position({
							my: "middle",
							at:	"middle",
							of:	js.Browser.window
					});
				 
					//swap buttons to show restore
					self.maxIconWrapper.hide();
					self.restoreIconWrapper.show();

					self.options.onMaxToggle();
				},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        },

		        open: function(){
		        	var self: M3DialogWidgetDef = Widgets.getSelf();

					self._super();

		        	var selfElement: M3Dialog = Widgets.getSelfElement();
		        	var key = "dialog_position_"+selfElement.attr('id');
		        	var position = haxe.Json.parse(localStorage.getItem(key));

		        	if(position != null && (position.left != null || position.top != null)){
		        		selfElement.parent().position({
		        			at: "left+"+position.left+" top+"+position.top,
		        			my: "left top",
		        			of: js.Browser.window
		        		});
		        	}
		        	else {
		        		selfElement.parent().position({
		        			at: "middle",
		        			my: "middle",
		        			of: js.Browser.window
		        		});
		        	}
		        },

		        close: function()
		        {
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
		        	var selfElement: M3Dialog = Widgets.getSelfElement();
		        	var key = "dialog_position_"+selfElement.attr('id');
		        	var localStorage = js.Browser.getLocalStorage();
		        	var window: JQ = new JQ(js.Browser.window);
		        	var position = selfElement.parent().position();
		        	position.top -= window.scrollTop();
		        	position.left -= window.scrollLeft();

		        	localStorage.setItem(key, haxe.Json.stringify(position));

		        	self._super();
		        }
		    };
		}
		JQ.widget( "ui.m3dialog", JQ.ui.dialog, defineWidget());
	}
}