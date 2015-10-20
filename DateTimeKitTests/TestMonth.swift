//
//  TestMonth.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestMonth: XCTestCase {
	
	func testMonthName() {
		let m = Month.January
		XCTAssertEqual(m.displayName(NSLocale(localeIdentifier: "en_AU")), "January")
		XCTAssertEqual(m.displayName(NSLocale(localeIdentifier: "fr_FR")), "janvier")
	}

	func testArithmetic() {
		XCTAssertEqual(Month.January.plus(1),   Month.February)
		XCTAssertEqual(Month.January.plus(2),   Month.March)
		XCTAssertEqual(Month.January.plus(8),   Month.September)
		XCTAssertEqual(Month.January.plus(11),  Month.December)
		XCTAssertEqual(Month.January.plus(12),  Month.January)
		XCTAssertEqual(Month.January.plus(13),  Month.February)
		XCTAssertEqual(Month.January.plus(24),  Month.January)
		XCTAssertEqual(Month.January.plus(27),  Month.April)
		XCTAssertEqual(Month.January.plus(0),   Month.January)
		XCTAssertEqual(Month.January.plus(-1),  Month.December)
		XCTAssertEqual(Month.January.plus(-13), Month.December)
		XCTAssertEqual(Month.January.plus(-15), Month.October)
		XCTAssertEqual(Month.January.plus(-95), Month.February)

		XCTAssertEqual(Month.January.minus(1),   Month.December)
		XCTAssertEqual(Month.January.minus(2),   Month.November)
		XCTAssertEqual(Month.January.minus(8),   Month.May)
		XCTAssertEqual(Month.January.minus(11),  Month.February)
		XCTAssertEqual(Month.January.minus(12),  Month.January)
		XCTAssertEqual(Month.January.minus(13),  Month.December)
		XCTAssertEqual(Month.January.minus(24),  Month.January)
		XCTAssertEqual(Month.January.minus(27),  Month.October)
		XCTAssertEqual(Month.January.minus(0),   Month.January)
		XCTAssertEqual(Month.January.minus(-1),  Month.February)
		XCTAssertEqual(Month.January.minus(-13), Month.February)
		XCTAssertEqual(Month.January.minus(-15), Month.April)
		XCTAssertEqual(Month.January.minus(-95), Month.December)
	}
}
