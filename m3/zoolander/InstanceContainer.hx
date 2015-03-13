package m3.zoolander;

import m3.observable.OSet;

using m3.helper.OSetHelper;

/**
  *   A is the instance type 
  *   B is the key type
  */
class InstanceContainer<A,B> {

  var _oset: ObservableSet<A>;

  var _keyGetter: A->B;

  public function new(keyGetter: A->B) {
    _oset = new ObservableSet<A>(aToKey);
    _keyGetter = keyGetter;
  }

  public function aToKey(a: A): String {
    return bToKey(_keyGetter(a));
  }

  public function bToKey(b: B): String {
    return Std.string(b);
  }

  public function add(a: A): A {
    _oset.add(a);
    return a;
  }

  public function remove(a: A): Void {
    _oset.delete(a);
  }
  public function removeByKey(b: B): Void {
    _oset.delete(fetch(b));
  }

  public function fetch(b: B): A {
    return _oset.getElement(bToKey(b));
  }

  public function iterator(): Iterator<A> {
    return _oset.iterator();
  }

  public function oset(): ObservableSet<A> {
    return _oset;
  }

}



