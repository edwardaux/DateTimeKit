//
//  LocalTime.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - LocalTime
public struct LocalTime {

	public let hour: Int
	public let minute: Int
	public let second: Int
	public let millisecond: Int
	
	/**
	Constructs a `LocalTime` using the constituent components. Will fail if any of the input components are out of
	bounds (eg. more than 59 seconds)
	
	- parameter hour: The hour (must be between 0 and 23 inclusive)
	- parameter minute: The minute (must be between 0 and 59 inclusive)
	- parameter second: The second (must be between 0 and 59 inclusive)
	- parameter millisecond: The hour (must be between 0 and 999 inclusive)
	- parameter error: An error that will be populated if the initialiser fails
	*/
	public init?(_ hour: Int, _ minute: Int, _ second: Int = 0, _ millisecond: Int = 0, _ error: DateTimeErrorPointer = nil) {
		if hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59 && second >= 0 && second <= 59 && millisecond >= 0 && millisecond <= 999 {
			self.hour = hour
			self.minute = minute
			self.second = second
			self.millisecond = millisecond
		}
		else {
			return nil
		}
	}
	
	/**
	Constructs a `LocalTime` from an input string and a time format (ie. something that NSDateFormatter can parse).
	Optionally, a time zone and locale can be passed and will be used to assist parsing.
	
	**Important:** Any date components in the input string will be discarded
	
	- parameter input: The input time string
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
	Constructs a `LocalTime` representing the current time in the user's current system clock
	*/
	public init() {
		self.init(SystemClock())
	}
	
	/**
	Constructs a `LocalTime` representing the current time in the passed clock
	
	- parameter clock: The clock that will be used to provide the current instant
	*/
	public init(_ clock: Clock) {
		self.init(clock.instant(), clock.zone())
	}
	
	/**
	Constructs a `LocalTime` from a given instant within a specifed zone.
	
	- parameter instant: The instant in the datetime continuum
	- parameter zone: The zone that is used to determine the wall-clock time
	*/
	public init(_ instant: Instant, _ zone: Zone) {
		let zonedDateTime = DateTime(instant, zone)
		
		self.hour = zonedDateTime.hour
		self.minute = zonedDateTime.minute
		self.second = zonedDateTime.second
		self.millisecond = zonedDateTime.millisecond
	}
	
	/**
	Adds a duration to this time and returns a new object representing the new time. Note that durations that
	that cause the time to wrap past midnight may result in a time that is technically less than the original. 
	For example, adding a duration of 1 hour to 23:30:00 will result in 00:30:00.
	
	If a negative duration is passed, the new time may be before the current one (notwithstanding the wrapping rules
	described above).
	
	Also available by the `+` operator.
	
	- parameter duration: The duration to be added
	- returns: A new `LocalTime` that represents the new time
	*/
	public func plus(duration: Duration) -> LocalTime {
		let zonedDateTime = DateTime(2001, 1, 1, self.hour, self.minute, self.second, self.millisecond, Zone.utc())!
		let newDateTime = zonedDateTime + duration
		return LocalTime(newDateTime.instant(), Zone.utc())
	}
	
	/**
	Subtracts a duration from this time and returns a new object representing the new time. Note that durations that
	that cause the time to wrap past midnight may result in a time that is technically greater than the original.
	For example, subtracting a duration of 1 hour from 00:30:00 will result in 23:30:00.
	
	If a negative duration is passed, the new time may be after the current one (notwithstanding the wrapping rules
	described above).
	
	Also available by the `-` operator.
	
	- parameter duration: The duration to be subtracted
	- returns: A new `LocalTime` that represents the new time
	*/
	public func minus(duration: Duration) -> LocalTime {
		let zonedDateTime = DateTime(2001, 1, 1, self.hour, self.minute, self.second, self.millisecond, Zone.utc())!
		let newDateTime = zonedDateTime - duration
		return LocalTime(newDateTime.instant(), Zone.utc())
	}

	/**
	Helper function that returns a local time representing midnight
	- returns: A new `LocalTime` with a time of `00:00:00.000`
	*/
	public static func midnight() -> LocalTime {
		return LocalTime(0, 0, 0, 0)!
	}
}

// MARK: - Printable protocol
extension LocalTime : CustomStringConvertible {
	public var description: String {
		if self.millisecond == 0 {
			return String(format: "%02d:%02d:%02d", self.hour, self.minute, self.second)
		}
		else {
			return String(format: "%02d:%02d:%02d.%d", self.hour, self.minute, self.second, self.millisecond)
		}
	}
}

// MARK: - DebugPrintable protocol
extension LocalTime : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension LocalTime : Comparable {}
public func ==(lhs: LocalTime, rhs: LocalTime) -> Bool {
	return lhs.hour == rhs.hour && lhs.minute == rhs.minute && lhs.second == rhs.second && lhs.millisecond == rhs.millisecond
}
public func <(lhs: LocalTime, rhs: LocalTime) -> Bool {
	var diff = lhs.hour - rhs.hour
	if diff == 0 {
		diff = lhs.minute - rhs.minute
		if (diff == 0) {
			diff = lhs.second - rhs.second
			if (diff == 0) {
				diff = lhs.millisecond - rhs.millisecond
			}
		}
	}
	return diff < 0
}

// MARK: - Operators
public func + (lhs: LocalTime, rhs: Duration) -> LocalTime {
	return lhs.plus(rhs)
}
public func - (lhs: LocalTime, rhs: Duration) -> LocalTime {
	return lhs.minus(rhs)
}
