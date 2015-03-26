package m3.test;

import m3.CrossMojo;
import m3.jq.JQ;
import m3.util.JqueryUtil;
import m3.test.Assert;
// import m3.jq.JQDialog;

using m3.jq.M3Dialog;
using m3.helper.StringHelper;

/*untested functions:
labelSelectTest
deleteeffects
getDocumentHeight
getDocumentWidthTest
getWindowHeightTest
getWindowWidthTest
*/

@:rtti class JqueryUtilTest {

	@test
	function isAttachedTest(){
		var elem = new JQ('<p id="jqtest1">test</p>');
		var body = new JQ('body').append(elem);
		Assert.areEqual(JqueryUtil.isAttached(elem), true);
		elem.remove();
	}

	//@test
	function labelSelectTest() {
	}

	@test
	function getOrCreateDialogTest() {
		var dlgOptions: M3DialogOptions = {
			autoOpen: true,
			height: 630,
			width: 1120,
			modal: true,
			title: "JQTest",
			showHelp: true,
			buildHelp: function(): Void { },
		};
		var dialog: M3Dialog = JqueryUtil.getOrCreateDialog("#jqtest3", dlgOptions);		
		var elem = new JQ("#jqtest3");
		Assert.areEqual(JqueryUtil.isAttached(elem), true);
		Assert.areEqual((elem.parents('.ui-dialog').height()-630 < 1 && elem.parents('.ui-dialog').height()-630 > -1), true);
		Assert.areEqual(elem.parent().children(new JQ(".ui-dialog-titlebar")).children('.ui-dialog-title').text(), 'JQTest');
		Assert.areEqual(elem.parent().find(new JQ(".ui-resizable-handle")).length, 8);
		dialog.remove();
	}

	//@test
	function deleteEffects() {
	}

	@test
	function confirmTest(){
		JqueryUtil.confirm("Confirm Title", "Confirm?", null);	
		var dialog = new JQ('#confirm-dialog').parent();
		Assert.areEqual(JqueryUtil.isAttached(dialog), true);
		Assert.areEqual((dialog.height()-220 < 1 && dialog.height()-220 > -1), true);
		Assert.areEqual(dialog.children(new JQ(".ui-dialog-titlebar")).children('.ui-dialog-title').text(), 'Confirm Title');
		Assert.areEqual(dialog.find(new JQ(".ui-resizable-handle")).length, 8);	
		new JQ('.ui-widget-overlay').remove();
		dialog.remove();
		new JQ('#confirm-dialog').remove();
	}

	@test
	function alertTest() {
		JqueryUtil.alert("Alert Test", "Alert Title", null);	
		var dialog = new JQ('#alert-dialog').parent();
		Assert.areEqual(JqueryUtil.isAttached(dialog), true);
		Assert.areEqual((dialog.height()-175 < 1 && dialog.height()-175 > -1), true);
		Assert.areEqual(dialog.children(new JQ(".ui-dialog-titlebar")).children('.ui-dialog-title').text(), 'Alert Title');
		Assert.areEqual(dialog.find(new JQ(".ui-resizable-handle")).length, 8);
		dialog.remove();
		new JQ('#alert-dialog').remove();
	}

	@test
	function errorTest() {
		var errors : Dynamic = [
			{
				message : "error1",
				stackTrace : "Stack1,2,3"
			},{
				message : "error2",
				stackTrace : "Stack1,2,3"
			},{
				message : "error3",
				stackTrace : "Stack1,2,3"
			}
		];
		JqueryUtil.error(errors, "Error Title", null);	
		var dialog = new JQ('#error-dialog').parent();
		Assert.areEqual(JqueryUtil.isAttached(dialog), true);
		//Assert.areEqual((dialog.height()-207 < 1 && dialog.height()-207 > -1), true);
		Assert.areEqual(dialog.children(new JQ(".ui-dialog-titlebar")).children('.ui-dialog-title').text(), 'Error Title');
		Assert.areEqual(dialog.find(new JQ(".ui-resizable-handle")).length, 8);
		Assert.areEqual(dialog.find(new JQ(".errorMessage")).length, 3);
		dialog.remove();
		new JQ('#error-dialog').remove();
	}

	//@test
	function getWindowWidthTest(){
	}

	//@test
	function getWindowHeightTest(){
	}

	//@test
	function getDocumentWidthTest() {
	}

	//@test
	function getDocumentHeight() {
	}

	@test
	function getEmptyDivTest(){
		var div : JQ = JqueryUtil.getEmptyDiv();
		Assert.areEqual(div.text(), "");
		Assert.areEqual(div.attr('class'), null);
	}

	@test
	function getEmptyTableTest(){
		var div : JQ = JqueryUtil.getEmptyTable();
		Assert.areEqual(div.text(), "");
		Assert.areEqual(div.attr('class'), null);
	}

	@test
	public static function getEmptyRowTest() {
		var div : JQ = JqueryUtil.getEmptyRow();
		Assert.areEqual(div.text(), "");
		Assert.areEqual(div.attr('class'), null);		
	}
	
	@test
	function getEmptyCellTest(){
		var div : JQ = JqueryUtil.getEmptyCell();
		Assert.areEqual(div.text(), "");
		Assert.areEqual(div.attr('class'), null);		
	}


}

