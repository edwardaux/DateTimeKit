//
//  TestLocalDate.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestLocalDate: XCTestCase {
	
	func testConstructors() {
		DTAssertEqual(LocalDate(2000, 10, 10)!, year: 2000, month: 10, day: 10)
		DTAssertEqual(LocalDate(2000, 2, 28)!, year: 2000, month: 2, day: 28)
		DTAssertEqual(LocalDate(1996, 2, 29)!, year: 1996, month: 2, day: 29)
		DTAssertEqual(LocalDate(0, 1, 1)!, year: 0, month: 1, day: 1)
		DTAssertEqual(LocalDate(-5, 1, 1)!, year: -5, month: 1, day: 1)
		DTAssertEqual(LocalDate(input:"2012-12-25", format:"yyyy-MM-dd")!, year: 2012, month: 12, day: 25)
		DTAssertEqual(LocalDate(input:"2012-12-25 12:34:56", format:"yyyy-MM-dd HH:mm:ss")!, year: 2012, month: 12, day: 25)
		DTAssertEqual(LocalDate(input:"2012-12-25 12:34:56.789", format:"yyyy-MM-dd HH:mm:ss.SSS")!, year: 2012, month: 12, day: 25)
		// FIX: EXC_BAD_INS
		//DTAssertEqual(LocalDate(input:"2012-12-25 12:34:56.789+0:00", format:"yyyy-MM-dd HH:mm:ss.SSSZZZ")!, year: 2012, month: 12, day: 25)
		// FIX: Assert fail NOT EQUAL
		//DTAssertEqual(LocalDate(input:"2012-12-25 12:34:56.789+10:00", format:"yyyy-MM-dd HH:mm:ss.SSSZZZ")!, year: 2012, month: 12, day: 25)

		DTAssertNil(LocalDate(2000, -5, 10))
		DTAssertNil(LocalDate(2000, 54, 29))
		DTAssertNil(LocalDate(2000, 12, 75))
		DTAssertNil(LocalDate(1900, 2, 29))
		DTAssertNotNil(LocalDate(2000, 2, 29))
		DTAssertNil(LocalDate(input:"2012-12-25 12:34:56", format:"yyyy-MM-dd"))
		DTAssertNil(LocalDate(input:"2012-12-25 12:34:56.789+10:00", format:"yyyy-MM-dd HH:mm:ss.SSS"))
		DTAssertNil(LocalDate(input:"2012-25-25", format:"yyyy-MM-dd"))

		DTAssertEqual(LocalTime(10, 11, 12)!, hour: 10, minute: 11, second: 12, millisecond: 0)
		DTAssertEqual(LocalTime(10, 11, 12, 13)!, hour: 10, minute: 11, second: 12, millisecond: 13)
		DTAssertEqual(LocalTime(23, 59, 59, 999)!, hour: 23, minute: 59, second: 59, millisecond: 999)
		DTAssertEqual(LocalTime(0, 0, 0, 0)!, hour: 0, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(LocalTime.midnight(), hour: 0, minute: 0, second: 0, millisecond: 0)
		
		DTAssertNil(LocalTime(1, -5, 10))
		DTAssertNil(LocalTime(25, 54, 29))
		DTAssertNil(LocalTime(-5, 12, 0))
		DTAssertNil(LocalTime(2, 2, 87))
		DTAssertNil(LocalTime(1, 1, 1, 999_999))
		DTAssertEqual(LocalTime(input:"12:34:56", format:"HH:mm:ss")!, hour: 12, minute: 34, second: 56, millisecond: 0)
		DTAssertEqual(LocalTime(input:"2012-12-25 12:34:56", format:"yyyy-MM-dd HH:mm:ss")!, hour: 12, minute: 34, second: 56, millisecond: 0)
		// note that the input time data has a timezone component. this will quite happily resolve
		// to an instant on the datetime continuum, however, the conversion into a LocalTime object
		// uses the passed zone to determine what the specific components were in that zone.  The 
		// constructor for LocalTime takes a Zone (but defaults it to the system zone), so the
		// success/failure of this test would depend on the zone of the user running the test. To
		// make it more deterministic, we specifically pass a zone
		DTAssertEqual(LocalTime(input:"2012-12-25 12:34:56.789+10:00", format:"yyyy-MM-dd HH:mm:ss.SSSZZZ", zone:Zone("+03:00")!)!, hour: 5, minute: 34, second: 56, millisecond: 789)
		
		DTAssertEqual(LocalDateTime(2000, 12, 25, 12, 34, 56, 78)!, year: 2000, month: 12, day: 25, hour: 12, minute: 34, second: 56, millisecond: 78)
		XCTAssertEqual(LocalDateTime(2000, 12, 25, 12, 34, 56, 78)!.date, LocalDate(2000, 12, 25)!)
		XCTAssertEqual(LocalDateTime(2000, 12, 25, 12, 34, 56, 78)!.time, LocalTime(12, 34, 56, 78)!)
		DTAssertEqual(LocalDateTime(input:"2012-12-25", format:"yyyy-MM-dd")!, year: 2012, month: 12, day: 25, hour: 0, minute: 0, second: 0, millisecond: 0)
		DTAssertEqual(LocalDateTime(input:"2012-12-25 12:34:56", format:"yyyy-MM-dd HH:mm:ss")!, year: 2012, month: 12, day: 25, hour: 12, minute: 34, second: 56, millisecond: 0)
		// see comments about about passing input containing timezone info
		DTAssertEqual(LocalDateTime(input:"2012-12-25 12:34:56.789+10:00", format:"yyyy-MM-dd HH:mm:ss.SSSZZZ", zone:Zone("+03:00")!)!, year: 2012, month: 12, day: 25, hour: 5, minute: 34, second: 56, millisecond: 789)
		// same instant as previous one, but in a different time zone
		DTAssertEqual(LocalDateTime(input:"2012-12-25 10:34:56.789+08:00", format:"yyyy-MM-dd HH:mm:ss.SSSZZZ", zone:Zone("+03:00")!)!, year: 2012, month: 12, day: 25, hour: 5, minute: 34, second: 56, millisecond: 789)
	}
	
	func testDescription() {
		XCTAssertEqual(LocalDate(2000, 5, 6)!.description, "2000-05-06")
		XCTAssertEqual(LocalDate(0, 1, 1)!.description, "0-01-01")
		XCTAssertEqual(LocalDate(200, 10, 10)!.description, "200-10-10")
		XCTAssertEqual(LocalDate(-200, 6, 29)!.description, "-200-06-29")

		XCTAssertEqual(LocalTime(10, 11, 12)!.description, "10:11:12")
		XCTAssertEqual(LocalTime(10, 11, 12, 13)!.description, "10:11:12.13")
		XCTAssertEqual(LocalTime(23, 59, 59, 999)!.description, "23:59:59.999")
		XCTAssertEqual(LocalTime(0, 0, 0, 0)!.description, "00:00:00")
	}
	
	func testRezoning() {
		let sydneyZone = Zone(NSTimeZone(name:"Australia/Sydney")!)
		let parisZone = Zone(NSTimeZone(name:"Europe/Paris")!)
		
		let sydneyTime = DateTime(2012, 12, 25, 12, 34, 56, 0, sydneyZone)!
		let parisTime = sydneyTime.inZone(parisZone)

		DTAssertEqual(sydneyTime.dateTime, year: 2012, month: 12, day: 25, hour: 12, minute: 34, second: 56, millisecond: 0)
		DTAssertEqual(parisTime.dateTime,  year: 2012, month: 12, day: 25, hour: 02, minute: 34, second: 56, millisecond: 0)
	}
	
	func testComparable() {
		let utc = Zone.utc()
		XCTAssertEqual(      DateTime(2012, 12, 25, 9, 0, 0, 0, utc)!, DateTime(2012, 12, 25, 9, 0, 0, 0, utc)!)
		XCTAssertGreaterThan(DateTime(2012, 12, 25, 9, 1, 0, 0, utc)!, DateTime(2012, 12, 25, 9, 0, 0, 0, utc)!)
		XCTAssertGreaterThan(DateTime(2012, 12, 25, 9, 1, 0, 0, utc)!, DateTime(2011, 12, 26, 9, 5, 0, 0, utc)!)
		XCTAssertGreaterThan(DateTime(2012,  1,  1, 0, 0, 0, 0, utc)!, DateTime(2011, 12, 31, 23, 59, 59, 999, utc)!)
	}
}
