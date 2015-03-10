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

    @test
    function indexOfComplexTest() {
        var expected = 1;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },
            {
                cube : 'CUBE2'
            }
        ];
        var actual = ArrayHelper.indexOfComplex(array,'CUBE2', 'cube');
        Assert.areEqual(expected, actual);

        var expected = -1;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },
            {
                cube : 'CUBE2'
            }
        ];
        var actual = ArrayHelper.indexOfComplex(array,'CUBE1', 'cube1');
        Assert.areEqual(expected, actual);   

        var expected = 0;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },{
                cube : 'CUBE2'
            },{
                func1: function(){return 'test';},
                func: function(){return 'test';}
            }
        ];
        var actual = ArrayHelper.indexOfComplex(array,'test', function(){return 'test';});
        Assert.areEqual(expected, actual);        
    }

    @test
    function indexOfComplexInSubArrayTest() {
        var expected = 1;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.indexOfComplexInSubArray(array,2, 'nums');
        Assert.areEqual(expected, actual);

        var expected = 0;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.indexOfComplexInSubArray(array,'C', 'cube');
        Assert.areEqual(expected, actual);

        var expected = -1;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.indexOfComplexInSubArray(array,'D', 'cube');
        Assert.areEqual(expected, actual);
    }

    @test
    function indexOfArrayComparisonTest() {
        var expected = 1;
        var actual = ArrayHelper.indexOfArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            }],
            [{value:'int', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);

        var expected = 2;
        var actual = ArrayHelper.indexOfArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int2'
            }],
            [{value:'int2', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);

        var expected = -1;
        var actual = ArrayHelper.indexOfArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int2'
            }],
            [{value:'int1', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);
   }

    //@test
    function getElementComplexTest() {
        var expected = 
        { 
            cube : 'C' 
        };
        var array : Array<Dynamic> = [
            {
                cube : 'C'
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.getElementComplex(array,'C', 'cube');
        Assert.areEqual(expected, actual);
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

    @test
    function containsComplexTest() {
        var expected = true;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },{
                cube : 'CUBE2'
            },{
                func1: function(){return 'test';},
                func: function(){return 'test';}
            }
        ];
        var actual = ArrayHelper.containsComplex(array,'test', function(){return 'test';});
        Assert.areEqual(expected, actual);

        var expected = true;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },{
                cube : 'CUBE2'
            },{
                func1: function(){return 'test1';},
                func: function(){return 'test';}
            }
        ];
        var actual = ArrayHelper.containsComplex(array,'CUBE2', 'cube');
        Assert.areEqual(expected, actual); 

        var expected = false;
        var array : Array<Dynamic> = [
            {
                requestObj : {
                    id : 1421241808259, 
                    context : {
                        viewType : 'table', 
                        parent : null, 
                        entries : 10, 
                        name : 'Cubes', 
                        uid : 1421154130414, 
                        colGroupings : [], 
                        drilldowns : [], 
                        levelBreaks : [], 
                        sort : [], 
                        dataCols : [], 
                        activeLink : false, 
                        editable : true, 
                        editing : false, 
                        preventAutoLoad : false
                    }, 
                    pageUid : 'yCPZlTr2KFOu4D6lrgIy', 
                    cube : 'CUBE1'
                },
                asd : 'asd',
            },{
                cube : 'CUBE2'
            },{
                func1: function(){return 'test';},
                func: function(){return 'test';}
            }
        ];
        var actual = ArrayHelper.containsComplex(array,'test', function(){return 'test1';});
        Assert.areEqual(expected, actual);         
    }

    @test
    function containsComplexInSubArrayTest() {
        var expected = true;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.containsComplexInSubArray(array,2, 'nums');
        Assert.areEqual(expected, actual);

        var expected = true;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.containsComplexInSubArray(array,'C', 'cube');
        Assert.areEqual(expected, actual);

        var expected = false;
        var array : Array<Dynamic> = [
            {
                cube : ['C','U','B','E','2']
            },
            {
                nums : [1,2,3],
            }
        ];
        var actual = ArrayHelper.containsComplexInSubArray(array,'D', 'cube');
        Assert.areEqual(expected, actual);
    }

    @test
    function containsArrayComparisonTest(){
        var expected = true;
        var actual = ArrayHelper.containsArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            }],
            [{value:'int', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);

        var expected = true;
        var actual = ArrayHelper.containsArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int2'
            }],
            [{value:'int2', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);

        var expected = false;
        var actual = ArrayHelper.containsArrayComparison([
            {
                cube : 'cube',
                field : 'field',
                dataType : 'intt'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int'
            },{
                cube : 'cube',
                field : 'field',
                dataType : 'int2'
            }],
            [{value:'int1', propOrFcn:"dataType"}]
        );
        Assert.areEqual(expected, actual);
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

    @test
    function joinXTest() {
        var expected = 'a.bcd.dd';
        var actual = ArrayHelper.joinX(['a', 'bcd', 'dd'], '.');
        Assert.areEqual(expected, actual);

        var expected = 'a,bcd,dd';
        var actual = ArrayHelper.joinX(['a', 'bcd', 'dd'], ',');
        Assert.areEqual(expected, actual);
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