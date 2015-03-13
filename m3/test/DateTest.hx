package m3.test;

import m3.helper.DateHelper;
import m3.test.Assert;

@:rtti class DateTest {

	@test
	function inThePastTest(){
		//var expected1 = new Date(year: 2000, month: 1, day:1, hour:1, min:1, sec:1);
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);

		var test1 = DateHelper.inThePast(date1);
		var test2 = DateHelper.inThePast(date2);
		var test3 = DateHelper.inThePast(date3);
		var test4 = DateHelper.inThePast(date4);

		Assert.isTrue(test1);
		Assert.isTrue(test3);
		Assert.isFalse(test2);
		Assert.isFalse(test4);
	}

	@test
	function inTheFutureTest(){
		//var expected1 = new Date(year: 2000, month: 1, day:1, hour:1, min:1, sec:1);
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);

		var test1 = DateHelper.inTheFuture(date1);
		var test2 = DateHelper.inTheFuture(date2);
		var test3 = DateHelper.inTheFuture(date3);
		var test4 = DateHelper.inTheFuture(date4);

		Assert.isFalse(test1);
		Assert.isFalse(test3);
		Assert.isTrue(test2);
		Assert.isTrue(test4);
	}

	@test
	function isValidTest(){
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);
		var date5 = new Date(2000,100,1,1,1,1);
		var date6 = null;

		trace(date5);

		var test1 = DateHelper.isValid(date1);
		var test2 = DateHelper.isValid(date2);
		var test3 = DateHelper.isValid(date3);
		var test4 = DateHelper.isValid(date4);
		var test5 = DateHelper.isValid(date5);
		var test6 = DateHelper.isValid(date6);

		Assert.isTrue(test1);
		Assert.isTrue(test2);
		Assert.isTrue(test3);
		Assert.isTrue(test4);
		Assert.isTrue(test5);
		Assert.isFalse(test6);
	}

	@test
	function isBeforeTest(){
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);

		var test1 = DateHelper.isBefore(date1, date2);
		var test2 = DateHelper.isBefore(date2, date1);
		var test3 = DateHelper.isBefore(date3, date4);
		var test4 = DateHelper.isBefore(date4, date3);

		Assert.isTrue(test1);
		Assert.isTrue(test3);
		Assert.isFalse(test2);
		Assert.isFalse(test4);
	}

	@test
	function isAfterTest(){
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);

		var test1 = DateHelper.isAfter(date1, date2);
		var test2 = DateHelper.isAfter(date2, date1);
		var test3 = DateHelper.isAfter(date3, date4);
		var test4 = DateHelper.isAfter(date4, date3);

		Assert.isFalse(test1);
		Assert.isFalse(test3);
		Assert.isTrue(test2);
		Assert.isTrue(test4);
	}

	@test
	function isBeforeTodayTest(){
		var now: Date = Date.now();
		var date1 = new Date(2000,1,1,1,1,1);
		var date2 = new Date(2100,1,1,1,1,1);
		var date3 = new Date(now.getFullYear(), now.getMonth(), now.getDate()-1, 22, 59, 59);
		var date4 = new Date(now.getFullYear(), now.getMonth(), now.getDate()+1, 22, 59, 59);

		var test1 = DateHelper.isBeforeToday(date1);
		var test2 = DateHelper.isBeforeToday(date2);
		var test3 = DateHelper.isBeforeToday(date3);
		var test4 = DateHelper.isBeforeToday(date4);

		Assert.isTrue(test1);
		Assert.isTrue(test3);
		Assert.isFalse(test2);
		Assert.isFalse(test4);
	}
}