package m3.comm;

import haxe.Json;
import m3.exception.Exception;

class JsonRequest extends BaseRequest {
	public function new(requestJson: Dynamic, url:String, ?successFcn: Dynamic->Void, 
		                ?errorFcn: AjaxException->Void, ?accessDeniedFcn: Void->Void) {
		super(Json.stringify(requestJson), url, successFcn, errorFcn, accessDeniedFcn);
	}

}