//
//  Period.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - Period
/**
An Period is an broad period of time that is not able to be specific as an exact number of 
seconds. For example, 5 years, 2 months and 4 days.
*/
public struct Period {
	/** The number of years for this period. Can be negative. */
	public let years: Int
	/** The number of months for this period. Can be more than 12 and/or negative. */
	public let months: Int
	/** The number of days for this period. Can be more than 31 and/or negative. */
	public let days: Int
	
	/**
	Constructs a `Period` by asking the `clock` for its implementation of an instant.
	
	:param clock The clock to use to return an instant. The default clock (`SystemClock`) uses the current system time.
	*/
	public init(_ years: Int, _ months: Int, _ days: Int) {
		self.years = years
		self.months = months
		self.days = days
	}
	
	/**
	Adds another period to this period and returns a new object representing the new period.
	
	Also available by the `+` operator.
	
	- parameter period: The period to be added
	- returns: A new period that represents the addition of the two periods
	*/
	public func plus(period: Period) -> Period {
		return Period(self.years + period.years, self.months + period.months, self.days + period.days)
	}
	
	/**
	Subtracts another period from this period and returns a new object representing the new period.
	
	Also available by the `-` operator.
	
	- parameter period: The period to be subtracted
	- returns: A new period that represents the subtraction of the two periods
	*/
	public func minus(period: Period) -> Period {
		return Period(self.years - period.years, self.months - period.months, self.days - period.days)
	}
}

// MARK: - Printable protocol
extension Period : CustomStringConvertible {
	public var description: String {
		if self == Period(0,0,0) {
			return "empty period"
		}
		var components = [String]()
		if self.years != 0 {
			let noun = self.pluralise("year", self.years)
			components.append("\(self.years) \(noun)")
		}
		if self.months != 0 {
			let noun = self.pluralise("month", self.months)
			components.append("\(self.months) \(noun)")
		}
		if self.days != 0 {
			let noun = self.pluralise("day", self.days)
			components.append("\(self.days) \(noun)")
		}
		return components.joinWithSeparator(", ")
	}
	func pluralise(base: String, _ i: Int) -> String {
		return i == 1 || i == -1 ? base : base+"s"
	}
}

// MARK: - DebugPrintable protocol
extension Period : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Equatable protocol
// Note that we can't implement Comparable because we can't tell if "1 year,2 months" is greater
// than or less than "14 months" because it depends on which the date the period is applied to
extension Period : Equatable {}
public func ==(lhs: Period, rhs: Period) -> Bool {
	return lhs.years == rhs.years && lhs.months == rhs.months && lhs.days == rhs.days
}

// MARK: - Operators
public func + (lhs: Period, rhs: Period) -> Period {
	return lhs.plus(rhs)
}
public func - (lhs: Period, rhs: Period) -> Period {
	return lhs.minus(rhs)
}




