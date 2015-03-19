# DateTimeKit Overview
DateTimeKit is a Swift library that provides simple, easy-to-use date, time and timezone manipulation.  The ideas behind DateTimeKit are quite heavily influenced by the JodaTime library.

DateTimeKit removes the dependence on `NSDate` and `NSCalendar` and provides a new set of objects in their place. 

## Instant
An instant represents a moment on the datetime continuum. Under the covers, just like `NSDate`, it represents the number of milliseconds since the *reference date (1st Jan 2001)*.  It is totally independent of timezone.

```
let now = Instant()
println(now.description)   // 2015-03-18 05:13:43 +0000
```

## Zone
A zone is a representation of a specific timezone. It can be constructed using a timezone abbreviation, name or an absolute number of hours/minutes/seconds.

```
let sydneyZone = Zone("Australia/Sydney")!
let utcZone    = Zone.utc()
let randomZone = Zone("-12:46")!
```

## DateTime
A `DateTime` object is a combination of a specific `instant` and `zone`, and is generally what people perceive as a date and time based on their wall-clock in their specific time zone.

```
let now = Instant()

let sydneyZone = Zone("Australia/Sydney")!
let parisZone  = Zone("Europe/Paris")!

let sydneyTime = DateTime(now, sydneyZone)
println(sydneyTime)       // 2015-03-06 19:02:28.662 - Australia/Sydney (GMT+11) offset 39600 (Daylight)

let parisTime = sydneyTime.inZone(parisZone)
println(parisTime)        // 2015-03-06 09:02:28.662 - Europe/Paris (GMT+1) offset 3600
```

## Duration
A duration is a explicit length of time that can be measured in seconds (or part thereof). For example, 2 hours can be represented as 7200 seconds.

```
// current time in user's default timezone
let now = DateTime()
println(now)          // 2015-03-18 16:20:24.157 - Australia/Sydney (GMT+11) offset 39600 (Daylight)

let dt1 = now + Duration(7200)
println(dt1)          // 2015-03-18 18:20:24.157 - Australia/Sydney (GMT+11) offset 39600 (Daylight)"

let dt2 = now + 2.hours
println(dt2)          // 2015-03-18 18:20:24.157 - Australia/Sydney (GMT+11) offset 39600 (Daylight)"
```

## Period
A period is a conceptual length of time that may vary slightly depending on which date it is applied to. For example, the specific length of “2 months and 2 days” varies depending on what month it is being applied to.

```
// current time in user's default timezone
let now = DateTime()
println(now)          // 2015-03-18 16:28:07.845 - Australia/Sydney (GMT+11) offset 39600 (Daylight)

let dt1 = now + Period(0, 2, 2)
println(dt1)          // 2015-05-20 16:28:07.845 - Australia/Sydney (GMT+11) offset 39600 (Daylight)
```

# Installation

## Copy and Paste
The simplest, but not necessarily best, way to install DateTimeKit is perform the following steps:

* Clone or checkout the project from github into a folder somewhere
* Drag `DateTimeKit.xcodeproj` from the Finder into your project
* Add `DateTimeKit.framework` to your target’s *Linked Frameworks and Libraries* (be sure to pick the correct iOS or OS X framework depending on what sort of app you are writing)
* Rebuild your project

## Cocoapods
Still to come

## Carthage
Still to come

# Feedback
Feel free to ask questions, raise issues or create pull requests. More than happy to receive feedback on new features or how I might have done things better.

I’m contactable via [twitter](http://www.twitter.com/edwardaux) or [email](mailto:craig@blackdogfoundry.com).

