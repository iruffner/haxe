package m3.forms;

import m3.forms.FormBuilder;

interface FormPlugin {
	function preprocessForm(opts: FormBuilderOptions): FormBuilderOptions;
}

class IdentityFP implements FormPlugin {
	public function new() {	}

	public function preprocessForm(opts: FormBuilderOptions): FormBuilderOptions {
		return opts;
	}
}