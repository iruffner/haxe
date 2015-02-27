package m3.zoolander;

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



