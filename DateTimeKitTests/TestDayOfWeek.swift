//
//  TestDayOfWeek.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestDayOfWeek: XCTestCase {
	
	func testDayOfWeekName() {
		let d = DayOfWeek.Friday
		XCTAssertEqual(d.displayName(locale: NSLocale(localeIdentifier: "en_AU")), "Friday")
		XCTAssertEqual(d.displayName(locale: NSLocale(localeIdentifier: "fr_FR")), "samedi")
	}
	
	func testArithmetic() {
		XCTAssertEqual(DayOfWeek.Monday.plus(1),   DayOfWeek.Tuesday)
		XCTAssertEqual(DayOfWeek.Monday.plus(2),   DayOfWeek.Wednesday)
		XCTAssertEqual(DayOfWeek.Monday.plus(8),   DayOfWeek.Tuesday)
		XCTAssertEqual(DayOfWeek.Monday.plus(11),  DayOfWeek.Friday)
		XCTAssertEqual(DayOfWeek.Monday.plus(12),  DayOfWeek.Saturday)
		XCTAssertEqual(DayOfWeek.Monday.plus(13),  DayOfWeek.Sunday)
		XCTAssertEqual(DayOfWeek.Monday.plus(24),  DayOfWeek.Thursday)
		XCTAssertEqual(DayOfWeek.Monday.plus(0),   DayOfWeek.Monday)
		XCTAssertEqual(DayOfWeek.Monday.plus(-1),  DayOfWeek.Sunday)
		XCTAssertEqual(DayOfWeek.Monday.plus(-13), DayOfWeek.Tuesday)
		XCTAssertEqual(DayOfWeek.Monday.plus(-15), DayOfWeek.Sunday)
		
		XCTAssertEqual(DayOfWeek.Monday.minus(1),   DayOfWeek.Sunday)
		XCTAssertEqual(DayOfWeek.Monday.minus(2),   DayOfWeek.Saturday)
		XCTAssertEqual(DayOfWeek.Monday.minus(8),   DayOfWeek.Sunday)
		XCTAssertEqual(DayOfWeek.Monday.minus(11),  DayOfWeek.Thursday)
		XCTAssertEqual(DayOfWeek.Monday.minus(12),  DayOfWeek.Wednesday)
		XCTAssertEqual(DayOfWeek.Monday.minus(0),   DayOfWeek.Monday)
		XCTAssertEqual(DayOfWeek.Monday.minus(-1),  DayOfWeek.Tuesday)
		XCTAssertEqual(DayOfWeek.Monday.minus(-13), DayOfWeek.Sunday)
		XCTAssertEqual(DayOfWeek.Monday.minus(-15), DayOfWeek.Tuesday)
	}
}
