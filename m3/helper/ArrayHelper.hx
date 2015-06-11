package m3.helper;

using m3.helper.StringHelper;
using StringTools;

typedef ArrayComparison<T,V> = {
    var fcn:T->V;
    var value:V;
}

// this is exposed for BI
@:expose
class ArrayHelper {

    private static function __init__(): Void {
        untyped __js__("if(!Array.indexOf){Array.prototype.indexOf = function(obj){for(var i=0; i<this.length; i++){if(this[i]==obj){return i;}}return -1;}}");
    }

    public static function indexOfComplex<T,V>(array:Array<T>, value:V, ?fcn:T->V, ?caseInsensitive: Bool=true, ?startingIndex:Int=0):Int {
        if(array == null) return -1;
        var result = -1;
        if(caseInsensitive && Std.is(value, String)) {
            value = cast Std.string(value).toLowerCase();
        }
        for(idx_ in startingIndex...array.length) {
            var comparisonValue: V = {
                if(fcn == null) cast array[idx_];
                else fcn(array[idx_]);
            }
            if(caseInsensitive && Std.is(comparisonValue, String)) {
                comparisonValue = cast Std.string(comparisonValue).toLowerCase();
            }
            if(value == comparisonValue) {
                result = idx_;
                break;
            }
        }
        return result;
    }

    public static function indexOfArrayComparison<T,V>(array:Array<T>, comparison:Array<ArrayComparison<T,V>>, ?startingIndex:Int=0):Int {
        var result:Int = -1;
        if(array != null) {
            if(hasValues(comparison)) {
                var base:ArrayComparison<T,V> = comparison[0];
                var baseIndex = indexOfComplex(array, base.value, base.fcn, startingIndex);
                while(baseIndex > -1 && result < 0) {
                    var candidate:T = array[baseIndex];
                    var breakOut:Bool = false;
                    for(c_ in 1...comparison.length) {
                        var comparisonValue = comparison[c_].fcn(candidate);
                        if(comparison[c_].value == comparisonValue) {
                            continue;
                        } else {
                            baseIndex = indexOfComplex(array, base.value, base.fcn, baseIndex+1);
                            breakOut = true;
                            break;
                        }
                    } 
                    if(breakOut) continue;
                    result = baseIndex;  
                }
            }
        }      
        return result;
    }

    public static function getElement<T,V>(array:Array<T>, value:V, fcn:T->V, ?caseInsensitive: Bool=true, ?startingIndex:Int=0):T {
        if(array == null) return null;
        var result:T = null;
        if(caseInsensitive && Std.is(value, String)) {
            value = cast Std.string(value).toLowerCase();
        }
        for(idx_ in startingIndex...array.length) {
            var comparisonValue = fcn(array[idx_]);
            if(caseInsensitive && Std.is(comparisonValue, String)) {
                comparisonValue = cast Std.string(comparisonValue).toLowerCase();
            }
            if(value == comparisonValue) {
                result = array[idx_];
                break;
            }
        }
        return result;
    }

    public static function getElementArrayComparison<T,V>(array:Array<T>, comparison:Array<ArrayComparison<T,V>>, ?startingIndex:Int=0):T {
        var result:T = null;
        if(hasValues(array) && hasValues(comparison)) {
            var base:ArrayComparison<T,V> = comparison[0];
            var baseIndex = indexOfComplex(array, base.value, base.fcn, startingIndex);
            while(baseIndex > -1 && result == null) {
                var candidate:T = array[baseIndex];
                var breakOut:Bool = false;
                for(c_ in 1...comparison.length) {
                    var comparisonValue = comparison[c_].fcn(candidate);
                    if(comparison[c_].value == comparisonValue) {
                        continue;
                    } else {
                        baseIndex = indexOfComplex(array, base.value, base.fcn, baseIndex+1);
                        breakOut = true;
                        break;
                    }
                } 
                if(breakOut) continue;
                result = candidate;
            }
        }
        
        return result;
    }

    public static function contains<T>(array:Array<T>, value:T):Bool {
        if(array == null) return false;
        var contains = Lambda.indexOf(array, value);
        return contains > -1;
    }

    public static function containsAny<T>(array:Array<T>, valueArray:Array<T>):Bool {
        if(array == null || valueArray == null) return false;
        var contains:Int = -1;
        for(v_ in 0...valueArray.length) {
            contains = Lambda.indexOf(array, valueArray[v_]);
            if(contains > -1) {
                break;
            }
        }
        return contains > -1;
    }

    public static function containsAll<T>(array:Array<T>, valueArray:Array<T>):Bool {
        if(array == null || valueArray == null) return false;
        var anyFailures = false;
        for(v_ in 0...valueArray.length) {
            var index:Int = Lambda.indexOf(array, valueArray[v_]);
            if(index < 0) {
                anyFailures = true;
                break;
            }
        }
        return !anyFailures;
    }

    public static function containsComplex<T,V>(array:Array<T>, value:V, fcn:T->V, ?startingIndex:Int=0):Bool {
        if(array == null) return false;
        var contains = indexOfComplex(array, value, fcn, startingIndex);
        return contains > -1;
    }

    // public static function containsComplexInSubArray<T>(array:Array<T>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):Bool {
    //     if(array == null) return false;
    //     var contains = indexOfComplexInSubArray(array, value, subArrayProp, startingIndex);
    //     return contains > -1;
    // }

    public static function containsArrayComparison<T,V>(array:Array<T>, comparison:Array<ArrayComparison<T,V>>, ?startingIndex:Int=0):Bool {
        if(array == null) return false;
        var contains = indexOfArrayComparison(array, comparison, startingIndex);
        return contains > -1;
    }

    public static function hasValues<T>(array:Array<T>):Bool {
        return array != null && array.length > 0;
    }

    public static function joinX(array: Array<String>, sep: String): String {
        if(array == null) return null;
        var s: String = "";
        for(str_ in 0...array.length) {
            var tmp: String = array[str_];
            if(tmp.isNotBlank()) {
                tmp = tmp.trim();
            }
            if(tmp.isNotBlank() && str_ > 0 && s.length > 0) {
                s += sep;
            }
            s += array[str_];
        }
        return s;
    }

    public static function addAll<T>(array:Array<T>, array2:Array<T>):Void {
        if(array != null && hasValues(array2)) {
            for(t in array2) array.push(t);
        }
    }

    public static function arrayEquals(array1: Array<Dynamic>, array2:Array<Dynamic>): Bool{
        if(array1 != null && array2 != null){
            if(array1.length != array2.length){
                return false;
            }else{
                for(i in 0...array1.length){
                    if(array1[i] != array2[i]) return false;
                }
                return true;
            }
        }

        return false;
    }

    public static function removeElement<T,V>(array:Array<T>, value:V, fcn:T->V, ?caseInsensitive: Bool=true, ?startingIndex:Int=0): Bool {
        var result = false;
        if(array == null) return result;
        if(caseInsensitive && Std.is(value, String)) {
            value = cast Std.string(value).toLowerCase();
        }
        for(idx_ in startingIndex...array.length) {
            var comparisonValue: V = {
                if(fcn == null) cast array[idx_];
                else fcn(array[idx_]);
            }
            if(caseInsensitive && Std.is(comparisonValue, String)) {
                comparisonValue = cast Std.string(comparisonValue).toLowerCase();
            }
            if(value == comparisonValue) {
                array.splice(idx_, 1);
                result = true;
                break;
            }
        }
        return result;
    }
}