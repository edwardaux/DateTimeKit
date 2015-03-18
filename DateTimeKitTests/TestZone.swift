//
//  TestZone.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation
import XCTest
import DateTimeKit

class TestZone: XCTestCase {
	
	func testBasics() {
		Zone.gmt()
		XCTAssertTrue(Zone.gmt().zoneIdentifier() == "Z")
		XCTAssertTrue(Zone.utc().zoneIdentifier() == "Z")
		XCTAssertTrue(Zone(NSTimeZone(name: "GMT")!) == Zone.gmt())
		XCTAssertTrue(Zone(NSTimeZone(forSecondsFromGMT: 0)) == Zone.gmt())
	}
	
	func testParseZone() {
		DTAssertNotNil(Zone("Z"))
		DTAssertNotNil(Zone("+00:00"))
		DTAssertNotNil(Zone("-00:00"))
		DTAssertNotNil(Zone("+01:30"))
		DTAssertNotNil(Zone("-01:30"))
		DTAssertNotNil(Zone("+16:10"))
		DTAssertNotNil(Zone("-16:10"))
		DTAssertNotNil(Zone("+16:10:15"))
		DTAssertNotNil(Zone("-16:10:15"))
		DTAssertNotNil(Zone("+16:10:45"))
		DTAssertNotNil(Zone("-16:10:45"))
		DTAssertNotNil(Zone("+04:04:00"))
		DTAssertNotNil(Zone("+00:00:00"))
		DTAssertNotNil(Zone("-00:00:00"))
		DTAssertNotNil(Zone("GMT"))
		DTAssertNotNil(Zone("Australia/Sydney"))
		DTAssertNotNil(Zone("Europe/Paris"))
		DTAssertNotNil(Zone("EST"))
		DTAssertNotNil(Zone("CDT"))

		DTAssertNil(Zone(""))
		DTAssertNil(Zone("hello"))
		DTAssertNil(Zone("00:00"))
		DTAssertNil(Zone("12:34:56:12"))
		DTAssertNil(Zone("+23:10"))
		DTAssertNil(Zone("04:-1"))
		DTAssertNil(Zone("06:87"))
		DTAssertNil(Zone("06:10:95"))
		DTAssertNil(Zone("25:00"))
		DTAssertNil(Zone("+aa:bb"))

		var error: DateTimeError? = nil
		DTAssertNil(Zone("+aa:bb", &error))
		if let e = error {
			switch(error!) {
			case .MalformedZoneIdentifier(let technicalReason):
				XCTAssertEqual(technicalReason, "Invalid input: \"+aa:bb\". Zone identifier is not in expected format")
				break;
			default:
				XCTFail("Unexpected error: \(error)")
			}
		}
		else {
			XCTFail("Error was nil")
		}
	}
	
	func testzoneIdentifier() {
		XCTAssertEqual(Zone("Z")!.zoneIdentifier(), "Z")
		XCTAssertEqual(Zone("+00:00")!.zoneIdentifier(), "Z")
		XCTAssertEqual(Zone("-00:00")!.zoneIdentifier(), "Z")
		XCTAssertEqual(Zone("+01:30")!.zoneIdentifier(), "+01:30")
		XCTAssertEqual(Zone("-01:30")!.zoneIdentifier(), "-01:30")
		XCTAssertEqual(Zone("+16:10")!.zoneIdentifier(), "+16:10")
		XCTAssertEqual(Zone("-16:10")!.zoneIdentifier(), "-16:10")
		XCTAssertEqual(Zone("+16:10:05")!.zoneIdentifier(), "+16:10:05")
		XCTAssertEqual(Zone("-16:10:05")!.zoneIdentifier(), "-16:10:05")
		XCTAssertEqual(Zone("+16:10:45")!.zoneIdentifier(), "+16:10:45")
		XCTAssertEqual(Zone("-16:10:45")!.zoneIdentifier(), "-16:10:45")
		XCTAssertEqual(Zone("+04:04:00")!.zoneIdentifier(), "+04:04")
		XCTAssertEqual(Zone("+00:00:00")!.zoneIdentifier(), "Z")
		XCTAssertEqual(Zone("-00:00:00")!.zoneIdentifier(), "Z")
	}
	
	func testDisplayName() {
		let z1 = Zone("+16:10")!
		XCTAssertEqual(z1.displayName(NSLocale(localeIdentifier: "en_AU")), "GMT+16:10")
		XCTAssertEqual(z1.displayName(NSLocale(localeIdentifier: "fr_FR")), "UTC+16:10")
		let z2 = Zone("+10:00")!
		XCTAssertEqual(z2.displayName(NSLocale(localeIdentifier: "en_AU")), "GMT+10:00")
		XCTAssertEqual(z2.displayName(NSLocale(localeIdentifier: "fr_FR")), "UTC+10:00")
		let z3 = Zone(NSTimeZone(name: "Australia/Sydney")!)
		XCTAssertEqual(z3.displayName(NSLocale(localeIdentifier: "en_AU")), "Australian Eastern Standard Time")
		XCTAssertEqual(z3.displayName(NSLocale(localeIdentifier: "fr_FR")), "heure normale de l’Est de l’Australie")
		let z4 = Zone.gmt()
		XCTAssertEqual(z4.displayName(NSLocale(localeIdentifier: "en_AU")), "GMT")
		XCTAssertEqual(z4.displayName(NSLocale(localeIdentifier: "fr_FR")), "UTC")
		let z5 = Zone.utc()
		XCTAssertEqual(z5.displayName(NSLocale(localeIdentifier: "en_AU")), "GMT")
		XCTAssertEqual(z5.displayName(NSLocale(localeIdentifier: "fr_FR")), "UTC")
	}

}