package m3.test;

import haxe.rtti.CType;
import m3.exception.Exception;
import m3.log.Logga;
using m3.serialization.TypeTools;

using Lambda;

enum TestStatus {
	Running; 
	Pass; 
	Fail; 
	Error; 
}

class TestResults {
	public var status: TestStatus;
	public var messages: Array<String>;
	public var fail: Assert;
	public var error: Dynamic;
	public function new(status: TestStatus, messages: Array<String>) {
		this.status = status;
		this.messages = messages;
	}

}

class TestMethod {
	public var testClass: TestClass;
	public var name: String;
	public var resultsFunc: TestResults->Void;

	public function new(tc: TestClass, name: String) {
		this.testClass = tc;
		this.name = name;
	}

	public function runTest() {
		haxe.Timer.delay(_runTest, 0);
	}

	private function _runTest() {
		this.testClass.setup();

		resultsFunc(runTestImpl());
	}

	private function runTestImpl(): TestResults {

		var results = new TestResults(TestStatus.Running, new Array<String>());		

		try {
			results.messages.push("START -- " + Date.now());

			var instance = testClass.setup();

			try {
				testClass.runMethod(instance, name);
				results.status = TestStatus.Pass;
				results.messages.push("PASS");
			} catch (e: Assert ) {
				Logga.DEFAULT.error("Test Failed", e);
				results.status = TestStatus.Fail;				
				results.messages.push("FAIL -- " + e.message);
				results.messages.push(e.stackTrace());
			}

			testClass.teardown(instance);

	 	} catch ( e: Exception ) {
			results.status = TestStatus.Error;
			results.messages.push("ERROR -- " + e.message);
			try{
				results.messages.push(e.stackTrace());
			} catch (er: Dynamic) {
				trace("Couldn't push stacktrace");
			}
			results.error = e;
			Logga.DEFAULT.error("Error in Test", e);
	 	} catch ( e: Dynamic ) {
			results.status = TestStatus.Error;
			results.messages.push("ERROR -- " + e);
			results.messages.push("  " + e.stack);
			results.error = e;
			Logga.DEFAULT.error(e.stack);
	 	} 

	 	return results;

	}
}


class TestClass {

	var _clazz: Class<Dynamic>;
	var _classname: String;
    var _classDef: Classdef;

	var _setupMethods: Array<String>;
	var _teardownMethods: Array<String>;

	var _tests: Array<TestMethod>;

	public function new(clazz: Class<Dynamic>) {
		_clazz = clazz;
		_classname = _clazz.classname();

		_setupMethods = [];
		_teardownMethods = [];

		_tests = [];

		var rtti: String = untyped _clazz.__rtti;
		if ( rtti == null ) {
			var msg = "no rtti found for " + _classname;
			trace(msg);
			throw new Exception(msg);
		}

		var x = Xml.parse(rtti).firstElement();
        var typeTree: TypeTree = new haxe.rtti.XmlParser().processElement(x);

        _classDef = switch ( typeTree ) {
        	case TClassdecl(c): c;
        	default: throw new Exception("expected a class got " + typeTree);
        }
        var tests = [];

 		for ( f in _classDef.fields ) {
 			var fieldXml = x.elementsNamed(f.name).next();
 			if ( fieldXml.get("set") == "method" ) {
	 			for( meta in fieldXml.elementsNamed("meta") ) {
	 				for ( m in meta.elementsNamed("m") ) {
	 					switch( m.get("n") ) {
	 						case "setup": _setupMethods.push(f.name);
	 						case "teardown": _teardownMethods.push(f.name);
	 						case "test": tests.push(f.name);
	 					}
	 				}
	 			}
 		    }
 		}

 		_tests = [];
 		tests.iter(function(t) {
 			_tests.push(new TestMethod(this, t));
 		});
	}


	public function getName(): String {
		return _classname;
	}

	public function getTests(): Array<TestMethod> {
		return _tests;
	}

	public function runTests(): Void {
		_tests.iter(function(t) {
			t.runTest();
		});
	}

	function runMethods(obj: Dynamic, methods: Array<String>) {
		methods.iter(function(m) {
			runMethod(obj, m);
		});
	}

	public function setup(): Dynamic {
		var testInstance = Type.createInstance(_clazz, []);
		runMethods(testInstance, _setupMethods);
		return testInstance;
	}

	public function teardown(testInstance: Dynamic): Void {
		runMethods(testInstance, _teardownMethods);
	}

	public function runMethod(obj: Dynamic, method: String) {
		Reflect.callMethod(obj, Reflect.field(obj, method), []);
	}

}
