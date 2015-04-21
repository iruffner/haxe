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
	    } else if(!dialog.is(':data(dialog)') && (!dialog.parent().hasClass('ui-dialog')) ) {
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
	            //width: 'auto',
	            resizable: true,
	            width: (width == 'auto')?350:width,//because the content is inserted jst after the dialog is reendered, auotu doesn't work. This is a temporary sollution, need to be improved
	            height: height+70,
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
		var content = new JQ('<div style="text-align:left;" class="statement">' + question + '</div>');
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
	public static function alert(statement:String, title:String="Alert", ?action:Void->Void, ?width: Dynamic = 300, ?height: Int = 175): Void {
		var dlgOptions: M3DialogOptions = {
	       		modal: true, 
	       		title: title, 
	       		zIndex: 10000, 
	       		autoOpen: true,
	            // width: 'auto',
	            resizable: true,
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
		var content = new JQ('<div style="text-align:center; color:#008CBA; font-weight: bold">' + statement + '</div>');
		dlg.append(content);
		if(!dlg.isOpen()) {
            dlg.open();
        }
	}

	public static function error(errors:Dynamic, title:String="Error", ?action:Void->Void, ?width: Dynamic = 600, ?height: Int = 175): Void {
		var statement:String = "";
		var dlgOptions: M3DialogOptions = {
	       	modal: true, 
	       	title: title, 
	       	zIndex: 10000, 
	       	autoOpen: true,
	        resizable: true,
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
		var dlg: M3Dialog = getOrCreateDialog("#error-dialog", dlgOptions);
		if(Std.is(errors, String))
		{
			statement = errors;
		}
		else
		{
			for (i in 0...errors.length)
			{
				statement += '<div class="errorMessage"><p><span class="ui-icon ui-icon-carat-1-s"></span>'+errors[i].message+'</p>'+
								'<pre class="errorMessageStack">'+errors[i].stackTrace+'</pre>'+
							'</div>';
			}
		}
		var content = new JQ('<div>' + statement + '</div>');
		dlg.append(content);

		var window: JQ = new JQ(js.Browser.window);
		var dialogMaxHeight = Math.round(window.height() - 50);

		var contentHeight = dlg.children().height()+20;
		var titleHeight = dlg.parent().children('.ui-dialog-titlebar').height();
		var buttonHeight = dlg.parent().children('.ui-dialog-buttonpane').height();

		var dialogHeight = contentHeight + titleHeight + buttonHeight + 40;
		dialogHeight = (dialogHeight > dialogMaxHeight)?dialogMaxHeight:dialogHeight;
		contentHeight = (dialogHeight <  dialogMaxHeight)?contentHeight:dialogHeight - titleHeight - buttonHeight;
		dlg.setDefHeight(""+dialogHeight+"");

		dlg.height(contentHeight);
		dlg.parent().height(dialogHeight);
		//dlg.parent().children('.ui-dialog-titlebar').css({'background-color': '#de2d0f'});
		dlg.parent().position({
		        			at: "middle",
		        			my: "middle",
		        			of: js.Browser.window
		        		});

		if(!dlg.isOpen()) {
            dlg.open();
        }

        var message:JQ = new JQ('.errorMessage');
        message.click(function(evt: JQEvent) {
			JQ.cur.children('.errorMessageStack').toggle();
			JQ.cur.children('p').children('span.ui-icon').toggleClass('ui-icon-carat-1-s');
		});
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

