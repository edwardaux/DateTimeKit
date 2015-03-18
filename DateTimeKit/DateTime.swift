//
//  DateTime.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - DateTime
/**
A `DateTime` represents a date and time within a specific timezone. For example, 5th July 2012 at 
10:12:16.123 in Sydney, Australia.

It contains enough information to resolve to a specific `Instant` in the datetime continuum, but is more
commonly used to represent a date/time that a user perceives on their wall-clock in a specific timezone.
*/
public struct DateTime {
	private static let UNITS =
		NSCalendarUnit.CalendarUnitYear |
		NSCalendarUnit.CalendarUnitMonth |
		NSCalendarUnit.CalendarUnitDay |
		NSCalendarUnit.CalendarUnitHour |
		NSCalendarUnit.CalendarUnitMinute |
		NSCalendarUnit.CalendarUnitSecond |
		NSCalendarUnit.CalendarUnitNanosecond

	/** The wall-clock date/time component */
	public let dateTime: LocalDateTime
	/** The timezone that the dateTime field is representing */
	public let zone: Zone
	
	public var year:        Int { get { return dateTime.date.year } }
	public var month:       Int { get { return dateTime.date.month } }
	public var day:         Int { get { return dateTime.date.day } }
	public var hour:        Int { get { return dateTime.time.hour } }
	public var minute:      Int { get { return dateTime.time.minute } }
	public var second:      Int { get { return dateTime.time.second } }
	public var millisecond: Int { get { return dateTime.time.millisecond } }

	/**
	Constructs a `DateTime` using the constituent components. Will fail if any of the input components are out of
	bounds (eg. more than 59 seconds)
	
	:param: year The year
	:param: month The month (must be between 1 and 12 inclusive)
	:param: day The day (must be between 1 and the number of days in the passed month)
	:param: hour The hour (must be between 0 and 23 inclusive)
	:param: minute The minute (must be between 0 and 59 inclusive)
	:param: second The second (must be between 0 and 59 inclusive)
	:param: millisecond The hour (must be between 0 and 999 inclusive)
	:param: zone The zone that this date/time is in
	:param: error An error that will be populated if the initialiser fails
	*/
	public init?(_ year: Int, _ month: Int, _ day: Int, _ hour: Int, _ minute: Int, _ second: Int, _ millisecond: Int = 0, _ zone: Zone, _ error: DateTimeErrorPointer = nil) {
		if let dateTime = LocalDateTime(year, month, day, hour, minute, second, millisecond, error) {
			self.init(dateTime, zone)
		}
		else {
			return nil
		}
	}
	
	/**
	Constructs a `DateTime` from an input string and a date format (ie. something that NSDateFormatter can parse). 
	Optionally, a time zone and locale can be passed and will be used to assist parsing.

	:param: input The input date string
	:param: format The NSDateFormatter-compliant date format string
	:param: zone The zone that will be used when parsing (note that if the input date and format contains timezone info, this parameter will be ignored)
	:param: locale The locale that will be used when parsing
	:param: error An error that will be populated if the initialiser fails
	*/
	public init?(input: String, format: String, zone: Zone = Zone.systemDefault(), _ locale: NSLocale = NSLocale.autoupdatingCurrentLocale(), _ error: DateTimeErrorPointer = nil) {
		let dateFormatter = NSDateFormatter()
		dateFormatter.dateFormat = format
		dateFormatter.timeZone = zone.timezone
		dateFormatter.locale = locale
		
		var localError: NSError?
		var date: AnyObject?
		if dateFormatter.getObjectValue(&date, forString: input, range: nil, error: &localError) {
			self.init(Instant(date as! NSDate), zone)
		}
		else {
			if error != nil {
				error.memory = DateTimeError.UnableToParseDate(localError!.localizedDescription)
			}
			return nil
		}
	}
	
	/**
	Constructs a `DateTime` representing the current moment in time in the user's current system clock
	*/
	public init() {
		self.init(SystemClock())
	}
	
	/**
	Constructs a `DateTime` representing the current moment in time using the passed clock
	
	:param: clock The clock that will be used to provide the current instant
	*/
	public init(_ clock: Clock) {
		self.init(LocalDateTime(clock), clock.zone())
	}
	
	/**
	Constructs a `DateTime` from a given instant within a specifed zone.

	:param: instant The instant in the datetime continuum
	:param: zone The zone that is used to determine the wall-clock date and time
	*/
	public init(_ instant: Instant, _ zone: Zone) {
		let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
		calendar.timeZone = zone.timezone
		let components = calendar.components(DateTime.UNITS, fromDate: instant.asNSDate())
		self.init(LocalDateTime(components.year, components.month, components.day, components.hour, components.minute, components.second, components.nanosecond/1_000_000)!, zone)
	}
	
	/**
	Constructs a `DateTime` from a local date/time within a specific zone

	:param: dateTime The local date/time
	:param: zone The zone that the local date/time is representing
	*/
	public init(_ dateTime: LocalDateTime, _ zone: Zone) {
		self.dateTime = dateTime
		self.zone = zone
	}
	
	/**
	Returns an instant representing the specific moment in time for this object
	*/
	public func instant() -> Instant {
		let calendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)!
		let components = NSDateComponents()
		components.year = self.dateTime.date.year
		components.month = self.dateTime.date.month
		components.day = self.dateTime.date.day
		components.hour = self.dateTime.time.hour
		components.minute = self.dateTime.time.minute
		components.second = self.dateTime.time.second
		components.nanosecond = self.dateTime.time.millisecond * 1_000_000
		components.timeZone = self.zone.timezone
		
		// note that we can explicitly unwrap because we know the component inputs were
		// valid inside the dateTime object
		return Instant(calendar.dateFromComponents(components)!)
	}
	
	/**
	Converts this zoned date/time to another date/time in a different zone.
	
	:param: zone The zone to convert the current date/time to
	:returns: A new `DateTime` object that represent this object's date/time in the new zone
	*/
	public func inZone(zone: Zone) -> DateTime {
		let instant = self.instant()
		return DateTime(instant, zone)
	}
	
	/**
	Adds a duration to this date/time and returns a new object representing the new date/time.
	
	If a negative duration is passed, the new date/time will be before the current one.
	
	Also available by the `+` operator.
	
	:param: duration The duration to be added
	:returns: A new `DateTime` that represents the new moment in the datetime continuum
	*/
	public func plus(duration: Duration) -> DateTime {
		return DateTime(instant() + duration, self.zone)
	}
	
	/**
	Subtracts a duration from this date/time and returns a new object representing the new date/time.
	
	If a negative duration is passed, the new date/time will be after the current one.
	
	Also available by the `-` operator.
	
	:param: duration The duration to be subtracted
	:returns: A new `DateTime` that represents the new moment in the datetime continuum
	*/
	public func minus(duration: Duration) -> DateTime {
		return DateTime(instant() - duration, self.zone)
	}

	/**
	Adds a period to this dateTime and returns a new object representing the new dateTime.
	
	Also available by the `+` operator.
	
	:param: period The period to be added
	:returns: A new `DateTime` that represents the new dateTime
	*/
	public func plus(period: Period) -> DateTime {
		return DateTime(LocalDateTime(self.dateTime.date + period, self.dateTime.time), self.zone)
	}
	
	/**
	Subtracts a period from this dateTime and returns a new object representing the new dateTime.
	
	Also available by the `-` operator.
	
	:param: period The period to be subtracted
	:returns: A new `DateTime` that represents the new dateTime
	*/
	public func minus(period: Period) -> DateTime {
		return DateTime(LocalDateTime(self.dateTime.date - period, self.dateTime.time), self.zone)
	}
}

// MARK: - Printable protocol
extension DateTime : Printable {
	public var description: String {
		return "\(self.dateTime.description) - \(self.zone.description)"
	}
}

// MARK: - DebugPrintable protocol
extension DateTime : DebugPrintable {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension DateTime : Comparable {}
public func ==(lhs: DateTime, rhs: DateTime) -> Bool {
	return lhs.dateTime == rhs.dateTime && lhs.zone == rhs.zone
}
public func <(lhs: DateTime, rhs: DateTime) -> Bool {
	return lhs.instant() < rhs.instant()
}

// MARK: - Operators
public func + (lhs: DateTime, rhs: Duration) -> DateTime {
	return lhs.plus(rhs)
}
public func - (lhs: DateTime, rhs: Duration) -> DateTime {
	return lhs.minus(rhs)
}
public func + (lhs: DateTime, rhs: Period) -> DateTime {
	return lhs.plus(rhs)
}
public func - (lhs: DateTime, rhs: Period) -> DateTime {
	return lhs.minus(rhs)
}
