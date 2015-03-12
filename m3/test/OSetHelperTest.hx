package m3.test;

import m3.helper.OSetHelper;
import m3.observable.OSet;
import m3.test.Assert;
import m3.test.OSetTest;
import m3.util.M;

using Lambda;

@:rtti class OSetHelperTest {

	@test
	function getElementComplex(){
		var set = new ObservableSet<String>(M.fn1(it));
		trace(set);
	}

	@test
	function joinXTest(){
		var oset = sampleSet();
		var oset2 = sampleSet2();

		var test1 = OSetHelper.joinX(oset, '|');
		var test2 = OSetHelper.joinX(oset, '|', oset2.identifier());

		trace(test2);

		Assert.areEqual(test1, 'a|b|c');
		Assert.areEqual(test2, 'testMenuId|testMenuId|testMenuId');
	}

	@test
	function hasValuesTest(){
		var oset = sampleSet();
		var oset2 = new ObservableSet<MenuItem>(M.fn1(it.uid));

		var test1 = OSetHelper.hasValues(oset);
		var test2 = OSetHelper.hasValues(oset2);

		Assert.isTrue(test1);
		Assert.isFalse(test2);
	}

	@test
	function strIdentifierTest(){
		var string1 = "Lorem ipsum";
		var string2 = '"abc" "12.5" "cde%#)" 80 *(`~ ';

		var test1 = OSetHelper.strIdentifier(string1);
		var test2 = OSetHelper.strIdentifier(string2);

		Assert.areEqual(string1, test1);
		Assert.areEqual(string2, test2);
	}

	function sampleSet(){
		var oset = new ObservableSet<MenuItem>(M.fn1(it.uid));

		var a: MenuItem = {
			uid: "a",
			category: "coolness",
			description: "loads of coolness"
		}

		var b: MenuItem = {
			uid: "c",
			category: "meganess",
			description: "when you need more -ness go mega"
		}

		var c: MenuItem = {
			uid: "b",
			category: "coolness",
			description: "extra coolness"
		}

		oset.add(a);
		oset.add(c);
		oset.add(b);

		return oset;
	}

	function sampleSet2(){
		var oset = new ObservableSet<MenuItem>(M.fn1("testMenuId"));

		var a: MenuItem = {
			uid: "a",
			category: "coolness",
			description: "loads of coolness"
		}

		var b: MenuItem = {
			uid: "c",
			category: "meganess",
			description: "when you need more -ness go mega"
		}

		var c: MenuItem = {
			uid: "b",
			category: "coolness",
			description: "extra coolness"
		}

		var d: MenuItem = {
			uid: "d",
			category: "ultra mega coolness",
			description: "say what!?! coolness"
		};

		oset.add(a);
		oset.add(c);
		oset.add(b);

		return oset;
	}
}