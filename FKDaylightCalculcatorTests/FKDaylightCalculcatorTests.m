//
//  FKDaylightCalculcatorTests.m
//  FKDaylightCalculcatorTests
//
//  Created by Fabian Kreiser on 26.12.11.
//  Copyright (c) 2011 Fabian Kreiser. All rights reserved.
//

#import "FKDaylightCalculcatorTests.h"
#import "FKDaylightCalculator.h"

@implementation FKDaylightCalculcatorTests

- (void) testAlgorithmExample {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *inputDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    inputDateComponents.year = 1990;
	inputDateComponents.day = 25;
	inputDateComponents.month = 6;
	inputDateComponents.hour = 12;
	inputDateComponents.minute = 0;
    
    NSDateComponents *outputDateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    outputDateComponents.year = 1990;
	outputDateComponents.day = 25;
	outputDateComponents.month = 6;
	outputDateComponents.hour = 5;
	outputDateComponents.minute = 26;
        
    FKDaylightCalculator *calculator = [FKDaylightCalculator daylightCalculatorWithCoordinate:CLLocationCoordinate2DMake(40.9, -74.3)];
    NSDate *calculatedDate = [calculator sunriseForDate:[calendar dateFromComponents:inputDateComponents]];
    NSDate *desiredOutputDate = [calendar dateFromComponents:outputDateComponents];

    if (abs([calculatedDate timeIntervalSinceDate:desiredOutputDate]) > 60 * 15)
        STFail(@"Daylight calculator is not working correctly! Difference between desired and calculated output is too big. (More than 15 minutes)");
}

@end