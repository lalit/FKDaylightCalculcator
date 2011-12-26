//
//  FKDaylightCalculator.m
//  Daylight
//
//  Created by Fabian Kreiser on 11.11.11.
//  Copyright 2011 Fabian Kreiser. All rights reserved.
//

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark -
#pragma mark Header
// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#import "FKDaylightCalculator.h"

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@interface FKDaylightCalculator ()

- (NSDate *) dateOfSunriseOrSunset:(BOOL)isSunrise forDate:(NSDate *)gregorianDate;

@end

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@implementation FKDaylightCalculator
@synthesize coordinate, zenith;

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark -
#pragma mark Class Methods
// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

+ (FKDaylightCalculator *) daylightCalculatorWithCoordinate:(CLLocationCoordinate2D)coordinate {
	return [[self alloc] initWithCoordinate:coordinate];
}

+ (FKDaylightCalculator *) daylightCalculatorWithCoordinate:(CLLocationCoordinate2D)coordinate zenith:(FKDaylightCalculatorZenith)zenith {
    return [[self alloc] initWithCoordinate:coordinate zenith:zenith];
}


// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark -
#pragma mark Initializer
// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate {
	return [self initWithCoordinate:aCoordinate zenith:FKDaylightCalculatorZenithOfficial];
}

- (id) initWithCoordinate:(CLLocationCoordinate2D)aCoordinate zenith:(FKDaylightCalculatorZenith)aZenith {
	if (self = [super init]) {
		coordinate = aCoordinate;
		zenith = aZenith;
	}
	return self;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark -
#pragma mark Convenienve Methods
// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (BOOL) isSunVisible {
    NSDate *date = [NSDate date];
	return ([[self dateOfSunriseOrSunset:YES forDate:date] timeIntervalSinceNow] <= 0 && [[self dateOfSunriseOrSunset:NO forDate:date] timeIntervalSinceNow] >= 0);
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSDate *) todaysSunrise {
	return [self dateOfSunriseOrSunset:YES forDate:[NSDate date]];
}

- (NSDate *) todaysSunset {
	return [self dateOfSunriseOrSunset:NO forDate:[NSDate date]];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSTimeInterval) todaysDaylightTime {
    NSDate *date = [NSDate date];
    return [[self dateOfSunriseOrSunset:NO forDate:date] timeIntervalSinceDate:[self dateOfSunriseOrSunset:YES forDate:date]];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSDate *) nextSunrise {
	NSDate *todaySunrise = [self dateOfSunriseOrSunset:YES forDate:[NSDate date]];
	if ([todaySunrise timeIntervalSinceNow] < 0) {		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
		dateComponents.day += 1;
		dateComponents.hour = 12;
		dateComponents.minute = 0;
		dateComponents.second = 0;
		
		return [self dateOfSunriseOrSunset:YES forDate:[calendar dateFromComponents:dateComponents]];
	}
	else
		return todaySunrise;
}

- (NSDate *) nextSunset {
	NSDate *todaySunset = [self dateOfSunriseOrSunset:NO forDate:[NSDate date]];
	if ([todaySunset timeIntervalSinceNow] < 0) {		
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
		dateComponents.day += 1;
		dateComponents.hour = 12;
		dateComponents.minute = 0;
		dateComponents.second = 0;
		
		return [self dateOfSunriseOrSunset:NO forDate:[calendar dateFromComponents:dateComponents]];
	}
	else
		return todaySunset;
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSDate *) sunriseForDate:(NSDate *)date {
	return [self dateOfSunriseOrSunset:YES forDate:date];
}

- (NSDate *) sunsetForDate:(NSDate *)date {
	return [self dateOfSunriseOrSunset:NO forDate:date];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSTimeInterval) daylightTimeForDate:(NSDate *)date {
    return [[self dateOfSunriseOrSunset:NO forDate:date] timeIntervalSinceDate:[self dateOfSunriseOrSunset:YES forDate:date]];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -
#pragma mark -
#pragma mark Algorithm
// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

- (NSDate *) dateOfSunriseOrSunset:(BOOL)sunriseOrSunset forDate:(NSDate *)date {
    // (0.) convert date in NSDateComponents
    
	NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
	NSDateComponents *dateComponents = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
	
    // 1. first calculate the day of the year
    
    NSInteger N1 = floor(275 * dateComponents.month / 9);
	NSInteger N2 = floor((dateComponents.month + 9) / 12);
	NSInteger N3 = (1 + floor((dateComponents.year - 4 * floor(dateComponents.year / 4) + 2) / 3));
	NSInteger N = N1 - (N2 * N3) + dateComponents.day - 30;
	
    // 2. convert the longitude to hour value and calculate an approximate time
    
    CGFloat lngHour = self.coordinate.longitude / 15;
    
    CGFloat t;
	if (sunriseOrSunset)
		t = N + (6 - lngHour) / 24;
	else
		t = N + (18 - lngHour) / 24;
	
    // 3. calculate the Sun's mean anomaly
    
	CGFloat M = (0.9856 * t) - 3.289;
    
    // 4. calculate the Sun's true longitude
    
    CGFloat L = M + (1.916 * sin(M_PI / 180 * M )) + (0.02 * sin(M_PI / 90 * M)) +  282.634;
	if (L < 0)
		L += 360;
	else if (L > 360)
		L -= 360;
    
    // 5a. calculate the Sun's right ascension
    
	CGFloat RA = 180 / M_PI * (atan(0.91764 * tan(M_PI / 180 * L)));
    /*
     // According to the author of the algorithm this is needed, but he doesn't do it in his own example
     
	if (RA < 0)
		RA += 360;
	else if (RA > 360)
		RA -= 360;
    */
    
    // 5b. right ascension value needs to be in the same quadrant as L
    
	NSInteger Lquadrant = floor(L / 90) * 90;
	NSInteger RAquadrant = floor(RA / 90) * 90;
	RA = RA + (Lquadrant - RAquadrant);
    
    // 5c. right ascension value needs to be converted into hours
    
    RA = RA / 15;
    
    // 6. calculate the Sun's declination
    
    CGFloat sinDec = 0.39782 * sin(M_PI / 180 * L);
	CGFloat cosDec = cos(asin(sinDec));
	
    // 7a. calculate the Sun's local hour angle
    
    CGFloat zenithValue;
	if (self.zenith == FKDaylightCalculatorZenithCivil)
		zenithValue = 96;
	else if (self.zenith == FKDaylightCalculatorZenithNautical)
		zenithValue  = 102;
	else if (self.zenith == FKDaylightCalculatorZenithAstronomical)
		zenithValue = 108;
	else
		zenithValue = 90.8333333;
    
	CGFloat cosH = (cos(M_PI / 180 * zenithValue) - (sinDec * sin(M_PI / 180 * self.coordinate.latitude))) / (cosDec * cos(M_PI / 180 * self.coordinate.latitude));
	
	if (cosH >  1) 
        return nil; // the sun never rises on this location (on the specified date)
    else if (cosH < -1)
        return nil; // the sun never sets on this location (on the specified date)
    
    // 7b. finish calculating H and convert into hours
	
	CGFloat H;
	if (sunriseOrSunset)
		H = 360 - 180 / M_PI * (acos(cosH));
	else
		H = 180 / M_PI * (acos(cosH));
    
    H = H / 15;
	
    
    // 8. calculate local mean time of rising/setting
    
    CGFloat T = H + RA - (0.06571 * t) - 6.622;
    
    // 9. adjust back to UTC
    
    CGFloat UT = T - lngHour;
    if (UT < 0)
        UT += 24;
    else if (UT > 24)
        UT -= 24;
    
    // 10. convert UT value to local time zone of latitude/longitude
	
    CGFloat localOffset = (lngHour >= 0) ? floor(lngHour) : ceil(lngHour); // TODO: This is just an approximation and needs improvement!
	CGFloat localT = UT + localOffset;
    
    // (11.) create a new date from calculated values
    
	NSDateComponents *newDateComponents = [[NSDateComponents alloc] init];
	newDateComponents.year = dateComponents.year;
	newDateComponents.month = dateComponents.month;
	newDateComponents.day = dateComponents.day;
	newDateComponents.hour = floor(localT);
	newDateComponents.minute = floor(60 * (localT - newDateComponents.hour));
	newDateComponents.second = round(3600 * (localT - newDateComponents.hour - (CGFloat)newDateComponents.minute / 60));
	
	return [calendar dateFromComponents:newDateComponents];
}

// - - - - - - - - - - - - - - - - - - - - - - - - - - - -

@end