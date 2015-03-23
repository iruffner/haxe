package m3.test;

import m3.util.SizedMap;
import m3.test.Assert;

/*
new is missing, becuase we already create a new map in every other test case
*/

@:rtti class SizedMapTest{

  @test
  function setTest() {
  	var map = new SizedMap();

	map.set('a', 'b');

	if(!map.exists('a'))
	{
		Assert.fail("Item was not set");
	}
  }

  @test
  function removeTest() {
  	var map = new SizedMap();

  	map.set('a', 'b');

  	if(!map.exists('a'))
	{
		Assert.fail("Item was not set");
	}

  	map.remove('a');

	if(map.exists('a'))
	{
		Assert.fail("Item was not deleted");
	}
  }
}