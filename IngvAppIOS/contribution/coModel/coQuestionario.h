//
//  coQuestionario.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coWhereLocation.h"

@interface coQuestionario : NSObject
@property (strong, nonatomic) NSDate *whenDetail;
@property (nonatomic) coWhereLocation *where;
@property (nonatomic) NSInteger floor;
@property (nonatomic) NSInteger totalFloors;
@property (nonatomic) NSInteger whereDetail;
@property (nonatomic) NSInteger what;
@property (nonatomic) NSInteger effects;
@end
