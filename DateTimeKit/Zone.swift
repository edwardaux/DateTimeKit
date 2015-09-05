//
//  Zone.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

// MARK: - Zone
/**
A `Zone` represents a temporal offset, plus or minus, from GMT. In contract to `NSTimeZone`, this
class supports a temporal offset to the second.

A `Zone` can be created using a pre-existing `NSTimeZone` instance, or by passing a "identifier" 
that will be parsed to create the `Zone`. See the `init(zoneIdentifier: String)` constructor for
more details on the supported formats.
*/
public struct Zone {
	/** The underlying timezone for this zone */
	let timezone: NSTimeZone
	/** Additional precision to support timezones that are accurate to the second. Can be negative. */
	let secondsFudge: Int
	
	/**
	Constructs a `Zone` using the passed `NSTimeZone` instance

	- parameter timezone: The timezone to use. Defaults to the system default timezone
	*/
	public init(_ timezone: NSTimeZone = NSTimeZone.defaultTimeZone()) {
		// because we're using a passed timezone, we can set the secondsFudge to zero
		self.init(timezone, 0)
	}

	/**
	Constructs a `Zone` object based on an identifier.  

	The supported formats for a zone identifier are:

	* `Z` - Represents GMT timezone
	* `+hh:mm` - A positive offset from GMT (minute precision)
	* `-hh:mm` - A negative offset from GMT (minute precision)
	* `+hh:mm:ss` -  A positive offset from GMT (second precision)
	* `-hh:mm:ss` -  A negative offset from GMT (minute precision)
	* `XXX/YYY` - An `NSTimeZone` ID. For example, `Europe/Paris` or `Australia/Sydney`
	* `XXX` - An `NSTimeZone` abbreviation. For example, `EST` or `CDT`

	- parameter zoneIdentifier: The zone identifier to parse
	- parameter error: An error that will be populated if the initialiser fails
	- returns: A `Zone` object if a timezone is able to be determined using the passed identifier, nil otherwise.
	*/
	public init?(_ zoneIdentifier: String, _ error: DateTimeErrorPointer = nil) {
		if let (timezone, secondsFudge) = Zone.convertIdentifierTimeZone(zoneIdentifier, error) {
			self.init(timezone, secondsFudge)
		}
		else {
			return nil
		}
	}
	
	private init(_ timezone: NSTimeZone, _ secondsFudge: Int) {
		self.timezone = timezone
		self.secondsFudge = secondsFudge
	}
	
	// MARK: Convenience constructors
	/** Returns a `Zone` representing the system's current timezone */
	public static func systemDefault() -> Zone {
		return Zone(NSTimeZone.systemTimeZone())
	}
	/** Returns a `Zone` representing GMT timezone */
	public static func gmt() -> Zone {
		return Zone(NSTimeZone(abbreviation: "GMT")!)
	}
	/** Returns a `Zone` representing UTC timezone */
	public static func utc() -> Zone {
		return Zone(NSTimeZone(abbreviation: "UTC")!)
	}
	
	/**
	Takes a zoneIdentifier and parses it into an NSTimeZone plus an addition number of seconds.

	- parameter zoneIdentifier: The zone identifier to parse
	- parameter error: An error pointer that will be populated in case parsing fails
	- returns: An optional tuple where the first element is a NSTimeZone and the second element is the additional precision. Returns nil if unable to parse.
	*/
	private static func convertIdentifierTimeZone(zoneIdentifier: String, _ error: DateTimeErrorPointer) -> (NSTimeZone, Int)? {
		// must be at least one character long
		if zoneIdentifier.characters.count == 0 {
			if error != nil {
				error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\". Zone identifier cannot be blank")
			}
			return nil
		}
		
		// if it is a "Z" then that is UTC
		let firstChar = zoneIdentifier[zoneIdentifier.startIndex]
		if firstChar == "Z" {
			return (NSTimeZone(abbreviation: "UTC")!, 0)
		}
		
		if let tz = NSTimeZone(name: zoneIdentifier) {
			return (tz, 0)
		}
		else if let tz = NSTimeZone(abbreviation: zoneIdentifier) {
			return (tz, 0)
		}
		else if firstChar == "+" || firstChar == "-" {
			// split it up ignoring punctuation. 1st component should be hours, 2nd should be minutes
			// and 3rd might be seconds
			var components = zoneIdentifier.characters.split { ":+-".characters.contains($0) }.map { String($0) }
			let componentCount = components.count
			if componentCount != 2 && componentCount != 3 {
				if error != nil {
					error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\(zoneIdentifier)\". Zone identifier format must be one of +yy:mm, -yy:mm, +yy:mm:ss, or -yy:mm:ss")
				}
				return nil
			}
			
			// make sure there is a seconds component as it makes pulling the components
			// out easier below
			if componentCount == 2 {
				components.append("0")
			}
			
			if let hh = Int(components[0]), mm = Int(components[1]), ss = Int(components[2]) {
				if hh < -18 || hh > 18 {
					if error != nil {
						error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\(hh)\". Zone identifier hours must be between -18 and +18 (inclusive)")
					}
					return nil
				}
				if mm < 0 || mm > 59 {
					if error != nil {
						error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\(mm)\". Zone identifier minutes must be between 0 and 59 (inclusive)")
					}
					return nil
				}
				if ss < 0 || ss > 59 {
					if error != nil {
						error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\(ss)\". Zone identifier seconds must be between 0 and 59 (inclusive)")
					}
					return nil
				}
				let seconds = (hh * Duration.SecondsPerHour + mm * Duration.MinutesPerHour + ss) * (firstChar == "-" ? -1 : 1)
				
				// NSTimeZone, although purporting to support "secondsFromGMT", really only appears
				// to support "minutesFromGMT". Any extra seconds that you pass seem to get thrown away.
				// For example, consider the following code that set timezone to 1 hour and 15 secs:
				//
				//     let tz = NSTimeZone(forSecondsFromGMT: 3615)
				//     let secs = tz.secondsFromGMT
				//
				// At this point, secs in the above example only contains 3600. The other 15
				// seconds have just been silently discarded. Nice.
				//
				// Anyway, to workaround this oddity, we keep track of the difference between what we
				// pass NSTimeZone and what it reports as being saved and squirrel it away for later use
				let tz = NSTimeZone(forSecondsFromGMT: seconds)
				let fudge = seconds - tz.secondsFromGMT
				return (tz, fudge)
			}
		}

		if error != nil {
			error.memory = DateTimeError.MalformedZoneIdentifier("Invalid input: \"\(zoneIdentifier)\". Zone identifier is not in expected format")
		}
		return nil
	}
	
	// MARK: Instance methods
	/** 
	Returns a human readable description of this zone. By default it tries to use the underlying 
	`NSTimeZone`'s description, however, if there is additional precision then it will use the 
	`zoneIdentifier()` output instead.
	
	- parameter locale: The locale with which to output the name of the zone. Defaults to user's current locale.
	- returns: A description of the zone
	*/
	public func displayName(locale: NSLocale = NSLocale.autoupdatingCurrentLocale()) -> String {
		if self.secondsFudge == 0 {
			return self.timezone.localizedName(.Standard, locale: locale) ?? "Unknown"
		}
		else {
			return self.zoneIdentifier()
		}
	}
	
	/**
	Returns a deterministic representation of this zone in hours/minutes/seconds. Note that the seconds
	component is only included if there are non-zero seconds.  

	The expected output will be one of the following formats:

	* `Z`
	* `+hh:mm`
	* `-hh:mm`
	* `+hh:mm:ss`
	* `-hh:mm:ss`

	- returns: An identifier for this zone
	*/
	public func zoneIdentifier() -> String {
		let secondsFromGMT = self.timezone.secondsFromGMT + self.secondsFudge
		if secondsFromGMT == 0 {
			return "Z"
		}
		else {
			let absoluteSecondsFromGMT = abs(secondsFromGMT)
			let absoluteHours = absoluteSecondsFromGMT / Duration.SecondsPerHour
			let absoluteMinutes = (absoluteSecondsFromGMT / Duration.SecondsPerMinute) % Duration.MinutesPerHour
			let absoluteSeconds = (absoluteSecondsFromGMT % Duration.SecondsPerMinute)
			let sign = secondsFromGMT < 0 ? "-" : "+"
			if absoluteSeconds == 0 {
				return String(format: "%@%02d:%02d", sign, absoluteHours, absoluteMinutes)
			}
			else {
				return String(format: "%@%02d:%02d:%02d", sign, absoluteHours, absoluteMinutes, absoluteSeconds)
			}
		}
	}
}

// MARK: - Printable protocol
extension Zone : CustomStringConvertible {
	public var description: String {
		return self.timezone.description
	}
}

// MARK: - DebugPrintable protocol
extension Zone : CustomDebugStringConvertible {
	public var debugDescription: String {
		return self.description
	}
}

// MARK: - Equatable protocol
extension Zone : Equatable {}
public func ==(lhs: Zone, rhs: Zone) -> Bool {
	return lhs.timezone == rhs.timezone
}
