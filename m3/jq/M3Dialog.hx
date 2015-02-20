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
	var originalPosition: UIPosition;
	var _create: Void->Void;
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

		        originalPosition: {
		        	top: 10,
		        	left: 10
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
					if(self.options.showMaximizer = true) {
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
					//expand dialog
					selfElement.parent().css({
							top: self.originalPosition.top,
							left:self.originalPosition.left,
							width: self.originalSize.width, 
							height: self.originalSize.height
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
				 	var window: JQ = new JQ(js.Browser.window);

				 	self.originalPosition = {
						top: selfElement.parent().position().top,
						left: selfElement.parent().position().left,
				 	};

					self.originalSize = { 
						height: selfElement.parent().height(), 
						width: selfElement.parent().width() 
					};

				 	var windowDimensions: UISize = {
				 		height: window.height(), 
				 		width: window.width() 
				 	};

					//expand dialog
					trace(selfElement.parent());
					selfElement.parent().css({
							top: 20,
							left:20,
							width: windowDimensions.width - 50, 
							height: windowDimensions.height - 50
						});

					//swap buttons to show restore
					self.maxIconWrapper.hide();
					self.restoreIconWrapper.show();

					self.options.onMaxToggle();
				},
		        
		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.m3dialog", JQ.ui.dialog, defineWidget());
	}
}