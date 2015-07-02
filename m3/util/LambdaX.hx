package m3.util;


class LambdaX {

	/**
		Iterate with an index
	**/
	public static function iteri<A>( it : Iterable<A>, f : A -> Int -> Void ) {
		var i = 0;
		for( x in it ) {			
			f(x, i);
			i += 1;
		}
	}

	/**
		Collect from iterable where lambda = true
		example:
		things.collectX(function(thing){
			return thing.value == true;
		});
	**/
	public static function collectX<A>(it: Iterable<A>, f: Dynamic->Bool) {
		var collection: Array<Dynamic> = [];
		var i = 0;
		for (x in it) {
			var result: Bool = f(x);
			if (result == true) {
				collection.push(x);
			}
			i += 1;
		}
		return collection;
	}

}