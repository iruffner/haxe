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
	@:optional var defaultPositionIconWrapper: JQ;
	var originalSize: UISize;
	var originalPosition: UIPosition;
	var originalScrollPosition: UIPosition;
	var _create: Void->Void;
	var close: Void->Void;
	var open: Void->Void;
	var restore: Void->Void;
	var maximize: Void->Void;
	var destroy: Void->Void;
	var defaultPosition: Void->Void;
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

		        originalPosition: {
		        	top: 20,
		        	left: 20
		        },

		        originalScrollPosition: {
		        	top: 0,
		        	left: 0
		        },

		        _create: function(): Void {
		        	cast (JQ.curNoWrap)._super('create');
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();
					var closeBtn: JQ = selfElement.prev().find(".ui-dialog-titlebar-close");
					var hovers: JQ = new JQ("blah");
					var window: JQ = new JQ(js.Browser.window);

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
								return false;
						});
					}

					self.restoreIconWrapper = new JQ("<a href='#' class='ui-dialog-titlebar-close ui-corner-all' style='margin-right: 18px; display: none;' role='button'>");
					var restoreIcon: JQ = new JQ("<span class='ui-icon ui-icon-newwin'>restore</span>");
					hovers = hovers.add(self.restoreIconWrapper);
					self.restoreIconWrapper.append(restoreIcon);
					closeBtn.before(self.restoreIconWrapper);
					self.restoreIconWrapper.click(function(evt: JQEvent) {
							self.restore();
							return false;
					});

					self.defaultPositionIconWrapper = new JQ("<a href='#' class='ui-dialog-titlebar-close ui-corner-all' style='margin-right: 39px; padding:2px; text-align: center; font-size:13px;' role='button'>");
					var defaultPositionIcon: JQ = new JQ("<i class='fi-die-one' title='default position'></i>");
					hovers = hovers.add(self.defaultPositionIconWrapper);
					self.defaultPositionIconWrapper.append(defaultPositionIcon);
					self.restoreIconWrapper.before(self.defaultPositionIconWrapper);
					self.defaultPositionIconWrapper.click(function(evt: m3.jq.JQEvent){
						self.defaultPosition();
						return false;
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
					var window: JQ = new JQ(js.Browser.window);
 
					//restore the orignal dimensions
					//expand dialog
					selfElement.parent().css({
							top: self.originalPosition.top,
							left:self.originalPosition.left,
							width: self.originalSize.width,
							height: self.originalSize.height
						});
					
					var contentHeight : Float = selfElement.parent().height()
					 	- selfElement.parent().children(".ui-dialog-titlebar").height()
					 	- selfElement.parent().children(".ui-dialog-buttonpane").height() - 50; //bit nasty, need maybe a better way
					var contentWidth = selfElement.parent().width()-30;
		        		selfElement.css({
							height: contentHeight,
							width: contentWidth
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
					selfElement.parent().css({
							top: window.scrollTop() + 20,
							left: window.scrollLeft() + 20,
							width: windowDimensions.width - 50, 
							height: windowDimensions.height - 50,
						});

					var contentHeight : Float = selfElement.parent().height()
					 	- selfElement.parent().children(".ui-dialog-titlebar").height()
					 	- selfElement.parent().children(".ui-dialog-buttonpane").height() - 50; //bit nasty, need maybe a better way
					var contentWidth = selfElement.parent().width()-30;

					selfElement.css({
							height: contentHeight,
							width: contentWidth
						});

					//swap buttons to show restore
					self.maxIconWrapper.hide();
					self.restoreIconWrapper.show();
					self.options.onMaxToggle();

				},

				defaultPosition: function() {
					var self: M3DialogWidgetDef = Widgets.getSelf();
					var selfElement: M3Dialog = Widgets.getSelfElement();

					selfElement.parent().css({
						width:	self.options.width, 
						height: self.options.height,
					});

					trace(self.options.width);
					trace(self.options.height);


					var contentHeight : Float = selfElement.parent().height()
				 	 	- selfElement.parent().children(".ui-dialog-titlebar").height()
					 	- selfElement.parent().children(".ui-dialog-buttonpane").height() - 50; //bit nasty, need maybe a better way
					var contentWidth = selfElement.parent().width()-30;

					selfElement.css({
							height: contentHeight,
							width: contentWidth
						});

					selfElement.parent().position({
		        			at: "middle",
		        			my: "middle",
		        			of: js.Browser.window
		        		});

					var localStorage = js.Browser.getLocalStorage();
					var key = "dialog_position_"+selfElement.attr('id');
					localStorage.removeItem(key);

					//swap the buttons
					self.restoreIconWrapper.hide();
					self.maxIconWrapper.show();
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
		        	var window: JQ = new JQ(js.Browser.window);
		        	var pos = haxe.Json.parse(localStorage.getItem(key));

		        	//Because Json parse returns strings we have to turn them into Numbers

		        	var position = null;
		        	if(pos != null) {
			        	position = {
			        			top:	Std.parseInt(pos.top),
			        			left:	Std.parseInt(pos.left),
			        			width:	Std.parseInt(pos.width),
			        			height: Std.parseInt(pos.height)
			        		}
		        	}
		        	var dialogMaxWidth = Math.round(window.width() - 50);
		        	var dialogMaxHeight = Math.round(window.height() - 50);

		        	if(position != null && (position.left != null || position.top != null)){

		        		selfElement.parent().position({
		        			at: "left+"+position.left+" top+"+position.top,
		        			my: "left top",
		        			of: js.Browser.window
		        		});
		        	}
		        	else {
		        		self.defaultPosition();
		        	}

		        	if(position != null && (position.width != null || position.height != null)){
		        		position.width = (position.width > dialogMaxWidth)?dialogMaxWidth:position.width;
		        		position.height = (position.height > dialogMaxHeight)?dialogMaxHeight:position.height;

		        		//If bth width and height is larger than the current screen - padding we maximize the window
		        		if(position.width >= dialogMaxWidth && position.height >= dialogMaxHeight)
		        		{
		        			self.maximize();
		        		}
		        		else //we reduce the width/height until fitss the window
		        		{
		        			selfElement.parent().width(position.width);
		        			selfElement.parent().height(position.height);

		        			//swap buttons to show maximize
							self.maxIconWrapper.show();
							self.restoreIconWrapper.hide();
							self.options.onMaxToggle();

							//dialog is always have to be on the screen
							if(position.height+position.top > dialogMaxHeight)
							{
								position.top = (dialogMaxHeight - position.height + 20);
							}

							if(position.width+position.left > dialogMaxWidth)
							{
								position.left = (dialogMaxWidth - position.width + 20);
							}

							selfElement.parent().position({
		        				at: "left+"+position.left+" top+"+position.top,
		        				my: "left top",
		        				of: js.Browser.window
		        			});
		        		}
		        		selfElement.parent().width(position.width);
		        		selfElement.parent().height(position.height);

						var contentHeight : Float = selfElement.parent().height()
				 	 		- selfElement.parent().children(".ui-dialog-titlebar").height()
					 		- selfElement.parent().children(".ui-dialog-buttonpane").height() - 50; //bit nasty, need maybe a better way
		        		selfElement.css({
							height: contentHeight
						});
		        	}
		        },

		        close: function()
		        {
		        	var self: M3DialogWidgetDef = Widgets.getSelf();
		        	var selfElement: M3Dialog = Widgets.getSelfElement();
		        	var positionkey = "dialog_position_"+selfElement.attr('id');
		        	var localStorage = js.Browser.getLocalStorage();
		        	var window: JQ = new JQ(js.Browser.window);
		        	var pos = selfElement.parent().position();
		        	var position = {
		        			top:	pos.top-window.scrollTop(), //relative to window
		        			left:	pos.left-window.scrollLeft(),
		        			width: 	selfElement.parent().width(),
		        			height: selfElement.parent().height()
		        		}

		        	localStorage.setItem(positionkey, haxe.Json.stringify(position));

		        	self._super();
		        }
		    };
		}
		JQ.widget( "ui.m3dialog", JQ.ui.dialog, defineWidget());
	}
}