//
//  FKAppDelegate.m
//  FKDaylightCalculcator
//
//  Created by Fabian Kreiser on 26.12.11.
//  Copyright (c) 2011 Fabian Kreiser. All rights reserved.
//

#import "FKAppDelegate.h"
#import "FKDaylightCalculator.h"

@implementation FKAppDelegate
@synthesize window, locationManager;

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor grayColor];
    [application setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    [self.window makeKeyAndVisible];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 10000;
    [self.locationManager startUpdatingLocation];
    
    FKDaylightCalculator *cupertinoDaylightCalculator = [FKDaylightCalculator daylightCalculatorWithCoordinate:CLLocationCoordinate2DMake(37.33233141, -122.03121860)];
    NSLog(@"Sunrise today in Cupertino: %@", [cupertinoDaylightCalculator todaysSunrise]);
    NSLog(@"Sunset today in Cupertino: %@", [cupertinoDaylightCalculator todaysSunset]);
    
    return YES;
}

- (void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    FKDaylightCalculator *daylightCalculator = [FKDaylightCalculator daylightCalculatorWithCoordinate:newLocation.coordinate];
    NSLog(@"Sunrise today at current location: %@", [daylightCalculator todaysSunrise]);
    NSLog(@"sunset today at current location: %@", [daylightCalculator todaysSunset]);
    NSLog(@"Sun is currently visible: %d", [daylightCalculator isSunVisible]);
    
    [UIView animateWithDuration:UINavigationControllerHideShowBarDuration animations:^{
        self.window.backgroundColor = ([daylightCalculator isSunVisible]) ? [UIColor whiteColor] : [UIColor blackColor];
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:([daylightCalculator isSunVisible]) ? UIStatusBarStyleDefault : UIStatusBarStyleBlackOpaque animated:YES];
}

@end