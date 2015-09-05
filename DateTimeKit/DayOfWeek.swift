//
//  DayOfWeek.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - DayOfWeek
/**
A simple enumeration to represent the day of the week.
*/
public enum DayOfWeek : Int {
	case Monday = 1, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday
	
	/**
	Returns the name of the day given a specific locale. For example, for the `Friday` enum value, 
	the en_AU locale would return "Friday" and fr_FR would return "samedi"

	- parameter The: locale to use. Defaults to user's current locale.
	- returns: The locale-specific representation of the day's name
	*/
	public func displayName(locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> String {
		// note that we add 2 to the rawValue because the start of the ICU 
		// week is Sunday, not Monday.
		let formatter = NSDateFormatter()
		formatter.locale = locale
		formatter.dateFormat = "e"
		let date = formatter.dateFromString("\(self.rawValue+1)")
		formatter.dateFormat = "EEEE"
		return formatter.stringFromDate(date!)
	}
	
	/**
	Adds a number of days to the current day and returns the new day.

	- parameter The: number of days to add. May be negative, in which case it will be subtracted
	- returns: The new day
	*/
	public func plus(days: Int) -> DayOfWeek {
		// * Moving forward 3 days is the same as 10 days and 17 days, so we modulo 7
		//   to get the smallest number of equivalent days
		// * Moving backwards by 3 days is the same as going forward by 4 days, so we add
		//   7 to cater for negative numbers
		// * Ordinarily we could just add this value to the current day's rawValue and modulo
		//   7 to get the new day. However, modulo results in 0-based calcs and because our
		//   days are 1-based we need to subtract one before doing the modulo, do the modulo,
		//   and then add it back in. A bit tedious, but there you are.
		let normalized = days % 7
		return DayOfWeek(rawValue: ((self.rawValue + normalized + 7 - 1) % 7) + 1)!
	}
	
	/**
	Subtracts a number of days from the current day and returns the new day.
	
	- parameter The: number of days to subtract. May be negative, in which case it will be added
	- returns: The new day
	*/
	public func minus(days: Int) -> DayOfWeek {
		return plus(-(days % 7))
	}
}

// MARK: - Printable protocol
extension DayOfWeek : CustomStringConvertible {
	public var description: String {
		return self.displayName()
	}
}

// MARK: - DebugPrintable protocol
extension DayOfWeek : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Equatable protocol
extension DayOfWeek : Equatable {}
public func ==(lhs: DayOfWeek, rhs: DayOfWeek) -> Bool {
	return lhs.rawValue == rhs.rawValue
}

// MARK: - Operators
public func +(lhs: DayOfWeek, rhs: Int) -> DayOfWeek {
	return lhs.plus(rhs)
}
public func -(lhs: DayOfWeek, rhs: Int) -> DayOfWeek {
	return lhs.minus(rhs)
}

