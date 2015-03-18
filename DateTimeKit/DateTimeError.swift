//
//  DateTimeError.swift
//  DateTimeKit
//
//  Created by Craig Edwards
//  Copyright (c) 2015 Craig Edwards. All rights reserved.
//

import Foundation

/**
A `DateTimeErrorPointer` is a means by which callers can get back an error
enum value when calling failable date/time initialisers
*/
public typealias DateTimeErrorPointer = UnsafeMutablePointer<DateTimeError?>

/**
Represents the list of known errors that can occur when initialising various date/time 
structures.

The `String` associated value for each is a technical reason why the error occurred. It
is unlikely that the text of this reason is suitable for presenting to the user, however,
it would be very useful for logging/debugging.
*/
public enum DateTimeError {
	case MalformedZoneIdentifier(String)
	case UnableToParseDate(String)
}