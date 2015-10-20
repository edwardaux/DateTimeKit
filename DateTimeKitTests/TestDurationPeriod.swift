//
//  TestDuration.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestDuration: XCTestCase {

	func testInstantDifference() {
		let d1 = Duration(123)
		XCTAssertEqual(d1.seconds, 123)
		
		let i1 = Instant(123)
		let i2 = Instant(456)
		
		let diff = i2.minus(i1)
		XCTAssertEqual(diff.seconds, 333)
		let diff2 = i1.minus(i2)
		XCTAssertEqual(diff2.seconds, -333)
	}
	
	func testArithmetic() {
		DTAssertEqual(LocalDate(1910, 10, 10)! + 3.days + 5.hours, year: 1910, month: 10, day: 13)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 23.hours, year: 1911, month: 10, day: 10)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 24.hours, year: 1911, month: 10, day: 11)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 25.hours, year: 1911, month: 10, day: 11)

		// now for some leap year checking
		DTAssertEqual(LocalDate(2016, 2, 27)! + 47.hours, year: 2016, month: 2, day: 28)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 48.hours, year: 2016, month: 2, day: 29)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 49.hours, year: 2016, month: 2, day: 29)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 72.hours, year: 2016, month: 3, day: 1)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 73.hours, year: 2016, month: 3, day: 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 47.hours, year: 2015, month: 2, day: 28)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 48.hours, year: 2015, month: 3, day: 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 49.hours, year: 2015, month: 3, day: 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 72.hours, year: 2015, month: 3, day: 2)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 73.hours, year: 2015, month: 3, day: 2)

		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 3.days + 5.hours, hour: 15, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 0.hours, hour: 10, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 2.days, hour: 10, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 800.milliseconds, hour: 10, minute: 0, second: 0, millisecond: 800)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 1500.milliseconds, hour: 10, minute: 0, second: 1, millisecond: 500)

		// ticking over a year
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 0.seconds, year: 2011, month: 12, day: 31, hour: 23, minute: 59, second: 59, millisecond: 0)
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 1.seconds, year: 2012, month: 1, day: 1, hour: 0, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 2.seconds, year: 2012, month: 1, day: 1, hour: 0, minute: 0, second: 1, millisecond: 0)

		// a leap second was added on Jun 30 2012. Confirm that we pretend it doesn't exit
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 0.seconds, year: 2012, month: 6, day: 30, hour: 23, minute: 59, second: 59, millisecond: 0)
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 1.seconds, year: 2012, month: 7, day: 1, hour: 0, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 2.seconds, year: 2012, month: 7, day: 1, hour: 0, minute: 0, second: 1, millisecond: 0)
	}
	
	func testPeriod() {
		XCTAssertEqual(Period(1, 2, 3), Period(1, 2, 3))
		XCTAssertEqual(Period(1, 2, 3).description, "1 year, 2 months, 3 days")
		XCTAssertEqual(Period(-1, 0, -3).description, "-1 year, -3 days")
		XCTAssertEqual(Period(0, 0, 0).description, "empty period")
		
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 0, 0), year: 1912, month: 10, day: 10)
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 1, 2), year: 1912, month: 11, day: 12)
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 0, 0), year: 1912, month: 10, day: 10)
		DTAssertEqual(LocalDate(2011,  2, 26)! + Period(0, 0, 4), year: 2011, month: 3, day: 2)
		DTAssertEqual(LocalDate(2012,  2, 26)! + Period(0, 0, 4), year: 2012, month: 3, day: 1)
		
	}
}
