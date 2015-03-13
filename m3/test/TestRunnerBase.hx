package m3.test;

import m3.test.TestSuite;
import m3.jq.JQ;
import m3.log.Logga;
using m3.serialization.TypeTools;

using Lambda;

class TestRunnerBase {

	function getUnitTestClasses(): Array<Dynamic> {
		return [];
	}

	var _unitTestClasses: Array<TestClass>;
	var logger: Dynamic;

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
		logger = {};
	}

	// All m3 units tests classes should go here
	private function getM3TestClasses() {
		var tests: Array<Dynamic> = [
			m3.test.BrowserUtilTest,
			m3.test.ColorProviderTest,
			m3.test.FixedSizeArrayTest,
			m3.test.DeepCompareTest,
			m3.test.HotKeyManagerTest,
			m3.test.HtmlUtilTest,
			m3.test.MTest,
			m3.test.OSetTest,
			m3.test.SerializationTest,
			m3.test.StringHelperTest,
			m3.test.UidGenTest,
			m3.test.ArrayHelperTest,
			m3.test.DateTest,
			m3.test.OSetHelperTest,
			m3.test.StringFormatHelperTest,
			m3.test.UidGeneratorTest,
			m3.test.SizedMapTest
		];
		return tests;
	}

    private function appendCell(html:Dynamic, row:JQ, ?attrs:Map<String, String>) {
        var cell: JQ = new JQ("<td></td>");
		cell.append(html);
		if (attrs != null) {
    		for (key in attrs.keys()) {
    		    cell.attr(key, attrs[key]);
    		}
		}
		row.append(cell);
    }
    
	function start() {

		var div = new JQ("#tests_go_here");

	    var testTable: JQ = new JQ('<table id="tests_go_here_table" cellspacing="5" cellpadding="5" ></table>');
	    testTable.append(new JQ('<thead><tr></tr></thead>'));
	    var tbody: JQ = new JQ('<tbody></tbody>');
        testTable.append(tbody);
        
        div.append(testTable);

		for (i in 0..._unitTestClasses.length) {
			var tw = _unitTestClasses[i];
			var titleRow: JQ = new JQ("<tr></tr>");
			appendCell("<h2>" + tw.getName() + "</h2>", titleRow, ["colspan" => "5", "align" => "left"]);
            tbody.append(titleRow);
    
			tw.getTests().iter(function(testMethod) {

				var resultsDiv = new JQ("<span>not run</span>");
				var logDiv = new JQ("<div style='width: 800px; border: 1px solid black; min-height: 50px; overflow: auto; max-height: 500px; display: none; margin: auto; text-align: left;'></div>");
				var toggler: JQ = new JQ("<span class=\"toggleTestLogs\">Toggle Logs</span>").button();
				toggler.click(function(evt: js.JQuery.JqEvent): Void {
					logDiv.toggle();
				});

				var button = new JQ("<button class=\"button runTestButton\">run</button>.button()").button();
				button.click(function(evt: js.JQuery.JqEvent): Void {
					testMethod.runTest();
				});
				
				var row: JQ = new JQ("<tr></tr>");
				tbody.append(row);
				
				appendCell("<b>" + testMethod.name + "</b>", row);
				appendCell(button, row);
				appendCell(resultsDiv, row);
				appendCell(toggler, row);
				appendCell(logDiv, row);

				testMethod.resultsFunc = function(results:TestResults) {
					resultsDiv.text(results.status.getName()).addClass('test'+results.status.getName());

					logDiv.empty();
					results.messages.iter(function(msg) {
						logDiv.append(msg).append("<br/>");
					});
				}
			});
            var row: JQ = new JQ("<tr></tr>");
            appendCell("<hr style=\"margin:5px\"/>", row, ["colspan" => "5"]);
			tbody.append(row);
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
