package m3.test;

using m3.helper.ArrayHelper;
import m3.util.FixedSizeArray;
import m3.test.Assert;

/*untested functions:
pushTest - contained in testfixedSizeArray
containsTest - testfixedSizeArray
*/


@:rtti class FixedSizeArrayTest{

	@test
	function testfixedSizeArray() {
		var fixedarray : m3.util.FixedSizeArray<Int> = new FixedSizeArray(3);
		fixedarray.push(1);
		Assert.areEqual(fixedarray.contains(1), true);
		fixedarray.push(2);
		Assert.areEqual(fixedarray.contains(2), true);
		fixedarray.push(3);
		Assert.areEqual(fixedarray.contains(3), true);
		fixedarray.push(4);
		Assert.areEqual(fixedarray.contains(1), false);
		Assert.areEqual(fixedarray.contains(4), true);
	}

/*	@test
	function pushTest(){
		var fixedarray : m3.util.FixedSizeArray<Int> = new FixedSizeArray(3);
		fixedarray.push(1);
		Assert.areEqual(fixedarray.contains(1), true);
		fixedarray.push(2);
		Assert.areEqual(fixedarray.contains(2), true);
		fixedarray.push(3);
		Assert.areEqual(fixedarray.contains(3), true);
		fixedarray.push(4);
		Assert.areEqual(fixedarray.contains(1), false);
		Assert.areEqual(fixedarray.contains(4), true);
	}

	@test
	function containsTest(){
		var fixedarray : m3.util.FixedSizeArray<Int> = new FixedSizeArray(3);
		fixedarray.push(1);
		Assert.areEqual(fixedarray.contains(1), true);
		fixedarray.push(2);
		Assert.areEqual(fixedarray.contains(2), true);
		fixedarray.push(3);
		Assert.areEqual(fixedarray.contains(3), true);
		fixedarray.push(4);
		Assert.areEqual(fixedarray.contains(1), false);
		Assert.areEqual(fixedarray.contains(4), true);		
	}*/
	
}