# FKDaylightCalculator

*FKDaylightCalculator* is a small and easy to use class for your iOS and Mac OS X projects (*obersving of daylight changes doesn't work on Mac OS X without modification*) to calculate sunrise and sunset dates.

The algorithm used is described [here](http://williams.best.vwh.net/sunrise_sunset_algorithm.htm).

# Installation

Simply drag *FKDaylightCalculator.h* and *FKDaylightCalculator.m* into your Xcode project and you're done. Make sure to link to the *CoreLocation* framework, because *FKDaylightCalculator* uses *CLLocationCoordinate2D*.

# Example

If you want to calculate the time of sunrise at a specific location, you do the following:

    CLLocation *location;
    FKDaylightCalculator *daylightCalculator = [FKDaylightCalculator daylightCalculatorWithCoordinate:location.coordinate];
    NSDate *sunriseDate = [daylightCalculator todaysSunrise];

You can also check whether the sun is currently shining or not and adjust your interface accordingly:

    FKDaylightCalculator *daylightCalculator = [FKDaylightCalculator daylightCalculatorWithCoordinate:location.coordinate];
    BOOL sunIsShining = [daylightCalculator isSunVisible];

    if (sunIsShining) {
        …
    }
    else {
        …
    }

As a nice addition you can also track daylight changes easily using a block-based API:

    CLLocation *location;
    NSUInteger tag = [FKDaylightCalculator addObserverForDaylightChangesWithBlock:^(NSUInteger tag, BOOL isSunVisible) {
        ...
    } atCoordinate:location.coordinate];


# FAQ

* Q: Why does the project use ARC?
  > A: Because ARC is the future.

Kind regards,
Fabian