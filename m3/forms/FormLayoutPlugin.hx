package m3.forms;

import m3.jq.JQ;
import m3.forms.inputs.AbstractInput;

using m3.helper.StringHelper;
using m3.forms.FormBuilder;
using m3.forms.FormInput;
using m3.helper.ArrayHelper;

interface FormLayoutPlugin {
	function render(form: FormBuilder, opts: FormBuilderOptions): Array<FormInput>;
	function renderFormValidation(form: FormBuilder, opts: FormBuilderOptions, errors: Array<FormError>): Void;
	function renderInputValidation(input: FormInput, errors: Array<FormError>): Void;
}

@:expose
class DefaultFormLayout implements FormLayoutPlugin {
	public function new() {}

	public function render(form: FormBuilder, opts: FormBuilderOptions): Array<FormInput> {
		if(!opts.title.isNotBlank()) {
    		form.append("<h2 class='title'>" + opts.title + "</h2>");
    	}
    	if(opts.subtitle.isNotBlank()) {
    		form.append("<div class='subtitle'>" + opts.subtitle + "</div>");
    	}

    	var f: JQ = new JQ("<div class='formInputs'></div>").appendTo(form);

    	var formInputs = new Array<FormInput>();
    	if(opts.formItems != null){
	    	for(formItem in opts.formItems) {
				formInputs.push(
					new FormInput("<div></div>")
						.appendTo(f)
						.formInput({formItem: formItem})
				);
	    	}
	    }
    	return formInputs;
	}
	
	public function renderFormValidation(form: FormBuilder, opts: FormBuilderOptions, errors: Array<FormError>): Void {
		var formInputs: Array<FormInput> = form.formInputs();
		for(fi_ in formInputs) {
			fi_.children(".iconDiv").removeClass("error");
		}
		if(errors.hasValues()) {
			for(err_ in errors) {
				err_.input.children(".iconDiv, label, input").addClass("error");
				err_.input.children("select").addClass("error");
				// err_.input.children("label").addClass("error");
				// err_.input.children("input").addClass("error");
			}
		}
	}

	public function renderInputValidation(formInput: FormInput, errors: Array<FormError>): Void {
		formInput.children().removeClass("error");
		if(errors.hasValues()) {
			for(err_ in errors) {
				err_.input.children(".iconDiv, label, input").addClass("error");
				err_.input.children("select").addClass("error");
				// err_.input.children("label").addClass("error");
				// err_.input.children("input").addClass("error");
			}
		}
	}
}