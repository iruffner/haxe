package m3.test;

import m3.test.Assert;
import m3.util.HtmlUtil;
using Lambda;

@:rtti class HtmlUtilTest {
	
	@test
	function readCookieTest(){
		HtmlUtil.setCookie('test','test123');
		Assert.areEqual(HtmlUtil.readCookie('test'), 'test123');
	}

	@test
	function setCookieTest(){
		HtmlUtil.setCookie('test123','test');
		Assert.areEqual(HtmlUtil.readCookie('test123'), 'test');
	}

	@test
	function deleteCookieTest(){
		HtmlUtil.setCookie('test123','test');
		HtmlUtil.setCookie('test','test123');
		HtmlUtil.deleteCookie('test', 'test123');
		Assert.areEqual(HtmlUtil.readCookie('test'), null);		
	}

	@test
	function getUrlVarsTest() {
		Assert.areEqual(HtmlUtil.getUrlVars(), '');
/*		var vars:Dynamic<String> = cast {};
		var hash:Array<String>;
	    var hashes = js.Browser.window.location.search.substr(1).split('&');
	    for(i_ in 0...hashes.length) {
	        hash = hashes[i_].split('=');
	        Reflect.setField(vars, hash[0], hash[1]);
	    }
	    return vars;*/
	}

	@test
	function getUrlHashTest(){
		Assert.areEqual(HtmlUtil.getUrlHash(), '');
	}

	@test
	function getAndroidVersionTest() {
/*		var ua: String = js.Browser.navigator.userAgent;
		var regex: EReg = ~/Android\s([0-9\.]*)/;
	    var match = regex.match(ua);
	    var version: String = match ? regex.matched(1) : null;

	    if(version.isNotBlank()) {
	    	try {
	    		return Std.parseFloat(version);
    		} catch (err: Dynamic) {
    			m3.log.Logga.DEFAULT.error("Error parsing android version | " + version);
    		}
	    }
		return null;*/
	}
}