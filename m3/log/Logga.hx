package m3.log;

import m3.CrossMojo;
import m3.exception.Exception;
import m3.util.M;

using Lambda;
using m3.helper.StringHelper;

class Logga {
    
    var loggerLevel: LogLevel;
    var console: js.html.Console;
       var statementPrefix: String;
    @:isVar public static var DEFAULT(get,null): Logga;
    private var initialized: Bool = false;

    private var preservedConsoleError: Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Void;
    private var preservedConsoleLog: Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Void;
    private var preservedConsoleTrace: Dynamic->Dynamic->Dynamic->Dynamic->Dynamic->Void;

    public function new(logLevel: LogLevel) {
        this.loggerLevel = logLevel;
    }

    public function doOverrides() {
        overrideConsoleError();
        overrideConsoleTrace();
        overrideConsoleLog();
        untyped window.onerror = function(message: String, url: String, lineNumber: Int): Void {
            LOGGER.error("WindowError | " + url + " (" + lineNumber + ") | " + message);
            return false;
        }
    }

    private function _getLogger(): Void {
        console = js.Browser.window.console;
        
        initialized = true;
    }

    public function overrideConsoleError() {
        if(!initialized) _getLogger();
        if(this.console != null) {
            try {
                preservedConsoleError = this.console.error;
                untyped this.console.error = function() {
                    untyped this.error(__js__("arguments")[0]);
                }
            } catch (err: Dynamic) {
                warn("Could not override console.error");
            }
        }
    }

    public function overrideConsoleTrace() {
        if(!initialized) _getLogger();
        if(this.console != null) {
            try {
                preservedConsoleTrace = this.console.trace;
                untyped this.console.trace = function() {
                    preservedConsoleTrace.apply(console);
                }
            } catch (err: Dynamic) {
                warn("Could not override console.trace");
            }
        }
    }

    public function overrideConsoleLog() {
        if(!initialized) _getLogger();
        if(this.console != null) {
            try {
                this.console.log("prime console.log");
                preservedConsoleLog = this.console.log;
                untyped this.console.log = function() {
                    untyped this.warn(__js__("arguments")[0]);
                }
            } catch (err: Dynamic) {
                warn("Could not override console.log");
            }
        }
    }

    private static function get_DEFAULT(): Logga {
        if(DEFAULT == null) {
            DEFAULT = new RemoteLogga(LogLevel.DEBUG, LogLevel.DEBUG);
        }
        return DEFAULT;
    }

    public function setStatementPrefix(prefix: String): Void {
        this.statementPrefix = prefix;
    }

    public function log(statement: String, ?level: LogLevel, ?exception: Exception, ?posInfo: haxe.PosInfos) {
        if(!initialized) {
            this._getLogger();
        }
        if(level == null) {
            level = LogLevel.INFO;
        }

        try {
            if(exception != null && exception.stackTrace != null && Reflect.isFunction(exception.stackTrace) ) {
                statement += "\n" + exception.stackTrace();
            }
        } catch (err: Dynamic) {
            log("Could not get stackTrace", LogLevel.ERROR);
        }

        if(statement.isBlank()) {
            this.console.error("empty log statement");  
            this.console.trace();
        // } else if (statement.contains("Endpoint saved")) {
        //     this.console.trace();
        }

        if(statementPrefix.isNotBlank()) {
            statement = statementPrefix + " || " + statement;
        }

        // var console = CrossMojo.windowConsole();
        if( logsAtLevel(level) && console != null ) {
            try {
                if( (Type.enumEq(level, LogLevel.TRACE) || Type.enumEq(level, LogLevel.DEBUG)) && console.debug != null) {
                    this.console.debug(statement, "-->", posInfo);
                } else if (Type.enumEq(level, LogLevel.INFO) && console.info != null) {
                    this.console.info(statement, "-->", posInfo);
                } else if (Type.enumEq(level, LogLevel.WARN) && console.warn != null) {
                    this.console.warn(statement, "-->", posInfo);
                } else if (Type.enumEq(level, LogLevel.ERROR) && this.preservedConsoleError != null) {
                    untyped this.preservedConsoleError.apply(this.console, [statement]);
                    this.console.trace();
                } else if (Type.enumEq(level, LogLevel.ERROR) && console.error != null) {
                    this.console.error(statement, posInfo);
                    this.console.trace();
                } else if (this.preservedConsoleLog != null) {
                    untyped this.preservedConsoleLog.apply(this.console, [statement]);
                } else {
                    this.console.log(statement, "-->", posInfo);
                }
            } catch (err : Dynamic) {
                if(this.console != null && Reflect.hasField(this.console, "error")) {
                    this.console.error(err);
                }
            }
        }
    }
    public function logsAtLevel(level:LogLevel) {
        return Type.enumIndex(this.loggerLevel) <= Type.enumIndex(level);
    }
    public function setLogLevel(logLevel:LogLevel) {
        this.loggerLevel = logLevel;
    }
    public function trace(statement:String, ?exception:Exception, ?posInfo: haxe.PosInfos) {
        log(statement, LogLevel.TRACE, exception, posInfo);
    }
    public function debug(statement:String, ?exception:Exception, ?posInfo: haxe.PosInfos) {
        log(statement, LogLevel.DEBUG, exception, posInfo);
    }
    public function info(statement:String, ?exception:Exception, ?posInfo: haxe.PosInfos) {
        log(statement, LogLevel.INFO, exception, posInfo);
    }
    public function warn(statement:String, ?exception:Exception, ?posInfo: haxe.PosInfos) {
        log(statement, LogLevel.WARN, exception, posInfo);
    }
    public function error(statement:String, ?exception:Exception, ?posInfo: haxe.PosInfos) {
        log(statement, LogLevel.ERROR, exception, posInfo);
    }

    public static function getExceptionInst(err: Dynamic) {
        if(Std.is(err, Exception)) {
            return err;
        } else {
            return new Exception(err);
        }
    }
}



