package m3.test;

import m3.helper.ArrayHelper;
import m3.test.Assert;

typedef ArrayComparison = {
    var propOrFcn:Dynamic;
    var value:Dynamic;
}

// this is exposed for BI
@:rtti class ArrayHelperTest {

    @test
    function indexOfTest(){
        var expected = 1;
        var actual = ArrayHelper.indexOf([1,2,3], 2);
        Assert.areEqual(expected, actual);

        var expected1 = 0;
        var actual1 = ArrayHelper.indexOf([1,2,3], 1);
        Assert.areEqual(expected1, actual1);

        var expected1 = -1;
        var actual1 = ArrayHelper.indexOf([1,2,3], 0);
        Assert.areEqual(expected1, actual1);
    }

    public static function indexOfComplexTest(array:Array<Dynamic>, value:Dynamic, propOrFcn:Dynamic, ?startingIndex:Int=0):Int {

        var result = -1;
        if(array != null && array.length > 0) {
            for(idx_ in startingIndex...array.length) {
                var comparisonValue;
                if(Std.is(propOrFcn, String)) {
                    comparisonValue = Reflect.field(array[idx_], propOrFcn);
                } else {
                    comparisonValue = propOrFcn(array[idx_]);
                }
                if(value == comparisonValue) {
                    result = idx_;
                    break;
                }
            }
        }
        return result;
    }

    public static function indexOfComplexInSubArrayTest(array:Array<Dynamic>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):Int {
        if(array == null) return -1;
        var result = -1;
/*        for(idx_ in startingIndex...array.length) {
            var subArray = Reflect.field(array[idx_], subArrayProp);
            if(contains(subArray, value)) {
                result = idx_;
                break;
            }
        }
*/        return result;
    }

    public static function indexOfArrayComparisonTest<T>(array:Array<T>, comparison:Array<ArrayComparison>, ?startingIndex:Int=0):Int {
        var result:Int = -1;
/*        if(array != null) {
            if(hasValues(comparison)) {
                var base:ArrayComparison = comparison[0];
                var baseIndex = indexOfComplex(array, base.value, base.propOrFcn, startingIndex);
                while(baseIndex > -1 && result < 0) {
                    var candidate:T = array[baseIndex];
                    var breakOut:Bool = false;
                    for(c_ in 1...comparison.length) {
                        var comparisonValue;
                        if(Std.is(comparison[c_].propOrFcn, String)) {
                            comparisonValue = Reflect.field(candidate, comparison[c_].propOrFcn);
                        } else {
                            comparisonValue = comparison[c_].propOrFcn(candidate);
                        }
                        if(comparison[c_].value == comparisonValue) {
                            continue;
                        } else {
                            baseIndex = indexOfComplex(array, base.value, base.propOrFcn, baseIndex+1);
                            breakOut = true;
                            break;
                        }
                    } 
                    if(breakOut) continue;
                    result = baseIndex;  
                }
            }
        }*/
        
        return result;
    }

    public static function getElementComplexTest<T>(array:Array<T>, value:Dynamic, propOrFcn:Dynamic, ?startingIndex:Int=0):T {
        if(array == null) return null;
        var result:T = null;
        for(idx_ in startingIndex...array.length) {
            var comparisonValue;
            if(Std.is(propOrFcn, String)) {
                comparisonValue = Reflect.field(array[idx_], propOrFcn);
            } else {
                comparisonValue = propOrFcn(array[idx_]);
            }
            if(value == comparisonValue) {
                result = array[idx_];
                break;
            }
        }
        return result;
    }

    public static function getElementComplexInSubArrayTest<T>(array:Array<T>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):T {
        if(array == null) return null;
        var result:T = null;
        for(idx_ in startingIndex...array.length) {
            var subArray = Reflect.field(array[idx_], subArrayProp);
            if(ArrayHelper.contains(subArray, value)) {
                result = array[idx_];
                break;
            }
        }
        return result;
    }

    public static function getElementArrayComparisonTest<T>(array:Array<T>, comparison:Array<ArrayComparison>, ?startingIndex:Int=0):T {
        var result:T = null;
        if(array != null) {
            if(ArrayHelper.hasValues(comparison)) {
                var base:ArrayComparison = comparison[0];
                var baseIndex = ArrayHelper.indexOfComplex(array, base.value, base.propOrFcn, startingIndex);
                while(baseIndex > -1 && result == null) {
                    var candidate:T = array[baseIndex];
                    var breakOut:Bool = false;
                    for(c_ in 1...comparison.length) {
                        var comparisonValue;
                        if(Std.is(comparison[c_].propOrFcn, String)) {
                            comparisonValue = Reflect.field(candidate, comparison[c_].propOrFcn);
                        } else {
                            comparisonValue = comparison[c_].propOrFcn(candidate);
                        }
                        if(comparison[c_].value == comparisonValue) {
                            continue;
                        } else {
                            baseIndex = ArrayHelper.indexOfComplex(array, base.value, base.propOrFcn, baseIndex+1);
                            breakOut = true;
                            break;
                        }
                    } 
                    if(breakOut) continue;
                    result = candidate;
                }
            }
        }
        
        return result;
    }

    @test
    function containsTest(){
        var expected = true;
        var actual = ArrayHelper.contains([1,2,3], 2);
        Assert.areEqual(expected, actual);

        var expected1 = true;
        var actual1 = ArrayHelper.contains(['a','b','c'],'a');
        Assert.areEqual(expected1, actual1);

        var expected2 = false;
        var actual2 = ArrayHelper.contains([1,2,3], 0);
        Assert.areEqual(expected2, actual2);
    }

    @test
    function containsAnyTest() {
        var expected = true;
        var actual = ArrayHelper.containsAny([1,2,3], [1,2]);
        Assert.areEqual(expected, actual);

        var expected = true;
        var actual = ArrayHelper.containsAny(['a','b','c'], ['b', 'd']);
        Assert.areEqual(expected, actual);

        var expected = false;
        var actual = ArrayHelper.containsAny([1,2,3], [0,-1]);
        Assert.areEqual(expected, actual);
    }

    @test
    function containsAllTest() {
        var expected = true;
        var actual = ArrayHelper.containsAll([1,2,3], [1,2]);
        Assert.areEqual(expected, actual);

        var expected = true;
        var actual = ArrayHelper.containsAll(['a','b','c'], ['b']);
        Assert.areEqual(expected, actual);

        var expected = false;
        var actual = ArrayHelper.containsAll([1,2,3], [1,2,4]);
        Assert.areEqual(expected, actual);     

        var expected = false;
        var actual = ArrayHelper.containsAll(['a','b','c'], ['a','b','d']);
        Assert.areEqual(expected, actual);     
    }

    public static function containsComplexTest<T>(array:Array<T>, value:Dynamic, propOrFcn:Dynamic, ?startingIndex:Int=0):Bool {
        if(array == null) return false;
        var contains = ArrayHelper.indexOfComplex(array, value, propOrFcn, startingIndex);
        return contains > -1;
    }

    public static function containsComplexInSubArrayTest<T>(array:Array<T>, value:Dynamic, subArrayProp:String, ?startingIndex:Int=0):Bool {
        if(array == null) return false;
        var contains = ArrayHelper.indexOfComplexInSubArray(array, value, subArrayProp, startingIndex);
        return contains > -1;
    }

    public static function containsArrayComparisonTest<T>(array:Array<T>, comparison:Array<ArrayComparison>, ?startingIndex:Int=0):Bool {
        if(array == null) return false;
        var contains = ArrayHelper.indexOfArrayComparison(array, comparison, startingIndex);
        return contains > -1;
    }

    @test
    function hasValuesTest(){
        var expected = true;
        var actual = ArrayHelper.hasValues([1,2,3]);
        Assert.areEqual(expected, actual);

        var expected = true;
        var actual = ArrayHelper.hasValues(['a','b']);
        Assert.areEqual(expected, actual);

        var expected = false;
        var actual = ArrayHelper.hasValues(null);
        Assert.areEqual(expected, actual);        
    }

    public static function joinXTest(array: Array<String>, sep: String): String {
        if(array == null) return null;
        var s: String = "";
/*        for(str_ in 0...array.length) {
            var tmp: String = array[str_];
            if(tmp.isNotBlank()) {
                tmp = tmp.trim();
            }
            if(tmp.isNotBlank() && str_ > 0 && s.length > 0) {
                s += sep;
            }
            s += array[str_];
        }
*/        return s;
    }

    @test
    function addAllTest() {
        var expected  : Array<Dynamic> = [1,2,3,4];
        var actual : Array<Dynamic> = [1,2];
        ArrayHelper.addAll(actual, [3,4]);
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));

        var expected : Array<Dynamic> = ['a', 'b', 'c', 'd'];
        var actual : Array<Dynamic> = ['a', 'b'];
        ArrayHelper.addAll(actual, ['c', 'd']);
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));

        var expected : Array<Dynamic> = [1, 2, 'a', 'b'];
        var actual : Array<Dynamic> = [1, 2];
        ArrayHelper.addAll(actual, ['a', 'b']);
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));
    }

    @test
    function arrayEquals(){
        var expected  : Array<Dynamic> = [1,2];
        var actual : Array<Dynamic> = [1,2];
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));

        var expected : Array<Dynamic> = ['a', 'b', 'c', 'd'];
        var actual : Array<Dynamic> = ['a', 'b', 'c', 'd'];
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));

        var expected : Array<Dynamic> = [1, 2, 'a', 'b'];
        var actual : Array<Dynamic> = [1, 2, 'a', 'b'];
        Assert.isTrue(ArrayHelper.arrayEquals(expected, actual));

        var expected : Array<Dynamic> = [1, 2, 'a'];
        var actual : Array<Dynamic> = [1, 2, 'a', 'b'];
        Assert.isFalse(ArrayHelper.arrayEquals(expected, actual));
    }
}