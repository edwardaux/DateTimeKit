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
		DTAssertEqual(LocalDate(1910, 10, 10)! + 3.days + 5.hours, 1910, 10, 13)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 23.hours, 1911, 10, 10)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 24.hours, 1911, 10, 11)
		DTAssertEqual(LocalDate(1911, 10, 10)! + 25.hours, 1911, 10, 11)

		// now for some leap year checking
		DTAssertEqual(LocalDate(2016, 2, 27)! + 47.hours, 2016, 2, 28)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 48.hours, 2016, 2, 29)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 49.hours, 2016, 2, 29)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 72.hours, 2016, 3, 1)
		DTAssertEqual(LocalDate(2016, 2, 27)! + 73.hours, 2016, 3, 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 47.hours, 2015, 2, 28)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 48.hours, 2015, 3, 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 49.hours, 2015, 3, 1)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 72.hours, 2015, 3, 2)
		DTAssertEqual(LocalDate(2015, 2, 27)! + 73.hours, 2015, 3, 2)

		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 3.days + 5.hours, 15, 0, 0, 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 0.hours, 10, 0, 0, 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 2.days, 10, 0, 0, 0)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 800.milliseconds, 10, 0, 0, 800)
		DTAssertEqual(LocalTime(10, 0, 0, 0)! + 1500.milliseconds, 10, 0, 1, 500)

		// ticking over a year
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 0.seconds, 2011, 12, 31, 23, 59, 59, 0)
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 1.seconds, 2012, 1, 1, 0, 0, 0, 0)
		DTAssertEqual(DateTime(2011, 12, 31, 23, 59, 59, 0, Zone.gmt())! + 2.seconds, 2012, 1, 1, 0, 0, 1, 0)

		// a leap second was added on Jun 30 2012. Confirm that we pretend it doesn't exit
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 0.seconds, 2012, 6, 30, 23, 59, 59, 0)
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 1.seconds, 2012, 7, 1, 0, 0, 0, 0)
		DTAssertEqual(DateTime(2012, 6, 30, 23, 59, 59, 0, Zone.gmt())! + 2.seconds, 2012, 7, 1, 0, 0, 1, 0)
	}
	
	func testPeriod() {
		XCTAssertEqual(Period(1, 2, 3), Period(1, 2, 3))
		XCTAssertEqual(Period(1, 2, 3).description, "1 year, 2 months, 3 days")
		XCTAssertEqual(Period(-1, 0, -3).description, "-1 year, -3 days")
		XCTAssertEqual(Period(0, 0, 0).description, "empty period")
		
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 0, 0), 1912, 10, 10)
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 1, 2), 1912, 11, 12)
		DTAssertEqual(LocalDate(1911, 10, 10)! + Period(1, 0, 0), 1912, 10, 10)
		DTAssertEqual(LocalDate(2011,  2, 26)! + Period(0, 0, 4), 2011,  3,  2)
		DTAssertEqual(LocalDate(2012,  2, 26)! + Period(0, 0, 4), 2012,  3,  1)
		
	}
}
