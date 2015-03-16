package m3.test;

import m3.CrossMojo;
import m3.jq.JQ;
import m3.util.JqueryUtil;
import m3.test.Assert;
// import m3.jq.JQDialog;

using m3.jq.M3Dialog;
using m3.helper.StringHelper;


@:rtti class JqueryUtilTest {

	@test
	function isAttachedTest(){
		var elem = new JQ('<p id="jqtest">test</p>');
		var body = new JQ('body').append(elem);
		Assert.areEqual(JqueryUtil.isAttached(elem), true);
	}

	@test
	function labelSelectTest() {
		var elem = new JQ('<p id="jqtest">test</p>');
		var body = new JQ('body').append(elem);
		Assert.areEqual(JqueryUtil.isAttached(elem), true);
	}

	@test
	function getOrCreateDialogTest() {
	}

	@test
	function deleteEffects() {
	}

	@test
	function confirmTest(){
	}

	@test
	function alertTest() {
	}

	@test
	function errorTest() {
	}

	@test
	function getWindowWidthTest(){
	}

	@test
	function getWindowHeightTest(){
	}

	@test
	function getDocumentWidthTest() {
	}

	@test
	function getDocumentHeight() {
	}

	@test
	function getEmptyDiv(){
	}

	@test
	function getEmptyTable(){
	}

	@test
	public static function getEmptyRow() {
	}
	
	@test
	function getEmptyCell(){
	}


}
