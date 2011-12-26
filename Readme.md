# FKDaylightCalculator

*FKDaylightCalculator* is a small and easy to use class for your iOS and Mac OS X projects to calculate sunrise and sunset dates.

*FKDaylightCalculator* is based on the algorithm described [here](http://williams.best.vwh.net/sunrise_sunset_algorithm.htm).

# Installation

Simply drag *FKDaylightCalculator.h* and *FKDaylightCalculator.m* into your Xcode project and you're done. Make sure to link to the *CoreLocation* framework, because *FKDaylightCalculator* uses *CLLocationCoordinate2D*.

# Example

If you want to calculate the time of sunrise at *location*, you do the following:

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

# FAQ

If you have any questions regarding this project, feel free to contact me.

Kind regards,
Fabian




