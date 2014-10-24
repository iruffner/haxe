package m3.util;

import m3.CrossMojo;
import m3.jq.JQ;
// import m3.jq.JQDialog;

using m3.jq.M3Dialog;
using m3.helper.StringHelper;

@:expose
class JqueryUtil {

	public static function isAttached(elem: JQ): Bool {
		return elem.parents("body").length > 0;
		// return JQ.contains(js.Lib.document.body, (Reflect.hasField(elem, "jquery") ? elem[0] : cast elem) );
	}

	public static function labelSelect(elem: JQ, str: String): Void {
		try {
			untyped CrossMojo.jq('option', elem).filter(function() {
		       return JQ.cur.text() == str;
		    })[0].selected = true;
		} catch (err: Dynamic) {
			//TODO generic log access
			// App.LOGGER.error("Attempted to select " + str + " but it was not a valid option");
		}
	}

	public static function getOrCreateDialog(selector:String, ?dlgOptions: M3DialogOptions, ?createdFcn: JQ->Void): M3Dialog {
		if(selector.isBlank()) {
	        selector = "dlg" + UidGenerator.create(10);
	    }
	    var dialog: M3Dialog = new M3Dialog(selector);
	    if(dlgOptions == null) {
	        dlgOptions = {
	            autoOpen: false,
	            height: 380,
	            width: 320,
	            modal: true
	        };
	    }
	    if(!dialog.exists()) {
	        dialog = new M3Dialog("<div id=" + selector.substr(1) + " style='display:none;'></div>");
	        if(Reflect.isFunction(createdFcn)) {
	        	createdFcn(dialog);
	        }
	        new JQ('body').append(dialog);
	        dialog.m3dialog(dlgOptions);
	    } else if(!dialog.is(':data(dialog)') ) {
	        dialog.m3dialog(dlgOptions);
	    }
	    if(dialog.exists()) {
	    	dialog.parents(".ui-dialog").addClass("dialog");
	    }
	    return dialog;
	}

	public static function deleteEffects(dragstopEvt: JQEvent, width:String = "70px", duration:Int=800, src:String="media/cloud.gif") {
    	var img: JQ = new JQ("<img/>");
		img.appendTo("body");
		img.css("width", width);
		img.position({
				my: "center",
				at: "center",
				of: dragstopEvt,
				collision: "fit"
		});
		img.attr("src", src);

		haxe.Timer.delay(
			function() {
				img.remove();
			}, 
			duration 
		);
	}

	/**
	 * Displays a confimration dialog box
	 * @param title:String The title of the dialog box
	 * @param question:String The question to ask
	 * @param action:Function The function to call if the user pressed YES.
	 */
	public static function confirm(title:String, question:String, action: Void->Void, ?width: Dynamic = "auto", ?height: Int = 150): Void {
		var dlgOptions: M3DialogOptions = {
	       		modal: true, 
	       		title: title, 
	       		zIndex: 10000, 
	       		autoOpen: true,
	            // width: 'auto',
	            resizable: false,
	            width: width,
	            height: height,
                buttons: {
                    Yes: function () {
                        action();
                        M3Dialog.cur.close();
                    },
                    No: function () {
                        M3Dialog.cur.close();
                    }
                },
                close: function () {
                    M3Dialog.cur.remove();
                }
	    };
		var dlg: M3Dialog = getOrCreateDialog("#confirm-dialog", dlgOptions);
		var content = new JQ('<div style="text-align:left;">' + question + '</div>');
		dlg.append(content);
		if(!dlg.isOpen()) {
            dlg.open();
        }
	}

	/**
	 * Displays an alert dialog box
	 * @param statement:String The statement to display
	 * @param title:String The title of the dialog box
	 * @param action:Function The function to call after the user closes the dialog
	 */
	public static function alert(statement:String, title:String="Alert", ?action:Void->Void, ?width: Dynamic = "auto", ?height: Int = 175): Void {
		var dlgOptions: M3DialogOptions = {
	       		modal: true, 
	       		title: title, 
	       		zIndex: 10000, 
	       		autoOpen: true,
	            // width: 'auto',
	            resizable: false,
                width: width,
	            height: height,
	            buttons: {
                    OK: function () {
                        M3Dialog.cur.close();
                    }
                },
                close: function () {
                	if (action != null) {
                		action();
                	}
                    M3Dialog.cur.remove();
                }
	    };
		var dlg: M3Dialog = getOrCreateDialog("#alert-dialog", dlgOptions);
		var content = new JQ('<div style="text-align:left;">' + statement + '</div>');
		dlg.append(content);
		if(!dlg.isOpen()) {
            dlg.open();
        }
	}

	public static function getWindowWidth(): Int {
		return new JQ(js.Browser.window).width();
	}

	public static function getWindowHeight(): Int {
		return new JQ(js.Browser.window).height();
	}

	public static function getDocumentWidth(): Int {
		return new JQ(js.Browser.document).width();
	}

	public static function getDocumentHeight(): Int {
		return new JQ(js.Browser.document).height();
	}

	public static function getEmptyDiv(): JQ {
		return new JQ("<div></div>");
	}

	public static function getEmptyTable():JQ {
		return new JQ("<table style='margin:auto; text-align: center; width: 100%;'></table>");
	}

	public static function getEmptyRow():JQ {
		return new JQ("<tr></tr>");
	}
	
	public static function getEmptyCell():JQ {
		return new JQ("<td></td>");
	}


}

