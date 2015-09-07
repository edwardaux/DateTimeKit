//
//  Instant.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - Instant
/**
An Instant is defined as an instant in the datetime continuum and is measured in
the number of seconds since midnight on 1st January 2001. It is totally independent
of any notion of timezones.

An Instant is analagous to `NSDate` from the Cocoa world in that it contains a single
number representing the number of seconds since a defined reference date.
*/
public struct Instant {
	/** The number of seconds since the Core Foundation reference date.  Can be positive or negative. */
	public let secondsSinceReferenceDate: Double
	
	/**
	Constructs a `Instant` by asking the `clock` for its implementation of an instant.
	
	:param clock The clock to use to return an instant. The default clock (`SystemClock`) uses the current system time.
	*/
	public init(_ clock: Clock = SystemClock()) {
		self.init(clock.instant().secondsSinceReferenceDate)
	}
	
	/**
	Constructs a `Instant` using a specific duration since the reference date.
	
	- parameter secondsSinceReferenceDate: The specific number of seconds since the reference date.
	*/
	public init(_ secondsSinceReferenceDate: Double) {
		self.secondsSinceReferenceDate = secondsSinceReferenceDate
	}
	
	/**
	Constructs a `Instant` using a specific duration since the reference date.
	
	- parameter millisSinceReferenceDate: The specific number of milliseconds since the reference date.
	*/
	public init(millisSinceReferenceDate: Double) {
		self.secondsSinceReferenceDate = millisSinceReferenceDate / 1000
	}
	
	/**
	Constructs a `Instant` representing the same moment as contained in an `NSDate` object
	
	- parameter timestamp: The `NSDate` object that represents the moment
	*/
	public init(_ timestamp: NSDate) {
		self.init(timestamp.timeIntervalSinceReferenceDate)
	}
	
	/**
	Compares the current instant on the timeline and returns a `Duration` that represents the
	difference between the two instants. 

	If this instant is more recent than the `other` instant, then the duration will be positive,
	otherwise the duration will be negative.
	
	Also available by the `-` operator.
	
	- parameter other: The instant to be subtracted
	- returns: A duration representing the difference between the two instants
	*/
	public func minus(other: Instant) -> Duration {
		return Duration(self.secondsSinceReferenceDate - other.secondsSinceReferenceDate)
	}

	/**
	Adds a duration to this instant and returns a new object representing the new instant.

	If a negative duration is passed, the new instant will be before the current one.

	Also available by the `+` operator.
	
	- parameter duration: The duration to be added
	- returns: A new instant that represents the new moment in the datetime continuum
	*/
	public func plus(duration: Duration) -> Instant {
		return Instant(self.secondsSinceReferenceDate + duration.seconds)
	}

	/**
	Subtracts a duration from this instant and returns a new object representing the new instant.
	
	If a negative duration is passed, the new instant will be after the current one.
	
	Also available by the `-` operator.
	
	- parameter duration: The duration to be subtracted
	- returns: A new instant that represents the new moment in the datetime continuum
	*/
	public func minus(duration: Duration) -> Instant {
		return Instant(self.secondsSinceReferenceDate - duration.seconds)
	}

	/**
	Constucts an NSDate object that represents the same moment in time as this instant
	*/
	public func asNSDate() -> NSDate {
		return NSDate(timeIntervalSinceReferenceDate: self.secondsSinceReferenceDate)
	}
	
	/**
	Helper function that returns an `Instant` object that represents the current time.
	
	- parameter clock: The clock to ask for the current instant
	- returns: A `Instant` representing the current time
	*/
	public static func now(clock: Clock = SystemClock()) -> Instant {
		return Instant()
	}
}

// MARK: - Printable protocol
extension Instant : CustomStringConvertible {
	public var description: String {
		return "\(self.asNSDate())"
	}
}

// MARK: - DebugPrintable protocol
extension Instant : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension Instant : Comparable {}
public func ==(lhs: Instant, rhs: Instant) -> Bool {
	return lhs.secondsSinceReferenceDate == rhs.secondsSinceReferenceDate
}
public func <(lhs: Instant, rhs: Instant) -> Bool {
	return lhs.secondsSinceReferenceDate < rhs.secondsSinceReferenceDate
}

// MARK: - Operators
public func - (lhs: Instant, rhs: Instant) -> Duration {
	return lhs.minus(rhs)
}
public func + (lhs: Instant, rhs: Duration) -> Instant {
	return lhs.plus(rhs)
}
public func - (lhs: Instant, rhs: Duration) -> Instant {
	return lhs.minus(rhs)
}




