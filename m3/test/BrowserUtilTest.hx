package m3.test;

using m3.helper.ArrayHelper;
using m3.helper.StringHelper;
using m3.util.BrowserUtil;
using Lambda;

/*untested functions:
versionTest
*/

@:rtti class BrowserUtilTest {
	@test
	function msieTest() {
		var expected1 = true;
		var actual1 = BrowserUtil.msie;
		Assert.areEqual(expected1, actual1);		
	}

/*	@test
	function versionTest(): String {
		var expected1 = null;
		var actual1 = BrowserUtil.msie;
		Assert.areEqual(expected1, actual1);	
		
		if(ereg.match(js.Browser.navigator.userAgent)) {
			return ereg.matched(1);
		} else {
			return null;
		}
	}
*/}
