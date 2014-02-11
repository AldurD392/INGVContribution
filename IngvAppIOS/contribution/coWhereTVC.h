//
//  coWhereTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 22/01/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coQuestionTVC.h"

@interface coWhereTVC : coQuestionTVC
@property (strong, nonatomic) NSDictionary *region;
@property (strong, nonatomic) NSDictionary *provincia;
@property (strong, nonatomic) NSDictionary *comune;
@property (strong, nonatomic) NSDictionary *frazione;
@property (strong, nonatomic) NSString *via;
@end
