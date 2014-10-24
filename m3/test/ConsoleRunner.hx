package m3.test;

import m3.test.TestSuite;
import m3.log.Logga;
using m3.serialization.TypeTools;

using Lambda;

class ConsoleRunner {

	function getUnitTestClasses(): Array<Dynamic> {
		return [];
	}

	var _unitTestClasses: Array<TestClass>;

	function new() {
		_unitTestClasses = [];
		getM3TestClasses().iter(function(clazz) {
			try {
				_unitTestClasses.push(new TestClass(clazz));
			} catch ( e: Dynamic ) {
				Logga.DEFAULT.error("Error creating TestClass for " + clazz.classname());
				Logga.DEFAULT.error(e);
			}
		});

		getUnitTestClasses().iter(function(clazz) {
			try {
				_unitTestClasses.push(new TestClass(clazz));
			} catch ( e: Dynamic ) {
				Logga.DEFAULT.error("Error creating TestClass for " + clazz.classname());
				Logga.DEFAULT.error(e);
			}
		});
	}

	// All m3 units tests classes should go here
	private function getM3TestClasses() {
		var tests: Array<Dynamic> = [
			m3.test.DeepCompareTest,
			m3.test.MTest,
			m3.test.OSetTest,
			m3.test.SerializationTest,
			m3.test.StringHelperTest,
			m3.test.UidGenTest
		];
		return tests;
	}

	function start() {

		for (i in 0..._unitTestClasses.length) {
			var tw = _unitTestClasses[i];
			tw.getTests().iter(function(testMethod) {
				
				testMethod.resultsFunc = function(results:TestResults) {
					Logga.DEFAULT.log(testMethod.name);
					Logga.DEFAULT.log(results.status.getName());
					results.messages.iter(function(msg) {
						Logga.DEFAULT.log(msg);
					});
				}
			});
	    }
		
		runTests();

		trace("tests ran woot woot");
	}

	function runTests() {
		_unitTestClasses.iter(function(t) {
			t.runTests();
		});
	}			
}
