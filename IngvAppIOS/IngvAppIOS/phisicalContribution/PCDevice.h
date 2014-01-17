//
//  Device.h
//  Project
//
//  Created by Lorenzo Spataro  on 12/14/13.
//  Copyright (c) 2013 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface Device : NSObject
@property NSString *nomeDevice;
@property NSString *macAddr;

@property CLLocationCoordinate2D gps;
@property NSString* addressOfCoordinate;
@end
