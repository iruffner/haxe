package m3.comm;

import haxe.ds.StringMap;
import m3.exception.Exception;
import m3.jq.JQ;
import m3.util.JqueryUtil;
import m3.log.Logga;

using m3.helper.StringHelper;

class BaseRequest {
	private var requestData:String;
	private var onSuccess: Dynamic->Void;
	private var onError: AjaxException->Void;
	private var onAccessDenied: Void->Void;
	private var baseOpts:AjaxOptions;
	private var _requestHeaders:StringMap<String>;
	private var _url:String;

	public function new(requestData: String, url:String, ?successFcn: Dynamic->Void, ?errorFcn: AjaxException->Void,
		                                     ?accessDeniedFcn: Void->Void) {
		this.requestData = requestData;
		this._url = url;
		this.onSuccess   = successFcn;
		this.onError     = errorFcn;
		this.onAccessDenied = accessDeniedFcn;
		this._requestHeaders = new StringMap<String>();
	}

	public function ajaxOpts(?opts:AjaxOptions):Dynamic {
		if (opts == null) {
			return this.baseOpts;
		} else {
			this.baseOpts = opts;
			return this;
		}
	}

	public function requestHeaders(?headers:StringMap<String>):Dynamic {
		if (headers == null) {
			return this._requestHeaders;
		} else {
			this._requestHeaders = headers;
			return this;
		}
	}

    public function beforeSend(jqXHR: JQXHR, settings: AjaxOptions): Void {
    	for (key in _requestHeaders.keys()) {
    		if (_requestHeaders.get(key) != null) {
	            jqXHR.setRequestHeader(key, _requestHeaders.get(key));
	        }
        }
    }

	public function start(?opts:AjaxOptions): Dynamic {
		if (opts == null){opts = {};}

		var ajaxOpts: AjaxOptions = {
			async: true,
			beforeSend: beforeSend,
	        contentType: "application/json",
	        dataType: "json", 
	        data: requestData,
	        type: "POST",
	        url: _url,
			success: function(data: Dynamic, textStatus: Dynamic, jqXHR: JQXHR) {
   				if (jqXHR.getResponseHeader("Content-Length") == "0") {
   					data = [];
   				}
				if (onSuccess != null) {
					onSuccess(data);
				}
			},
   			error: function(jqXHR:JQXHR, textStatus:String, errorThrown:Dynamic) {
                if (jqXHR.status == 403 && this.onAccessDenied != null) {
   					return this.onAccessDenied();
   				}

   				var errorMessage:String = null;
                if (jqXHR.message.isNotBlank()) {
                    errorMessage = jqXHR.message;
                } else if (jqXHR.responseText.isNotBlank() && jqXHR.responseText.charAt(0) != "<") {
                    errorMessage = jqXHR.responseText;
                } else if (errorThrown == null || Std.is(errorThrown, String)){
                    errorMessage = errorThrown;
                } else {
                	errorMessage = errorThrown.message;
                }	

                if (errorMessage.isBlank()) {
                	errorMessage = "Error, but no error msg from server";
                }

                Logga.DEFAULT.error("Request Error handler: Status " +jqXHR.status + " | " + errorMessage);
                
                var exc = new AjaxException(errorMessage, null, jqXHR.status);
   				if (onError != null) {
   					onError(exc);
   				} else {
	   				throw exc;
	   			}
			}
        };

        JQ.extend(ajaxOpts, baseOpts);
        JQ.extend(ajaxOpts, opts);

		return JQ.ajax(ajaxOpts);
	}

	public function abort(): Void {
	}
}

