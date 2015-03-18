//
//  TestYear.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestYear: XCTestCase {
	
	func testBasics() {
		XCTAssertFalse(Year(1900).isLeap())
		XCTAssertFalse(Year(1998).isLeap())
		XCTAssertFalse(Year(1999).isLeap())
		XCTAssertTrue(Year(2000).isLeap())
		XCTAssertFalse(Year(2001).isLeap())
		XCTAssertFalse(Year(2002).isLeap())
		XCTAssertFalse(Year(2003).isLeap())
		XCTAssertTrue(Year(2004).isLeap())
		XCTAssertFalse(Year(2005).isLeap())
	}
}