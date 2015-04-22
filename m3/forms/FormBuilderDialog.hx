package m3.forms;

import js.html.Element;

import m3.exception.Exception;
import m3.forms.FormBuilder.FormError;
import m3.forms.FormPlugin.IdentityFP;
import m3.jq.JQ;
import m3.jq.M3Dialog;
import m3.util.JqueryUtil;
import m3.widget.Widgets;

using m3.helper.StringFormatHelper;
using m3.forms.FormBuilder;
using m3.forms.FormBuilderDialog.FormBuilderDialogHelper;
using m3.helper.ArrayHelper;

typedef FormBuilderDialogOptions = {
	>M3DialogOptions,
	var formOptions: FormBuilderOptions;
	// @:optional var ignoreTitle: Bool;
	// var formItems: Array<FormItem>;
	// @:optional var onSubmit: Array<Array<String>>->Void;
	// @:optional var onError: Void->Void;
	// @:optional var onCancel: Void->Void;
	// var formPlugin: FormPlugin;
	// var formLayoutPlugin: FormLayoutPlugin;
	// @:optional var subtitle: String;
	// var validate: Void->Dynamic;
}

typedef FormBuilderDialogWidgetDef = {
	var options: FormBuilderDialogOptions;

	@:optional var formBuilder: FormBuilder;
	var getFormBuilder: Void->FormBuilder;
	var _create: Void->Void;
	var destroy: Void->Void;
	//var close: Void->Void;

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

	public static function getFormBuilder(dlg: FormBuilderDialog): FormBuilder {
		return dlg.formBuilderDialog("getFormBuilder");
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
	public static var DEFAULT_FORM_LAYOUT: FormLayoutPlugin;

	private static function __init__(): Void {
		// DEFAULT_FORM_PLUGIN = new IdentityFP();

		var defineWidget: Void->FormBuilderDialogWidgetDef = function(): FormBuilderDialogWidgetDef {
			return {

				options: {
					formOptions: {
						formItems: null,
						onSubmit: function(arg){},
						formPlugin: DEFAULT_FORM_PLUGIN,
						formLayoutPlugin: DEFAULT_FORM_LAYOUT,
						validate: function() {return null;}
					},
					title: "",
					buttons: [
						{
							text: "Submit",
							click: function() {
								var formBuilder: FormBuilder = new FormBuilder(FormBuilderDialog.cur.children("._formBuilder"));
								
								var formErrors: Array<FormError> = null;
								formErrors = formBuilder.validate();

								if(formErrors.hasValues()) {
									//pass errors to the layout plugin
									return;
								}

								// var validateFcn = formBuilder.formBuilder("option", "validate");
								// if(validateFcn != null) {

								// }



								var submitFcn = formBuilder.formBuilder("option", "onSubmit");
								if(submitFcn != null) {
									submitFcn(formBuilder.results());
								} else {
									JqueryUtil.alert("No onSubmit handler found for this form!");
								}
								FormBuilderDialog.cur.close();
							}

						},
						{
							text: "Cancel",
							click: function() {
								var cancelFcn = FormBuilderDialog.cur.options().formOptions.onCancel;
								if(cancelFcn != null) cancelFcn();
								FormBuilderDialog.cur.close();
							}

						}
					],
					
					width: 800
				},

				_create: function(): Void {
		        	var self: FormBuilderDialogWidgetDef = Widgets.getSelf();
					var selfElement: JQ = Widgets.getSelfElement();

		        	if(!selfElement.is("div")) {
		        		throw new Exception("Root of FormBuilderDialog must be a div element");
		        	}

		        	selfElement.addClass("_formBuilderDialog");
		        	
		        	var castedOptions: Dynamic = cast self.options; 

                    var id = selfElement.attr("id");
                    if( id == "" || id == null){
	                    if(Reflect.hasField(castedOptions.formOptions, 'view')){
	                        id = castedOptions.formOptions.view.page.uid+'_'+castedOptions.formOptions.view.requestObj.id+'_'+StringTools.urlEncode(castedOptions.title);
	                    }else{
	                        id = castedOptions.view.page.uid+'_'+castedOptions.view.requestObj.id+'_'+StringTools.urlEncode(castedOptions.title);
	                    }
	                }

		        	selfElement.attr("id",id);

		        	self._super();
		        	
		        	self.formBuilder = new FormBuilder("<div></div>")
		        		.appendTo(selfElement)
		        		.formBuilder(self.options.formOptions);

		        },

		        getFormBuilder: function(){
		        	var self: FormBuilderDialogWidgetDef = Widgets.getSelf();
		        	return self.formBuilder;
	        	},

		        destroy: function() {
		            untyped JQ.Widget.prototype.destroy.call( JQ.curNoWrap );
		        }
		    };
		}
		JQ.widget( "ui.formBuilderDialog", (untyped $.ui.m3dialog), defineWidget());
	}
}