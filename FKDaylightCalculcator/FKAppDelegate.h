//
//  FKAppDelegate.h
//  FKDaylightCalculcator
//
//  Created by Fabian Kreiser on 26.12.11.
//  Copyright (c) 2011 Fabian Kreiser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FKAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate> {
    
}

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) CLLocationManager *locationManager;

@end