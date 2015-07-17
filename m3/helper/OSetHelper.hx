package m3.helper;

import m3.observable.OSet;

using m3.helper.StringHelper;
using m3.helper.ArrayHelper;
using StringTools;

@:expose
class OSetHelper {
    public static function getElement<T,V>(oset: OSet<T>, value: V, ?fcn: T->V, ?caseInsensitive: Bool=true, ?startingIndex: Int=0): T {
        if(oset == null) return null;
        if(fcn == null) {
            fcn = cast oset.identifier();
        }
        var result: T = null;
        var index_ = -1;
        var iter: Iterator<T> = oset.iterator();
        if(caseInsensitive && Std.is(value, String)) {
            value = cast Std.string(value).toLowerCase();
        }
        while(iter.hasNext()) {
            if(startingIndex > ++index_) {
                continue; //we need to get farther into the set
            } else {
                var comparisonT: T = iter.next();
                var comparisonValue = fcn(comparisonT);
                if(caseInsensitive && Std.is(comparisonValue, String)) {
                    comparisonValue = cast Std.string(comparisonValue).toLowerCase();
                }
                if(value == comparisonValue) {
                    result = comparisonT;
                    break;
                }

            }
        }
        return result;
    }

    // public static function getElementComplex2<T>(oset: OSet<T>, criteriaFunc:T->Bool): T {
    //     if(oset == null) return null;
    //     if(criteriaFunc == null) { return null; }

    //     var result: T = null;
    //     var iter: Iterator<T> = oset.iterator();
    //     while(iter.hasNext()) {
    //         var comparisonT: T = iter.next();
    //         if (criteriaFunc(comparisonT)) {
    //             result = comparisonT;
    //             break;
    //         }
    //     }
    //     return result;
    // }

    // public static function getElementComplexInSubArray<T>(array:Array<T>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):T {
    //     if(array == null) return null;
    //     var result:T = null;
    //     for(idx_ in startingIndex...array.length) {
    //         var subArray = Reflect.field(array[idx_], subArrayProp);
    //         if(ArrayHelper.contains(subArray, value)) {
    //             result = array[idx_];
    //             break;
    //         }
    //     }
    //     return result;
    // }

    // public static function getElementArrayComparison<T>(array:Array<T>, comparison:Array<ArrayComparison>, ?startingIndex:Int=0):T {
    //     var result:T = null;
    //     if(array != null) {
    //         if(hasValues(comparison)) {
    //             var base:ArrayComparison = comparison[0];
    //             var baseIndex = indexOfComplex(array, base.value, base.propOrFcn, startingIndex);
    //             while(baseIndex > -1 && result == null) {
    //                 var candidate:T = array[baseIndex];
    //                 var breakOut:Bool = false;
    //                 for(c_ in 1...comparison.length) {
    //                     var comparisonValue;
    //                     if(Std.is(comparison[c_].propOrFcn, String)) {
    //                         comparisonValue = Reflect.field(candidate, comparison[c_].propOrFcn);
    //                     } else {
    //                         comparisonValue = comparison[c_].propOrFcn(candidate);
    //                     }
    //                     if(comparison[c_].value == comparisonValue) {
    //                         continue;
    //                     } else {
    //                         baseIndex = indexOfComplex(array, base.value, base.propOrFcn, baseIndex+1);
    //                         breakOut = true;
    //                         break;
    //                     }
    //                 } 
    //                 if(breakOut) continue;
    //                 result = candidate;
    //             }
    //         }
    //     }
        
    //     return result;
    // }

    /*
     *  Checks for existance of the identifer (@parm value) in the OSet
     */
    public static function contains<T>(oset: OSet<T>, value:String, ?startingIndex:Int=0):Bool {
        return containsComplex(oset, value, cast oset.identifier, startingIndex);
    }

    // public static function containsAny<T>(array:Array<T>, valueArray:Array<T>):Bool {
    //     if(array == null || valueArray == null) return false;
    //     var contains:Int = -1;
    //     for(v_ in 0...valueArray.length) {
    //         contains = Lambda.indexOf(array, valueArray[v_]);
    //         if(contains > -1) {
    //             break;
    //         }
    //     }
    //     return contains > -1;
    // }

    // public static function containsAll<T>(array:Array<T>, valueArray:Array<T>):Bool {
    //     if(array == null || valueArray == null) return false;
    //     var anyFailures = false;
    //     for(v_ in 0...valueArray.length) {
    //         var index:Int = Lambda.indexOf(array, valueArray[v_]);
    //         if(index < 0) {
    //             anyFailures = true;
    //             break;
    //         }
    //     }
    //     return !anyFailures;
    // }

    public static function containsComplex<T>(oset: OSet<T>, value:Dynamic, propOrFcn:Dynamic, ?startingIndex:Int=0):Bool {
        if(oset == null) return false;
        var element = getElement(oset, value, propOrFcn, startingIndex);
        return element != null;
    }

    // public static function containsComplexInSubArray<T>(array:Array<T>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):Bool {
    //     if(array == null) return false;
    //     var contains = indexOfComplexInSubArray(array, value, subArrayProp, startingIndex);
    //     return contains > -1;
    // }

    // public static function containsArrayComparison<T>(array:Array<T>, comparison:Array<ArrayComparison>, ?startingIndex:Int=0):Bool {
    //     if(array == null) return false;
    //     var contains = indexOfArrayComparison(array, comparison, startingIndex);
    //     return contains > -1;
    // }

    public static function hasValues<T>(oset: OSet<T>):Bool {
        return oset != null && oset.iterator().hasNext();
    }

    public static function joinX<T>(oset: OSet<T>, sep: String, ?getString: T->String): String {
        if(getString == null) {
            getString = oset.identifier();
        }
        var s: String = "";
        var iter: Iterator<T> = oset.iterator();
        var index: Int = 0;
        while(iter.hasNext()) {
            var t: T = iter.next();
            var tmp: String = getString(t);
            if(tmp.isNotBlank()) {
                tmp = tmp.trim();
            }
            if(tmp.isNotBlank() && index > 0 && s.length > 0) {
                s += sep;
            }
            s += getString(t);
            index++;
        }
        return s;
    }

    public static function strIdentifier(str: String): String {
        return str;
    }
}