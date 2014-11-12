package m3.forms;

import js.html.Element;

import m3.exception.Exception;
import m3.forms.FormPlugin.IdentityFP;
import m3.jq.JQ;
import m3.jq.M3Dialog;
import m3.util.JqueryUtil;
import m3.widget.Widgets;

using m3.helper.StringFormatHelper;
using m3.forms.FormBuilder;
using m3.forms.FormBuilderDialog.FormBuilderDialogHelper;

typedef FormBuilderDialogOptions = {
	>M3DialogOptions,
	var formItems: Array<FormItem>;
	var onSubmit: Void->Void;
	@:optional var onCancel: Void->Void;
	var formPlugin: FormPlugin;
}

typedef FormBuilderDialogWidgetDef = {
	var options: FormBuilderDialogOptions;

	@:optional var formBuilder: FormBuilder;

	var _create: Void->Void;
	var destroy: Void->Void;

	@:optional var _super: Dynamic;
}

class FormBuilderDialogHelper {
	public static function close(dlg: FormBuilderDialog): Void {
		dlg.formBuilderDialog("close");
	}

	public static function open(dlg: FormBuilderDialog): Void {
		dlg.formBuilderDialog("open");
	}

	public static function isOpen(dlg: FormBuilderDialog): Bool {
		return dlg.formBuilderDialog("isOpen");
	}

	public static function options(dlg: FormBuilderDialog): FormBuilderDialogOptions {
		return dlg.formBuilderDialog("option");
	}
}

@:native("$")
extern class FormBuilderDialog extends M3Dialog {
	
	@:overload(function<T>(cmd : String):T{})
	@:overload(function<T>(cmd : String, arg: Dynamic):T{})
	@:overload(function(cmd : String, opt: String, newVal: Dynamic):JQ{})
	function formBuilderDialog(opts: FormBuilderDialogOptions): FormBuilderDialog;

	@:overload(function( selector: JQ ) : FormBuilderDialog{})
	@:overload(function( selector: Element ) : FormBuilderDialog{})
	override function appendTo( selector: String ): FormBuilderDialog;

	static var cur(get, null): FormBuilderDialog;
	private static inline function get_cur() : FormBuilderDialog {
		return untyped __js__("$(this)");
	}

	public static var DEFAULT_FORM_PLUGIN: FormPlugin;

	private static function __init__(): Void {
		// DEFAULT_FORM_PLUGIN = new IdentityFP();

		var defineWidget: Void->FormBuilderDialogWidgetDef = function(): FormBuilderDialogWidgetDef {
			return {

				options: {
					title: "",
					buttons: [
						{
							text: "Submit",
							click: function() {
								var submitFcn = FormBuilderDialog.cur.options().onSubmit;
								if(submitFcn != null) {
									submitFcn();
								} else {
									JqueryUtil.alert("No onSubmit handler found for this form!");
								}
								FormBuilderDialog.cur.close();
							}

						},
						{
							text: "Cancel",
							click: function() {
								var cancelFcn = FormBuilderDialog.cur.options().onCancel;
								if(cancelFcn != null) cancelFcn();
								FormBuilderDialog.cur.close();
							}

						}
					],
					formItems: null,
					onSubmit: JQ.noop,
					formPlugin: DEFAULT_FORM_PLUGIN
				},

				_create: function(): Void {
		        	var self: FormBuilderDialogWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of FormBuilderDialog must be a div element");
		        	}

		        	self._super();

		        	selfElement.addClass("_formBuilderDialog");
		        	
		        	self.formBuilder = new FormBuilder("<div></div>")
		        		.appendTo(selfElement)
		        		.formBuilder({
		        				formItems: self.options.formItems,
		        				formPlugin: self.options.formPlugin
		        			});
		        },

		        // update: function(dr: DeviceReport): Void {
		        // 	if(dr == null) return;
		        // 	var self: FormBuilderDialogWidgetDef = Widgets.getSelf();

		        // 	self._super(dr);

		        // 	switch(dr.msgType) {
		        // 		case MsgType.healthReport: 
		        // 			AppContext.LAST_HEALTH_REPORTS.set(Device.identifier(self.options.device), dr);
	        	// 		case MsgType.dataReport:
		        // 			AppContext.LAST_DATA_REPORTS.set(Device.identifier(self.options.device), dr);
		        // 	}

	        	// },

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.formBuilderDialog", (untyped $.ui.m3dialog), defineWidget());
	}
}