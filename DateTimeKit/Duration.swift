//
//  Duration.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

/**
A duration is a period of time that can unequivocably be measured in seconds (or fractions thereof). 

For example, 2 hours can easily be expressed as a `Duration`. However, 2 months *cannot* as there is 
no common definition of the length of a month (ie. it could be 28, 29, 30 or 31 days).  If you want to
represent these more general temporal concepts, you can use a `Period` object instead.

Note, a duration (like `NSDate` before it) conveniently pretends that leap seconds don't exist.
*/
// MARK: - Duration
public struct Duration {

	public static let HoursPerDay      = 24
	public static let DaysPerWeek      = 7
	public static let MinutesPerHour   = 60
	public static let MinutesPerDay    = MinutesPerHour   * HoursPerDay
	public static let SecondsPerMinute = 60
	public static let SecondsPerHour   = SecondsPerMinute * MinutesPerHour
	public static let SecondsPerDay    = SecondsPerHour   * HoursPerDay
	public static let MillisPerDay     = SecondsPerDay    * 1_000
	public static let MicrosPerDay     = SecondsPerDay    * 1_000_000
	public static let NanosPerSecond   = 1_000_000_000
	public static let NanosPerMinute   = NanosPerSecond   * SecondsPerMinute
	public static let NanosPerHour     = NanosPerMinute   * MinutesPerHour
	public static let NanosPerDay      = NanosPerHour     * HoursPerDay

	/** The length of this duation in seconds. */
	public let seconds: Double
	
	/**
	Constructs a `Duration` of a specified length
	
	- parameter seconds: The length of the duration. Can be negative or positive.
	*/
	public init(_ seconds: Double) {
		self.seconds = seconds
	}
	
	/**
	Constructs a `Duration` of a specified length
	
	- parameter seconds: The length of the duration. Can be negative or positive.
	*/
	public init(_ seconds: Int) {
		self.init(Double(seconds))
	}

	/**
	Constructs a `Duration` that represents the difference between two instants.

	- parameter startInstant: The starting instant
	- parameter endInstant: The ending instant
	*/
	public init(_ startInstant: Instant, _ endInstant: Instant) {
		self.init(endInstant.minus(startInstant).seconds)
	}

	/**
	Adds another duration to this duration and returns a new object representing the new duration.
	
	If a negative duration is passed, the new duration will be shorter than the current one.
	
	Also available by the `+` operator.
	
	- parameter duration: The duration to be added
	- returns: A new duration that includes the passed duration
	*/
	public func plus(duration: Duration) -> Duration {
		return Duration(self.seconds + duration.seconds)
	}
	
	/**
	Subtracts another duration from this duration and returns a new object representing the new duration.
	
	If a negative duration is passed, the new duration will be longer than the current one.
	
	Also available by the `+` operator.
	
	- parameter duration: The duration to be subtracted
	- returns: A new duration that includes the passed duration
	*/
	public func minus(duration: Duration) -> Duration {
		return Duration(self.seconds - duration.seconds)
	}
}

// MARK: - Printable protocol
extension Duration : CustomStringConvertible {
	public var description: String {
		return "\(self.seconds) seconds"
	}
}

// MARK: - DebugPrintable protocol
extension Duration : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Comparable protocol
extension Duration : Comparable {}
public func ==(lhs: Duration, rhs: Duration) -> Bool {
	return lhs.seconds == rhs.seconds
}
public func <(lhs: Duration, rhs: Duration) -> Bool {
	return lhs.seconds < rhs.seconds
}

// MARK: - Operators
public func + (lhs: Duration, rhs: Duration) -> Duration {
	return lhs.plus(rhs)
}
public func - (lhs: Duration, rhs: Duration) -> Duration {
	return lhs.minus(rhs)
}

// MARK: - Int and Double extensions
public extension Int {
	var milliseconds: Duration {
		return Duration(Double(self) / 1000.0)
	}
	
	var seconds: Duration {
		return Duration(self)
	}
	
	var minutes: Duration {
		return Duration(self * Duration.SecondsPerMinute)
	}
	
	var hours: Duration {
		return Duration(self * Duration.SecondsPerHour)
	}
	
	var days: Duration {
		return Duration(self * Duration.SecondsPerDay)
	}

	var weeks: Duration {
		return Duration(self * Duration.SecondsPerDay * Duration.DaysPerWeek)
	}
}
public extension Double {
	var milliseconds: Duration {
		return Duration(self / 1000.0)
	}
	
	var seconds: Duration {
		return Duration(self)
	}
	
	var minutes: Duration {
		return Duration(self * Double(Duration.SecondsPerMinute))
	}
	
	var hours: Duration {
		return Duration(self * Double(Duration.SecondsPerHour))
	}
	
	var days: Duration {
		return Duration(self * Double(Duration.SecondsPerDay))
	}
	
	var weeks: Duration {
		return Duration(self * Double(Duration.SecondsPerDay * Duration.DaysPerWeek))
	}
}

