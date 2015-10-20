//
//  LocalDateTime.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - LocalDateTime
public struct LocalDateTime {
	public let date: LocalDate
	public let time: LocalTime

	public var year:        Int { get { return date.year } }
	public var month:       Int { get { return date.month } }
	public var day:         Int { get { return date.day } }
	public var hour:        Int { get { return time.hour } }
	public var minute:      Int { get { return time.minute } }
	public var second:      Int { get { return time.second } }
	public var millisecond: Int { get { return time.millisecond } }
	
	/**
	Constructs a `DateTime` using the constituent components. Will fail if any of the input components are out of
	bounds (eg. more than 59 seconds)
	
	- parameter year: The year
	- parameter month: The month (must be between 1 and 12 inclusive)
	- parameter day: The day (must be between 1 and the number of days in the passed month)
	- parameter hour: The hour (must be between 0 and 23 inclusive)
	- parameter minute: The minute (must be between 0 and 59 inclusive)
	- parameter second: The second (must be between 0 and 59 inclusive)
	- parameter millisecond: The hour (must be between 0 and 999 inclusive)
	- parameter zone: The zone that this date/time is in
	- parameter error: An error that will be populated if the initialiser fails
	*/
	public init?(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Int, _ millisecond: Int = 0, _ error: DateTimeErrorPointer = nil) {
		if let date = LocalDate(year, month, day, error), time = LocalTime(hour, minute, second, millisecond, error) {
			self.init(date, time)
		}
		else {
			return nil
		}
	}
	
	/**
	Constructs a `LocalDateTime` from an input string and a date format (ie. something that NSDateFormatter can parse).
	Optionally, a time zone and locale can be passed and will be used to assist parsing.
	
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
			self.init(LocalDate(Instant(date), zone), LocalTime(Instant(date), zone))
		}
		else {
			return nil
		}
	}

	/**
	Constructs a `LocalDateTime` representing the current moment in time in the user's current system clock
	*/
	public init() {
		self.init(SystemClock())
	}
	
	/**
	Constructs a `LocalDateTime` representing the current moment in time using the passed clock
	
	- parameter clock: The clock that will be used to provide the current instant
	*/
	public init(_ clock: Clock) {
		self.init(LocalDate(clock), LocalTime(clock))
	}

	/**
	Constructs a `LocalDateTime` using the passed `LocalDate` and `LocalTime` components

	- parameter date: The local date
	- parameter time: The local time
	*/
	public init(_ date: LocalDate, _ time: LocalTime) {
		self.date = date
		self.time = time
	}
	
	/**
	Adds a duration to this date/time and returns a new object representing the new date/time.
	
	If a negative duration is passed, the new date/time will be before the current one.
	
	Also available by the `+` operator.
	
	- parameter duration: The duration to be added
	- returns: A new `LocalDateTime` that represents the new local time
	*/
	public func plus(duration: Duration) -> LocalDateTime {
		let zonedDateTime = DateTime(self.year, self.month, self.day, self.hour, self.minute, self.second, self.millisecond, Zone.utc())!
		let newDateTime = zonedDateTime + duration
		let newInstant = newDateTime.instant()
		return LocalDateTime(LocalDate(newInstant, Zone.utc()), LocalTime(newInstant, Zone.utc()))
	}
	
	/**
	Subtracts a duration from this date/time and returns a new object representing the new date/time.
	
	If a negative duration is passed, the new date/time will be after the current one.
	
	Also available by the `-` operator.
	
	- parameter duration: The duration to be subtracted
	- returns: A new `LocalDateTime` that represents the new local time
	*/
	public func minus(duration: Duration) -> LocalDateTime {
		let zonedDateTime = DateTime(self.year, self.month, self.day, self.hour, self.minute, self.second, self.millisecond, Zone.utc())!
		let newDateTime = zonedDateTime - duration
		let newInstant = newDateTime.instant()
		return LocalDateTime(LocalDate(newInstant, Zone.utc()), LocalTime(newInstant, Zone.utc()))
	}
}

// MARK: - Printable protocol
extension LocalDateTime : CustomStringConvertible {
	public var description: String {
		return "\(date.description) \(time.description)"
	}
}

// MARK: - DebugPrintable protocol
extension LocalDateTime : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension LocalDateTime : Comparable {}
public func ==(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
	return lhs.date == rhs.date && lhs.time == rhs.time
}
public func <(lhs: LocalDateTime, rhs: LocalDateTime) -> Bool {
	// we have to assume that both local date/times are in the same timezone
	// so we convert them to a zoned date and time and compare the them
	let zone = Zone.utc()
	return DateTime(lhs, zone) < DateTime(rhs, zone)
}

// MARK: - Operators
public func + (lhs: LocalDateTime, rhs: Duration) -> LocalDateTime {
	return lhs.plus(rhs)
}
public func - (lhs: LocalDateTime, rhs: Duration) -> LocalDateTime {
	return lhs.minus(rhs)
}
