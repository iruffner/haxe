package m3.test;

import m3.helper.StringFormatHelper;
import m3.test.Assert;

/*untested functions:
toString
formatNumber - is missing because it's used by a lot of function what is aleady
here, for toFormattedNumberDyn and toFormattedNumberDyn just call it with different parameters
*/

@:rtti class StringFormatHelperTest {


	@test
	function toStringTest(){
		var string1 = 100;
		var string2 = null;
		var string3 = {
			'sampleKey'	:'sampleValue',
			'testKey'	:'testValue'
		}

		var test1 = m3.helper.StringFormatHelper.toString(string1);
		var test2 = m3.helper.StringFormatHelper.toString(string2);
		var test3 = m3.helper.StringFormatHelper.toString(string3);

		trace(test3);

		Assert.areEqual(test1, "100");
		Assert.areEqual(test2, "null");
		Assert.areEqual(test3, "{
	sampleKey : sampleValue, 
	testKey : testValue
}");
	}

	@test
	function nullsAsEmptyStrTest()
	{
		var string1 = 100;
		var string2 = null;

		var test1 = m3.helper.StringFormatHelper.nullsAsEmptyStr(string1);
		var test2 = m3.helper.StringFormatHelper.nullsAsEmptyStr(string2);

		Assert.areEqual(test1, "100");
		Assert.areEqual(test2, "");
	}

	@test
	function parameterizeTest()
	{
		var string1 = "abc025^$~ ^- test -$";
		var string2 = "abc $ | ^";

		var test1 = m3.helper.StringFormatHelper.parameterize(string1);
		var test2 = m3.helper.StringFormatHelper.parameterize(string2);

		Assert.areEqual(test1, "abc025-------test--");
		Assert.areEqual(test2, "abc-----");
	}

	@test
	function htmlEscapeTest()
	{
		var string1 = "<script type='text/javascript'>";
		var string2 = "&amp;";

		var test1 = m3.helper.StringFormatHelper.htmlEscape(string1);
		var test2 = m3.helper.StringFormatHelper.htmlEscape(string2);

		Assert.areEqual(test1, "&lt;script type='text/javascript'&gt;");
		Assert.areEqual(test2, "&amp;amp;");
	}

	@test
	function toDecimalTest()
	{
		var string1 = "100";
		var string2 = "10.00005";
		var string3 = "1000.5";

		var options = {
			numberOfDecimals: 3,
	        decimalSeparator: '.',
	        thousandSeparator: ' '
		}

		var test1 = m3.helper.StringFormatHelper.toDecimal(string1, options);
		var test2 = m3.helper.StringFormatHelper.toDecimal(string2, options);
		var test3 = m3.helper.StringFormatHelper.toDecimal(string3, options);

		Assert.areEqual(test1, "100.000");
		Assert.areEqual(test2, "10.000");
		Assert.areEqual(test3, "1 000.500");
	}

	@test
	function toCurrencyTest()
	{
		var string1 = "100";
		var string2 = "10.00005";
		var string3 = "1000.5";

		var test1 = m3.helper.StringFormatHelper.toCurrency(string1, true, false);
		var test2 = m3.helper.StringFormatHelper.toCurrency(string2, true, true);
		var test3 = m3.helper.StringFormatHelper.toCurrency(string3, false, true);

		Assert.areEqual(test1, "$100");
		Assert.areEqual(test2, "$10.00");
		Assert.areEqual(test3, "$1,001");
	}

	@test
	function toPercentageTest()
	{
		var string1 = "100";
		var string2 = "10.00005";
		var string3 = "1000.5";

		var test1 = m3.helper.StringFormatHelper.toPercentage(string1);
		var test2 = m3.helper.StringFormatHelper.toPercentage(string2);
		var test3 = m3.helper.StringFormatHelper.toPercentage(string3);

		Assert.areEqual(test1, "100.0%");
		Assert.areEqual(test2, "10.0%");
		Assert.areEqual(test3, "1,000.5%");
	}

	@test
	function stripNonDigits()
	{
		var string1 = "10remhl0";
		var string2 = "10.00$#&%(@*@)+@+,|!05";
		var string3 = "1000.5";

		var test1 = m3.helper.StringFormatHelper.stripNonDigits(string1, false);
		var test2 = m3.helper.StringFormatHelper.stripNonDigits(string2, false);
		var test3 = m3.helper.StringFormatHelper.stripNonDigits(string3, false);

		Assert.areEqual(test1, "100");
		Assert.areEqual(test2, "10.0005");
		Assert.areEqual(test3, "1000.5");
	}

	@test
	function toFormattedNumberTest()
	{
		var string1 = "100";
		var string2 = "10,00005";
		var string3 = "1000.5";

		var options = {
			numberOfDecimals: 3,
	        decimalSeparator: ',',
	        thousandSeparator: '.',
	        symbol: '$',
	        percentage: true,
	        forceNumberOfDecimals: true
		}

		var test1 = m3.helper.StringFormatHelper.toFormattedNumber(string1);
		var test2 = m3.helper.StringFormatHelper.toFormattedNumber(string2);
		var test3 = m3.helper.StringFormatHelper.toFormattedNumber(string3);
		var test4 = m3.helper.StringFormatHelper.toFormattedNumber(string1, options);
		var test5 = m3.helper.StringFormatHelper.toFormattedNumber(string2, options);
		var test6 = m3.helper.StringFormatHelper.toFormattedNumber(string3, options);

		Assert.areEqual(test1, "100");
		Assert.areEqual(test2, "NaN");
		Assert.areEqual(test3, "1,001");
		Assert.areEqual(test4, "100,000%");
		Assert.areEqual(test5, "NaN");
		Assert.areEqual(test6, "1.000,500%");
	}

	@test
	function toFormattedNumberDynTest()
	{
		var string1 = "100";
		var string2 = "10,00005";
		var string3 = "1000.5";

		var test1 = m3.helper.StringFormatHelper.toFormattedNumberDyn(string1);
		var test2 = m3.helper.StringFormatHelper.toFormattedNumberDyn(string2);
		var test3 = m3.helper.StringFormatHelper.toFormattedNumberDyn(string3);

		Assert.areEqual(test1, "100");
		Assert.areEqual(test2, "NaN");
		Assert.areEqual(test3, "1,001");
	}

	@test
	function dateYYYY_MM_DDTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.dateYYYY_MM_DD(date1);
		var test2 = m3.helper.StringFormatHelper.dateYYYY_MM_DD(date2);

		Assert.areEqual(test1, "2000-02-01");
		Assert.areEqual(test2, "2100-12-11");
	}

	@test
	function datePrettyTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.datePretty(date1);
		var test2 = m3.helper.StringFormatHelper.datePretty(date2);

		Assert.areEqual(test1, "Febuary 1, 2000");
		Assert.areEqual(test2, "December 11, 2100");
	}

	@test
	function dateLongPrettyTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.dateLongPretty(date1);
		var test2 = m3.helper.StringFormatHelper.dateLongPretty(date2);

		Assert.areEqual(test1, "Tuesday, Febuary 1, 2000");
		Assert.areEqual(test2, "Saturday, December 11, 2100");
	}

	@test
	function dateTimeMM_DDTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.dateTimeMM_DD(date1);
		var test2 = m3.helper.StringFormatHelper.dateTimeMM_DD(date2);

		Assert.areEqual(test1, "02-01 1:01:01");
		Assert.areEqual(test2, "12-11 11:11:11");
	}

	@test
	function dateTimeYYYY_MM_DDTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.dateTimeYYYY_MM_DD(date1);
		var test2 = m3.helper.StringFormatHelper.dateTimeYYYY_MM_DD(date2);

		Assert.areEqual(test1, "2000-02-01 1:01:01");
		Assert.areEqual(test2, "2100-12-11 11:11:11");
	}

	@test
	function dateTimePrettyTest()
	{
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,11,11,11,11,11);

		var test1 = m3.helper.StringFormatHelper.dateTimePretty(date1);
		var test2 = m3.helper.StringFormatHelper.dateTimePretty(date2);

		Assert.areEqual(test1, "Febuary 1, 2000 1:01:01");
		Assert.areEqual(test2, "December 11, 2100 11:11:11");
	}
}