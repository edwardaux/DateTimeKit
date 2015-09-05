//
//  Year.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - Year
/**
A very simple structure to facilitate leap year calculations
*/
public struct Year {
	let year: Int
	
	/**
	Constructs a `Year` from the passed value.

	- parameter The: year value. Can be negative.
	*/
	public init(_ year: Int) {
		self.year = year
	}

	/**
	Returns whether this year is a leap year
	- returns: A boolean indicating whether this year is a leap year
	*/
	public func isLeap() -> Bool {
		return ((year & 3) == 0) && ((year % 100) != 0 || (year % 400) == 0)
	}
	
	/**
	Returns the number of days in this year
	- returns: The number of days in this year
	*/
	public func numberOfDays() -> Int {
		return self.isLeap() ? 366 : 365
	}
}

// MARK: - Printable protocol
extension Year : CustomStringConvertible {
	public var description: String {
		return "\(self.year)"
	}
}

// MARK: - DebugPrintable protocol
extension Year : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Equatable protocol
extension Year : Equatable {}
public func ==(lhs: Year, rhs: Year) -> Bool {
	return lhs.year == rhs.year
}
