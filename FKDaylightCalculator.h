//
//  FKDaylightCalculator.h
//  Daylight
//
//  Created by Fabian Kreiser on 11.11.11.
//  Copyright 2011 Fabian Kreiser. All rights reserved.
//
//  NOTE: The calculations are based on this algorithm: http://williams.best.vwh.net/sunrise_sunset_algorithm.htm
//        An example in order to verify the code can be found at: http://williams.best.vwh.net/sunrise_sunset_example.htm
//

/*
 *  IMPORTANT:
 *    FKDaylightCalculator uses ARC for memory management!
*/

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  FKDaylightCalculatorZenith
 *  
 *  Discussion:
 *    Use this enumerator value to change the algorithm's zenith value.
 *
 *  Values:
 *    FKDaylightCalculatorZenithOfficial:
 *      90.8333333 degrees.
 *    FKDaylightCalculatorZenithCivil:
 *      96 degrees.
 *    FKDaylightCalculatorZenithNautical:
 *      102 degrees.
 *    FKDaylightCalculatorZenithAstronomical:
 *      108 degrees.
*/

enum {
	FKDaylightCalculatorZenithOfficial = 0,
	FKDaylightCalculatorZenithCivil,
	FKDaylightCalculatorZenithNautical,
	FKDaylightCalculatorZenithAstronomical,
};
typedef NSInteger FKDaylightCalculatorZenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@interface FKDaylightCalculator : NSObject {

}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  addObserverForDaylightChangesWithBlock:atCoordinate:
 *  addObserverForDaylightChangesWithBlock:atCoordinate:zenith:
 *
 *  Discussion:
 *    Add an observer for daylight changes at a given coordinate with a specifiv value for the zenith. Whenever daylight changes (at sunrise or sunset), the block is executed so you can adjust your interface.
 *
 *  Parameters:
 *    block:
 *      The block to execute when the daylight changes.
 *    coordinate:
 *      The coordinate for the location you want to get daylight information about.
 *    zenith:
 *      The zenith parameter you want to use for the calculation. See also: FKDaylightCalculatorZenith.
*/

+ (NSUInteger) addObserverForDaylightChangesWithBlock:(void (^)(BOOL isSunVisible))block atCoordinate:(CLLocationCoordinate2D)coordinate;
+ (NSUInteger) addObserverForDaylightChangesWithBlock:(void (^)(BOOL isSunVisible))block atCoordinate:(CLLocationCoordinate2D)coordinate zenith:(FKDaylightCalculatorZenith)zenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  removeObserverWithTag:
 *
 *  Discussion:
 *    Remove an observer for daylight changes with a given tag. The tag is the return value of one of the addObserverForDaylightChangesWithBlock: methods.
 *
 *  Parameters:
 *    tag:
 *      The tag of the observer to remove.
*/

+ (void) removeObserverWithTag:(NSUInteger)tag;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  updateDaylightChangesTimeInterval
 *  setUpdateDaylightChangesTimeInterval:
 *
 *  Discussion:
 *    Use these methods to get and set the update time interval for daylight changes. The default value is ten minutes.
*/

+ (NSTimeInterval) updateDaylightChangesTimeInterval;
+ (void) setUpdateDaylightChangesTimeInterval:(NSTimeInterval)timeInterval;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  daylightCalculatorWithCoordinate:
 *  daylightCalculatorWithCoordinate:zenith:
 *
 *  Discussion:
 *    Use this convenience class method to quickly create an instance of the FKDaylightCalculator class.
 *
 *  Parameters:
 *    coordinate:
 *      The coordinate for the location you want to get daylight information about.
 *    zenith:
 *      The zenith parameter you want to use for the calculation. See also: FKDaylightCalculatorZenith.
*/

+ (FKDaylightCalculator *) daylightCalculatorWithCoordinate:(CLLocationCoordinate2D)coordinate;
+ (FKDaylightCalculator *) daylightCalculatorWithCoordinate:(CLLocationCoordinate2D)coordinate zenith:(FKDaylightCalculatorZenith)zenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  initWithCoordinate:
 *  initWithCoordinate:zenith:
 *
 *  Discussion:
 *    Use this initializer method to create an instance of the FKDaylightCalculator class. Throws an exception if the coordinate passed is invalid.
 *
 *  Parameters:
 *    coordinate:
 *      The coordinate for the location you want to get daylight information about.
 *    zenith:
 *      The zenith parameter you want to use for the calculation. See also: FKDaylightCalculatorZenith.
*/

- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithCoordinate:(CLLocationCoordinate2D)coordinate zenith:(FKDaylightCalculatorZenith)zenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  isSunVisible
 *
 *  Discussion:
 *    Use this method to see whether the sun is currently visible at the desired location.
 *
 *  Return value:
 *    A BOOL value that is YES when the sun is visible and NO otherwise.
*/

- (BOOL) isSunVisible;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  todaysSunrise
 *  todaysSunset
 *
 *  Discussion:
 *    Use these methods to get a reference to today's sunrise/sunset date respectively.
 *
 *  Return value:
 *    A NSDate instance with today's date of sunrise/sunset respectively.
*/

- (NSDate *) todaysSunrise;
- (NSDate *) todaysSunset;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  todaysDaylightTime
 *
 *  Discussion:
 *    Use this method to measure the time between sunrise and sunset for today.
 *
 *  Return value:
 *    A NSTimeInterval value with the time interval between sunrise and sunset measured in seconds.
*/

- (NSTimeInterval) todaysDaylightTime;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  nextSunrise
 *  nextSunset
 *
 *  Discussion:
 *    Use these methods to get a reference to the next - that is either today or tomorrow depending on the current time - sunrise/sunset date respectively.
 *
 *  Return value:
 *    A NSDate instance with the next date of sunrise/sunset respectively.
*/

- (NSDate *) nextSunrise;
- (NSDate *) nextSunset;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  sunriseForDate:
 *  sunsetForDate:
 *
 *  Discussion:
 *    Use these methods to get a reference to the date of sunset/sunrise for the specified date respectively.
 *
 *  Parameters:
 *    date:
 *      An instance of NSDate for the day you want to get daylight information about.
 *
 *  Return value:
 *    A NSDate instance with the date of sunrise/sunset on the specified date respectively.
*/

- (NSDate *) sunriseForDate:(NSDate *)date;
- (NSDate *) sunsetForDate:(NSDate *)date;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  daylightTimeForDate:
 *
 *  Discussion:
 *    Use this method to measure the time between sunrise and sunset for the specified date.
 *
 *  Parameters:
 *    date:
 *      An instance of NSDate for the day you want to get daylight information about.
 *
 *  Return value:
 *    A NSTimeInterval value with the time interval between sunrise and sunset measured in seconds.
*/

- (NSTimeInterval) daylightTimeForDate:(NSDate *)date;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

/*
 *  coordinate
 *
 *  Discussion:
 *    A CLLocationCoordinate2D struct holding the coordinate for the desired location. This is typically set using one of the initializer methods.
*/

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

/*
 *  zenith
 *
 *  Discussion:
 *    A FKDaylightCalculatorZenith enumerator value used by the algorithm. This is typically set using one of the initializer methods. See also: FKDaylightCalculatorZenith.
*/

@property (nonatomic, assign) FKDaylightCalculatorZenith zenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@end