//
//  WhereDetailTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 07/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coQuestionTVC.h"

typedef enum floorValue {
    numberFloor = 1,
    totalFloor
} floorValue;

@interface coWhereDetailTVC : coQuestionTVC
@property (nonatomic) NSInteger whereDetail;
@property (nonatomic) NSInteger whatDetail;
@property (nonatomic) NSInteger floor;
@property (nonatomic) NSInteger totalFloors;
@property (nonatomic) floorValue value;
@end
