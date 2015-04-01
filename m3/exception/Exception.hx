package m3.exception;


import haxe.CallStack;
import haxe.PosInfos;
import js.Error;
using Lambda;

class Exception extends Error {

	public var cause: Exception;
	// public var message: String;
	public var posInfo: PosInfos;
	public var errorRef: Error;

	public function new(?message: String, ?cause: Exception, ?posInfo: PosInfos) {
		untyped errorRef = super(message);
		// this.message = message;
		this.cause = cause;
		this.posInfo = posInfo;
	}

	public function rootCause(): Exception {
		var ch = chain();
        return ch[ch.length-1];
	}	

	/**
	 chain of exceptions with this one first
	*/
	public function chain(): Array<Exception> {
		var chain = [];
		function gather(e: Exception) {
			if ( e != null ) {
				chain.push(e);
				gather(e.cause);
			}
		}
		gather(this);
		return chain;
	}

	public function stackTrace(): String {
		var l = new Array<String>();
        var index:Int = 0;
		for ( e in chain() ) {
			var s: String;
			if(index++ > 0) s = "CAUSED BY: ";
			else s = "  ";
			// else 
			// l.push("ERROR: " + e.message);
			// for ( s in e.callStack ) {
				l.push(s + e.errorRef.stack);
			// }
		}
		return l.join("\n");
	}

	public function messageList(): Array<String> {
		return chain().map(function(e) { return e.message; });
	}

}


class AjaxException extends Exception {
	public var statusCode: Int;

	public function new(?message: String, ?cause: Exception, ?statusCode: Int, ?posInfo: PosInfos) {
		this.statusCode = statusCode;
		super(message, cause, posInfo);
	}
}