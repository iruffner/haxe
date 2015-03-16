package m3.test;

import m3.util.ColorProvider;
import m3.test.Assert;

/*untested functions:
__init__ - no use testing
getRandomColor - unable to really test
*/

@:rtti class ColorProviderTest {
	
	@test
	function getNextColorTest() {
		Assert.areEqual(ColorProvider.getNextColor(), "#5C9BCC");
		ColorProvider.getNextColor();
		Assert.areEqual(ColorProvider.getNextColor(), "#5CCC8C");
	}

	@test
/*	public static function getRandomColorTest(): String {
		var index: Int;
		do {
			index = Std.random(_COLORS.length);
		} while( _LAST_COLORS_USED.contains(index));
		_LAST_COLORS_USED.push(index);
		return _COLORS[index];
	}*/
}