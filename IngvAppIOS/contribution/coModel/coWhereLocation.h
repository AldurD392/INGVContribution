//
//  whereLocation.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface coWhereLocation : NSObject
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *stato;
@property (strong, nonatomic) NSDictionary *regione;
@property (strong, nonatomic) NSDictionary *provincia;
@property (strong, nonatomic) NSDictionary *comune;
@property (strong, nonatomic) NSDictionary *frazione;
@property (strong, nonatomic) NSString *via;
@end
