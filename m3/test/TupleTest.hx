package m3.test;

import m3.util.Tuple;

@:rtti class TupleTest {
	public var left: Dynamic;
	public var right: Dynamic;

  private static var t1;
  private static var t2;
  private static var t3;

	@test
  function newTupleTest() {
    left = "apple";
    right = "pie";
    var t = new Tuple(left, right);
	}

  @test
  function newTuple2Test() {
    left = "apple";
    right = "pie";
    t2 = new Tuple2(left, right);
  }

  @test
  function toStringTuple2(){
    var test2 = t2.toString();
    Assert.areEqual(test2, '["apple","pie"]');
  }

  @test
  function newTuple3Test() {
    left = "apple";
    right = "pie";
    var third = ['Mercury', 'Venus', 'Earth', 'Mars', 'Jupiter', 'Saturn', 'Uranus', 'Neptune'];
    t3 = new Tuple3(left, right, third);
  }

  @test
  function toStringtuple3(){
    var test3 = t3.toString();
    Assert.areEqual(test3, '["apple","pie",["Mercury","Venus","Earth","Mars","Jupiter","Saturn","Uranus","Neptune"]]');
  }

}