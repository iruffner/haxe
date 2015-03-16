package m3.test;

import m3.util.UidGenerator;
import m3.test.Assert;

/*Not tested:
- get_chars, get_nums - They return a simple hardcoded string nothing to test or fail
- randomIndex - is a rivate function
*/

@:rtti class UidGeneratorTest {
	@test
	function createTest(){
		var test1 = m3.util.UidGenerator.create();
		var test2 = m3.util.UidGenerator.create(15);
		if(test1.length == 0)
		{
			Assert.fail("Default key was not generated");
		}
		else if (test1.length != 20)
		{
			Assert.fail("Default key is not 20 character long");
		}
		if(test2.length == 0)
		{
			Assert.fail("15 character long key was not generated");
		}
		else if(test2.length != 15)
		{
			Assert.fail("The key which supposed to be 15 character long has different size");
		}
	}

	@test
	function isLetterTest()
	{
		var string1 = "a";
		var string2 = "&";

		var test1 = m3.util.UidGenerator.isLetter(string1);
		var test2 = m3.util.UidGenerator.isLetter(string2);

		trace(test1);
		trace(test2);

		Assert.isTrue(test1);
		Assert.isFalse(test2);
	}

	@test
	function randomNumTest()
	{
		var test = m3.util.UidGenerator.randomNum();

		if(Math.isNaN(test))
		{
			Assert.fail("The generated value is not a number");
		}
	}

	@test
	function randomCharTest()
	{
		var test = m3.util.UidGenerator.randomChar();
		var r = ~/[a-z1-9]/i;

		if(!r.match(test))
		{
			Assert.fail("The generated value is not a character");
		}
	}

	@test
	function randomNumChar()
	{
		var test = m3.util.UidGenerator.randomNumChar();

		if(Math.isNaN(test))
		{
			Assert.fail("The generated value is not a number");
		}
	}
}