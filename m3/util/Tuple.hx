package m3.util;

class Tuple<L,R> {
	public var left: L;
	public var right: R;

	public function new(?l: L, ?r: R) {
		this.left = l;
		this.right = r;
	}
}

class Tuple2<A1,A2> {

  public var _1(default, null): A1;
  public var _2(default, null): A2;

  public function new(_1: A1, _2: A2) {
    this._1 = _1;
    this._2 = _2;
  }

  public function toString(): String {
    return haxe.Json.stringify([_1,_2]);
  }

}


class Tuple3<A1,A2,A3> {

  public var _1(default, null): A1;
  public var _2(default, null): A2;
  public var _3(default, null): A3;

  public function new(_1: A1, _2: A2, _3: A3) {
    this._1 = _1;
    this._2 = _2;
    this._3 = _3;
  }

  public function toString(): String {
    return haxe.Json.stringify([_1,_2,_3]);
  }

}