package m3.test;

import m3.helper.StringHelper;
import m3.test.Assert;

@:rtti class StringHelperTest {
	@test
	function compareTest() {	
		var expected = -1;
		var actual = StringHelper.compare("abcd", "abdd");
		Assert.areEqual(expected, actual);

		var expected = 0;
		var actual = StringHelper.compare("abcd", "abcd");
		Assert.areEqual(expected, actual);

		var expected = 1;
		var actual = StringHelper.compare("abdd", "abcd");
		Assert.areEqual(expected, actual);
	}

	@test
	function extractLast() {
		var expected = "test3";
		var actual = StringHelper.extractLast("test1,test2,test3", ",");
		Assert.areEqual(expected, actual);

		var expected = ".test1";
		var actual = StringHelper.extractLast("test1,.test2,.test1", ",");
		Assert.areEqual(expected, actual);
	}

	@test
	function replaceAllTest(){	
		var expected = "test<t<t<t<ttest";
		var actual = StringHelper.replaceAll("test....test", ".", "<t");
		Assert.areEqual(expected, actual);

		var expected = "ok....ok";
		var actual = StringHelper.replaceAll("test....test", "test", "ok");
		Assert.areEqual(expected, actual);

		var expected = ",.test";
		var actual = StringHelper.replaceAll("<=asd", "<=asd", ",.test");
		Assert.areEqual(expected, actual);
	}

	@test
	function replaceLastTest(){
		var expected = "1,2,3,4";
		var actual = StringHelper.replaceLast("1,2,3,2", "4", ",");
		Assert.areEqual(expected, actual);

		var expected1 = "cc,cc,cc,bb";
		var actual1 = StringHelper.replaceLast("cc,cc,cc,cc", "bb", ",");
		Assert.areEqual(expected1, actual1);
	}	

	@test
	function capitalizeFirstLetterTest() {	
		var expected = "<<<<Test";
		var actual = StringHelper.capitalizeFirstLetter("<<<<test");
		Assert.areEqual(expected, actual);

		var expected1 = "TEST";
		var actual1 = StringHelper.capitalizeFirstLetter("tEST");
		Assert.areEqual(expected1, actual1);		
	}

	@test
	function camelCaseTest() {
		var expected1 = "tEST";
		var actual1 = StringHelper.camelCase("TEST");
		Assert.areEqual(expected1, actual1);				
	}

	@test
	function isBlankTest(){
		var expected1 = false;
		var actual1 = StringHelper.isBlank("tEST");
		Assert.areEqual(expected1, actual1);				

		var expected1 = true;
		var actual1 = StringHelper.isBlank(null);
		Assert.areEqual(expected1, actual1);				

		var expected1 = true;
		var actual1 = StringHelper.isBlank("");
		Assert.areEqual(expected1, actual1);				
	}	

	@test
	function isNotBlankTest(){
		var expected1 = true;
		var actual1 = StringHelper.isNotBlank("tEST");
		Assert.areEqual(expected1, actual1);				

		var expected1 = false;
		var actual1 = StringHelper.isNotBlank(null);
		Assert.areEqual(expected1, actual1);				

		var expected1 = false;
		var actual1 = StringHelper.isNotBlank("");
		Assert.areEqual(expected1, actual1);				
	}

	@test
	function indentLeftTest() {
		var expected = "<<<<test";
		var actual = StringHelper.indentLeft("test", 4, "<");
		Assert.areEqual(expected, actual);

		var expected1 = "----test";
		var actual1 = StringHelper.indentLeft("test", 4, "-");
		Assert.areEqual(expected1, actual1);

		var expected2 = "----";
		var actual2 = StringHelper.indentLeft(null, 4, "-");
		Assert.areEqual(expected2, actual2);
	}	

	@test
	function padLeftTests() {
		var expected = "<<<<test";
		var actual = StringHelper.padLeft("test", 8, "<");
		Assert.areEqual(expected, actual);

		var expected1 = "----test";
		var actual1 = StringHelper.padLeft("test", 8, "-");
		Assert.areEqual(expected1, actual1);

		var expected2 = "----";
		var actual2 = StringHelper.padLeft(null, 4, "-");
		Assert.areEqual(expected2, actual2);
	}

	@test
	function padRightTests() {
		var expected = "test----";
		var actual = StringHelper.padRight("test", 8, "-");
		Assert.areEqual(expected, actual);

		var expected1 = "test";
		var actual1 = StringHelper.padRight("test", 4, "<");
		Assert.areEqual(expected1, actual1);

		var expected2 = "<<<<";
		var actual2 = StringHelper.padRight(null, 4, "<");
		Assert.areEqual(expected2, actual2);
	}

	@test
	function trimLeftTests() {
		var expected = "";
		var actual = StringHelper.trimLeft(null);
		Assert.areEqual(expected, actual);

		var expected1 = "good to go!";
		var actual1 = StringHelper.trimLeft("\n\tgood to go!");
		Assert.areEqual(expected1, actual1);

		var expected1 = "good to go!\n\t";
		var actual1 = StringHelper.trimLeft("\n\t\n\tgood to go!\n\t");
		Assert.areEqual(expected1, actual1);

		var expected2 = "good to do!";
		var actual2 = StringHelper.trimLeft("good to do!", 20);
		Assert.areEqual(expected2, actual2);

		var expected3 = "d to go!";
		var actual3 = StringHelper.trimLeft("good to go!", 2, "go");
		Assert.areEqual(expected3, actual3);
		
		var expected4 = "good to go!";
		var actual4 = StringHelper.trimLeft("good to go!", "o");
		Assert.areEqual(expected4, actual4);

		var expected5 = "dy is good!";
		var actual5 = StringHelper.trimLeft("body is good!", "bo");
		Assert.areEqual(expected5, actual5);
	}

	@test
	function trimRightTests() {
		var expected = "";
		var actual = StringHelper.trimRight(null);
		Assert.areEqual(expected, actual);

		var expected1 = "good to go!";
		var actual1 = StringHelper.trimRight("good to go!\n\t");
		Assert.areEqual(expected1, actual1);

		var expected1 = "\n\t\n\tgood to go!";
		var actual1 = StringHelper.trimRight("\n\t\n\tgood to go!\n\t");
		Assert.areEqual(expected1, actual1);

		var expected2 = "good to do!";
		var actual2 = StringHelper.trimRight("good to do!", 20);
		Assert.areEqual(expected2, actual2);

		var expected3 = "good to ";
		var actual3 = StringHelper.trimRight("good to go!", 2, "go!");
		Assert.areEqual(expected3, actual3);
		
		var expected4 = "good to go!";
		var actual4 = StringHelper.trimRight("good to go!", "o");
		Assert.areEqual(expected4, actual4);

		var expected5 = "body is";
		var actual5 = StringHelper.trimRight("body is good!", " good!");
		Assert.areEqual(expected5, actual5);
	}

	@test
	function containsTest(){
		var expected1 = true;
		var actual1 = StringHelper.contains("TEST", "T");
		Assert.areEqual(expected1, actual1);

		var expected2 = true;
		var actual2 = StringHelper.contains("TEST", "E");
		Assert.areEqual(expected2, actual2);	

		var expected3 = false;
		var actual3 = StringHelper.contains("TEST", ".");
		Assert.areEqual(expected3, actual3);		
	}

	@test
	function containsAnyTest(){
		var expected1 = true;
		var actual1 = StringHelper.containsAny("TEST", ["T", "1"]);
		Assert.areEqual(expected1, actual1);

		var expected2 = true;
		var actual2 = StringHelper.containsAny("TEST", ["S", "2"]);
		Assert.areEqual(expected2, actual2);	

		var expected3 = false;
		var actual3 = StringHelper.containsAny("TEST", [".", "2"]);
		Assert.areEqual(expected3, actual3);		
	}	

	@test
	function startsWithAnyTest(){
		var expected1 = true;
		var actual1 = StringHelper.startsWithAny("TEST", ["T", "1"]);
		Assert.areEqual(expected1, actual1);

		var expected2 = true;
		var actual2 = StringHelper.startsWithAny("TEST", ["2", "T"]);
		Assert.areEqual(expected2, actual2);	

		var expected3 = false;
		var actual3 = StringHelper.startsWithAny("TEST", [".", "2"]);
		Assert.areEqual(expected3, actual3);		
	}

	@test
	function endsWithAnyTest(){
		var expected1 = true;
		var actual1 = StringHelper.endsWithAny("TEST", ["T", "1"]);
		Assert.areEqual(expected1, actual1);

		var expected2 = true;
		var actual2 = StringHelper.endsWithAny("TEST", ["2", "T"]);
		Assert.areEqual(expected2, actual2);	

		var expected3 = false;
		var actual3 = StringHelper.endsWithAny("TEST", [".", "2"]);
		Assert.areEqual(expected3, actual3);		
	}

	@test
	function toDateTest(){
		var expected1 = "Wed Jan 01 2014 00:00:00 GMT+0200 (EET)";
		var actual1 = StringHelper.toDate("2014-01-01");
		Assert.areEqual(expected1, actual1);

		var expected2 = null;
		var actual2 = StringHelper.toDate("2014-01-01-12-00");
		Assert.areEqual(expected2, actual2);	
	}

	@test
	function boolAsYesNoTest(){
		var expected1 = "Yes";
		var actual1 = StringHelper.boolAsYesNo(true);
		Assert.areEqual(expected1, actual1);

		var expected2 = "No";
		var actual2 = StringHelper.boolAsYesNo(false);
		Assert.areEqual(expected2, actual2);

		var expected2 = "No";
		var actual2 = StringHelper.boolAsYesNo(null);
		Assert.areEqual(expected2, actual2);
	}

	@test
	function toBoolTest(){
		var expected1 = true;
		var actual1 = StringHelper.toBool("true");
		Assert.areEqual(expected1, actual1);

		var expected2 = false;
		var actual2 = StringHelper.toBool("false");
		Assert.areEqual(expected2, actual2);

		var expected2 = false;
		var actual2 = StringHelper.toBool("1");
		Assert.areEqual(expected2, actual2);

		var expected2 = false;
		var actual2 = StringHelper.toBool(null);
		Assert.areEqual(expected2, actual2);
	}

}