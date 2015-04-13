package m3.forms;

import m3.exception.Exception;
using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using StringTools;

/**

    This code has only been compiled and NOT tested yet.

*/

interface InputParser<T> {

    /**
     *   null means all characters are allowed
     */
    public function validInputCharacters(): String;

    /**
     *  Convert a given instance to the value shown to the user in the text box
     */
    public function format(t: T): String;

    /**
     *
     *  This function should never throw exceptions for any given input.  
     *  Implementors must go above and beyond the call of duty to trap exceptions
     *  and give human readable error messages.
     */
    public function parse(s: String): ParseResult<T>;

    public function inputWidgetHints(): InputWidgetHints;

}

class AbstractInputParser<T> implements InputParser<T> {

    public function validInputCharacters(): String {
        return null;
    }

    public function format(t: T): String {
        return Std.string(t);
    }
    public function inputWidgetHints(): InputWidgetHints {
        return {};
    }
    public function parse(s: String): ParseResult<T> {
        throw new Exception("implement me");
    }
}

class StringInputParser extends AbstractInputParser<String> {

    override public function parse(s: String): ParseResult<String> {
        return ParseResult.success(s);
    }  

}


class BoolInputParser extends AbstractInputParser<Bool> {

    var truths = ["yes", "true", "1", "t", "y", "on"];
    var untruths = ["no", "false", "0", "f", "n", "off"];

    function truthsStr(): String {
        return truths.join(",");
    }

    function untruthsStr(): String {
        return untruths.join(",");
    }

    override public function parse(s: String): ParseResult<Bool> {
        var v = s.toLowerCase().trim();
        if ( truths.indexOf(v) >= 0 ) return ParseResult.success(true);
        else if ( untruths.indexOf(v) >= 0 ) return ParseResult.success(false);
        else return ParseResult.error("Please enter a valid boolean value for true [${truthsStr()}] or false [${untruthsStr}].");
    }  

}


class IntInputParser extends AbstractInputParser<Int> {

    /**
     *   null means all characters are allowed
     */
    override public function validInputCharacters(): String {
        return "0123456789,";
    }

    override public function parse(s: String): ParseResult<Int> {
        var stripped = s.replace(",","");
        var i = Std.parseInt(stripped);
        if ( i == null ) return ParseResult.error("Please enter a valid integer.");
        else return ParseResult.success(i);
    }  

}


class NullableInputParser<T> extends DefaultValueInputParser<T> {

    public function new(delegate: InputParser<T>) {
        super(delegate, null, false);
    }

    override public function inputWidgetHints(): InputWidgetHints {
        var h = _delegate.inputWidgetHints();
        h.nullable = true;
        return h;
    }

}

class RequiredInputParser<T> extends DelegatedInputParser<T> {

    public function new(delegate: InputParser<T>) {
        super(delegate);
    }

    override public function parse(s: String): ParseResult<T> {
        if ( s.isBlank() ) return ParseResult.error("A valid entry is required");
        else return _delegate.parse(s);
    }

    override public function inputWidgetHints(): InputWidgetHints {
        var h = _delegate.inputWidgetHints();
        h.required = true;
        return h;
    }

}


class DelegatedInputParser<T> implements InputParser<T> {

    var _delegate: InputParser<T>;

    public function new(delegate: InputParser<T>) {
        _delegate = delegate;
    }

    public function format(t: T): String {
        return _delegate.format(t);
    }

    public function parse(s: String): ParseResult<T> {
        return _delegate.parse(s);
    }

    public function inputWidgetHints(): InputWidgetHints {
        return _delegate.inputWidgetHints();
    }

    public function validInputCharacters(): String {
        return _delegate.validInputCharacters();
    }
    
}


class DefaultValueInputParser<T> extends DelegatedInputParser<T> {

    var _defaultValue: T;
    var _populateUiWithDefaultValue: Bool;

    public function new(delegate: InputParser<T>, defaultValue: T, populateUiWithDefaultValue: Bool) {
        super(delegate);
        _defaultValue = defaultValue;
        _populateUiWithDefaultValue = populateUiWithDefaultValue;
    }

    override public function format(t: T): String {
        if ( t == null )
            if (_populateUiWithDefaultValue) return _delegate.format(_defaultValue);
            else return "";
        else return _delegate.format(t);
    }

    override public function parse(s: String): ParseResult<T> {
        if ( s.isBlank() ) 
            if ( _populateUiWithDefaultValue ) return ParseResult.error("A valid value is required.")        
            else return ParseResult.success(_defaultValue);
        else return _delegate.parse(s);
    }

    override public function inputWidgetHints(): InputWidgetHints {
        var h = _delegate.inputWidgetHints();
        h.hasDefaultValue = true;
        h.required = _populateUiWithDefaultValue;
        h.defaultValue = _defaultValue;
        return h;
    }

}

class ParseResult<T> {

    private var _value: T;
    private var _errors: Array<String>;

    public static function error<T>(msg: String): ParseResult<T> {
        var r = new ParseResult();
        r._errors.push(msg);
        return r;
    }

    public static function success<T>(t: T): ParseResult<T> {
        var r = new ParseResult();
        r._value = t;
        return r;
    }

    private function new() {    
        _errors = [];
    }

    public function hasErrors(): Bool {
        return _errors.length != 0;
    }

    public function value(): T {
        return this._value;
    }

}

typedef InputWidgetHints = {
    @:optional var maxLength: Int;
    @:optional var nullable: Bool;
    @:optional var required: Bool;
    @:optional var hasDefaultValue: Bool;
    @:optional var defaultValue: Dynamic;
}


/**

    demo 
        nullability 
        required
        default values



    Types to implement
        date
        time
        timestamp
        float
        json
        javascript
        sql
        period


Notes: the concept of widget hints is half baked.  The idea/intention is that an input parser can 
provide some optional metadata so that the Widget/UI/View can provide some info/indicator to the user.



*/
