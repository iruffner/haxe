package m3.zoolander;





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



/**
  *   A is the instance type 
  *   B is the key type
  */
class InstanceContainer<A,B> {

  var _map: Map<String,A>;

  var _keyGetter: A->B;

  public function new(keyGetter: A->B) {
    _map = new Map<String,A>();
    _keyGetter = keyGetter;
  }

  public function aToKey(a: A): String {
    return bToKey(_keyGetter(a));
  }

  public function bToKey(b: B): String {
    return Std.string(b);
  }

  public function add(a: A): A {
    _map[aToKey(a)] = a;
    return a;
  }

  public function remove(a: A): Bool {
    return _map.remove(aToKey(a));
  }
  public function removeByKey(b: B): Bool {
    return _map.remove(bToKey(b));
  }

  public function fetch(b: B): A {
    return _map.get(bToKey(b));
  }

}



