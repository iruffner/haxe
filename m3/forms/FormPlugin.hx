package m3.forms;

import m3.forms.FormBuilder;

interface FormPlugin {
	function preprocessForm(form: FormBuilder, opts: FormBuilderOptions): FormBuilderOptions;
	function postprocessForm(form: FormBuilder, opts: FormBuilderOptions): Void;
}

@:expose
class IdentityFP implements FormPlugin {
	public function new() {	}

	public function preprocessForm(form: FormBuilder, opts: FormBuilderOptions): FormBuilderOptions {
		return opts;
	}

	public function postprocessForm(form: FormBuilder, opts: FormBuilderOptions): Void {
	}
}