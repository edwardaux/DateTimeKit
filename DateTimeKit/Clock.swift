//
//  Clock.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - Clock
/**
A `Clock` is particularly useful for creating instances of `Instant` when testing. In your shipping
app, you would most likely only ever use `SystemClock`, however, in your testing suite you can provide 
a different type of `Clock` that returns custom values. For example, `FixedClock` always returns the
same `Instant` every time it is called.

Note that you don't have to use a `Clock`. You can just call `Instant()` or `LocalDateTime()` and 
the default system clock will be used. However, testing your app will be easier if you use `Instant(clock)` 
or `LocalDateTime(clock)` where `clock` has been set using some form of Dependency Injection.
*/
public protocol Clock {
	/**
	Returns an instant as defined by this clock.
	*/
	func instant() -> Instant
	
	/**
	Returns the timezone as defined by this clock. This is not used when calling `Instant(clock)`,
	however it is important when using `LocalDate(clock)`, `LocalTime(clock)` and `LocalDateTime(clock)`.
	*/
	func zone() -> Zone
}

// MARK: - SystemClock
/**
A `SystemClock` uses the current system time to generate new instants. If no clock is provided to the
constructor for `Instant`, the system clock will be used.
*/
public struct SystemClock : Clock {
	let internalZone: Zone
	
	/**
	Constructs a new `SystemClock` using a particular timezone

	- parameter zone: The timezone that will be used. Defaults to the current user's timezone if not specified
	*/
	public init(_ zone: Zone = Zone()) {
		self.internalZone = zone
	}
	
	public func zone() -> Zone {
		return self.internalZone
	}
	public func instant() -> Instant {
		return Instant(NSDate())
	}
}

// MARK: - FixedClock
/**
A `FixedClock` always returns exactly the same `Instant`. It is unlikely to ever be used in a shipping
app, but could be useful for test cases and mocking data.
*/
public struct FixedClock : Clock {
	let internalZone: Zone
	let internalInstant: Instant
	
	/**
	Constructs a new `FixedClock` using a particular timezone
	
	- parameter zone: The timezone that will be used.
	*/
	public init(_ instant: Instant, _ zone: Zone) {
		self.internalInstant = instant
		self.internalZone = zone
	}
	
	public func zone() -> Zone {
		return self.internalZone
	}
	public func instant() -> Instant {
		return self.internalInstant
	}
}

// MARK: - Printable protocol
extension SystemClock : CustomStringConvertible {
	public var description: String {
		return "\(self.internalZone)"
	}
}
extension FixedClock : CustomStringConvertible {
	public var description: String {
		return "\(self.internalZone) \(self.internalInstant)"
	}
}

// MARK: - DebugPrintable protocol
extension SystemClock : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}
extension FixedClock : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Equatable protocol
extension SystemClock : Equatable {}
public func ==(lhs: SystemClock, rhs: SystemClock) -> Bool {
	return lhs.internalZone == rhs.internalZone
}
extension FixedClock : Equatable {}
public func ==(lhs: FixedClock, rhs: FixedClock) -> Bool {
	return lhs.internalZone == rhs.internalZone && lhs.internalInstant == rhs.internalInstant
}
