//
//  coFloorTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 07/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coWhereDetailTVC.h"
#import "coQuestionTVC.h"

@interface coFloorTVC : coQuestionTVC
@property (assign, nonatomic) coWhereDetailTVC* detailDelegate;
@end
