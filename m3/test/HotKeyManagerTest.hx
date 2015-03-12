package m3.test;

import m3.jq.JQ;
import m3.util.Tuple;
import m3.util.HotKeyManager;
using m3.helper.ArrayHelper;
using m3.test.Assert;

typedef HotKey = {
	var keyCode: Int;
	@:optional var altKey: Bool;
	@:optional var ctrlKey: Bool;
	@:optional var shiftKey: Bool;
}

@:rtti class HotKeyManagerTest {
	@test
	function newTest() {
		Assert.areEqual(true,true);
	}

	@test
	function get_getTest(){
		Assert.areEqual(true,true);
	}

	@test
	function addHotKeyFcnTest() {
		Assert.areEqual(true,true);
	}

	@test
	function addHotKey() {
		Assert.areEqual(true,true);
	}

}