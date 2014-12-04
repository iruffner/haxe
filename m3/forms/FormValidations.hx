package m3.forms;

using m3.helper.StringHelper;

@:expose
class FormValidations {
	public static function notNull(val: String): String {
		return val == null ? "A valid value must be specified" : null;
	}

	public static function notBlank(val: String) {
		return val.isBlank() ? "A valid value must be specified" : null;
	}
}