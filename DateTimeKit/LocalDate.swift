//
//  LocalDate.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - LocalDate
/**
A `LocalDate` represents a date with no time component and no specific timezone. It is often used to
represent things like birthdays.  It cannot be used to represent an instant in the date/time continuum
as it lacks both time and timezone components.
*/
public struct LocalDate {

	public let year: Int
	public let month: Int
	public let day: Int
	
	/**
	Constructs a `LocalDate` using the constituent components. Will fail if any of the input components are out of
	bounds (eg. more than 13 months)
	
	- parameter year: The year
	- parameter month: The month (must be between 1 and 12 inclusive)
	- parameter day: The day (must be between 1 and the number of days in the passed month)
	- parameter error: An error that will be populated if the initialiser fails
	*/
	public init?(_ year: Int, _ month: Int, _ day: Int, _ error: DateTimeErrorPointer = nil) {
		if let m = Month(rawValue: month) where day <= m.numberOfDays(year) {
			self.year = year
			self.month = month
			self.day = day
		}
		else {
			return nil
		}
	}
	
	/**
	Constructs a `LocalDate` from an input string and a date format (ie. something that NSDateFormatter can parse).
	Optionally, a time zone and locale can be passed and will be used to assist parsing.  
	
	**Important:** Any time components in the input string will be discarded
	
	- parameter input: The input date string
	- parameter format: The NSDateFormatter-compliant date format string
	- parameter zone: The zone that will be used when parsing (note that if the input date and format contains timezone info, this parameter will be ignored)
	- parameter locale: The locale that will be used when parsing
	- parameter error: An error that will be populated if the initialiser fails
	*/
	public init?(input: String, format: String, zone: Zone = Zone.systemDefault(), locale: NSLocale = NSLocale.autoupdatingCurrentLocale(), _ error: DateTimeErrorPointer = nil) {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = zone.timezone
		dateFormatter.locale = locale
		if let date = dateFormatter.dateFromString(input) {
			self.init(Instant(date), zone)
		}
		else {
			return nil
		}
	}
	
	/**
	Constructs a `LocalDate` representing the current date in the user's current system clock
	*/
	public init() {
		self.init(SystemClock())
	}
	
	/**
	Constructs a `LocalDate` representing the current date in the passed clock
	
	- parameter clock: The clock that will be used to provide the current instant
	*/
	public init(_ clock: Clock) {
		self.init(clock.instant(), clock.zone())
	}
	
	/**
	Constructs a `LocalDate` from a given instant within a specifed zone.
	
	- parameter instant: The instant in the datetime continuum
	- parameter zone: The zone that is used to determine the wall-clock date
	*/
	public init(_ instant: Instant, _ zone: Zone) {
		let zonedDateTime = DateTime(instant, zone)

		self.year = zonedDateTime.year
		self.month = zonedDateTime.month
		self.day = zonedDateTime.day
	}
	
	/**
	Adds a duration to this date and returns a new object representing the new date. Note that durations of
	less than a day won't be enough to advance the date forward. Likewise, passing a duration of, say, 1.5 days
	will still only advance the date by 1 day.
	
	If a negative duration is passed, the new date may be before the current one.
	
	Also available by the `+` operator.
	
	- parameter duration: The duration to be added
	- returns: A new `LocalDate` that represents the new date
	*/
	public func plus(duration: Duration) -> LocalDate {
		let zonedDateTime = DateTime(self.year, self.month, self.day, 0, 0, 0, 0, Zone.utc())!
		let newDateTime = zonedDateTime + duration
		return LocalDate(newDateTime.instant(), Zone.utc())
	}
	
	/**
	Subtracts a duration from this date and returns a new object representing the new date. Note that durations of
	less than a day won't be enough to step the date backward. Likewise, passing a duration of, say, 1.5 days
	will still only step the date backward by 1 day.
	
	If a negative duration is passed, the new date may be after the current one.
	
	Also available by the `-` operator.
	
	- parameter duration: The duration to be subtracted
	- returns: A new `LocalDate` that represents the new date
	*/
	public func minus(duration: Duration) -> LocalDate {
		let zonedDateTime = DateTime(self.year, self.month, self.day, 0, 0, 0, 0, Zone.utc())!
		let newDateTime = zonedDateTime - duration
		return LocalDate(newDateTime.instant(), Zone.utc())
	}

	/**
	Adds a period to this date and returns a new object representing the new date.
	
	Also available by the `+` operator.
	
	- parameter period: The period to be added
	- returns: A new `LocalDate` that represents the new date
	*/
	public func plus(period: Period) -> LocalDate {
		// get current date
		let zonedDateTime = DateTime(self.year, self.month, self.day, 0, 0, 0, 0, Zone.utc())!
		let currentNSDate = zonedDateTime.instant().asNSDate()
		
		// now add the required values to current date
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let components = NSDateComponents()
		components.year = period.years
		components.month = period.months
		components.day = period.days
		let modifiedDate = calendar.dateByAddingComponents(components, toDate: currentNSDate, options: [])!
		
		// convert back to local date
		return LocalDate(Instant(modifiedDate), Zone.utc())
	}
	
	/**
	Subtracts a period from this date and returns a new object representing the new date.
	
	Also available by the `-` operator.
	
	- parameter period: The period to be subtracted
	- returns: A new `LocalDate` that represents the new date
	*/
	public func minus(period: Period) -> LocalDate {
		// get current date
		let zonedDateTime = DateTime(self.year, self.month, self.day, 0, 0, 0, 0, Zone.utc())!
		let currentNSDate = zonedDateTime.instant().asNSDate()
		
		// now add the required values to current date
		let calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
		let components = NSDateComponents()
		components.year = -period.years
		components.month = -period.months
		components.day = -period.days
		let modifiedDate = calendar.dateByAddingComponents(components, toDate: currentNSDate, options: [])!
		
		// convert back to local date
		return LocalDate(Instant(modifiedDate), Zone.utc())
	}
	
}

// MARK: - Printable protocol
extension LocalDate : CustomStringConvertible {
	public var description: String {
		return String(format: "%d-%02d-%02d", self.year, self.month, self.day)
	}
}

// MARK: - DebugPrintable protocol
extension LocalDate : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension LocalDate : Comparable {}
public func ==(lhs: LocalDate, rhs: LocalDate) -> Bool {
	return lhs.year == rhs.year && lhs.month == rhs.month && lhs.day == rhs.day
}
public func <(lhs: LocalDate, rhs: LocalDate) -> Bool {
	var diff = lhs.year - rhs.year
	if diff == 0 {
		diff = lhs.month - rhs.month
		if (diff == 0) {
			diff = lhs.day - rhs.day
		}
	}
	return diff < 0
}

// MARK: - Operators
public func + (lhs: LocalDate, rhs: Duration) -> LocalDate {
	return lhs.plus(rhs)
}
public func - (lhs: LocalDate, rhs: Duration) -> LocalDate {
	return lhs.minus(rhs)
}
public func + (lhs: LocalDate, rhs: Period) -> LocalDate {
	return lhs.plus(rhs)
}
public func - (lhs: LocalDate, rhs: Period) -> LocalDate {
	return lhs.minus(rhs)
}

