//
//  coIndirizzoTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 06/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coQuestionTVC.h"

@protocol coIndirizzoTVCDelegate
- (void)didFinishSelectingAddress:(NSDictionary *)dataDictionary;
@end

@interface coIndirizzoTVC : coQuestionTVC

@property (nonatomic, assign) id <coIndirizzoTVCDelegate> whereDelegate;

- (void) loadContries;
- (void)loadRegions;
- (void)loadProvince:(NSString *)regionCode;
- (void)loadComuni:(NSString *)provinciaCode;
- (void) loadFrazioni:(NSString *)comuneCode withRegionCode:(NSString*) regionCode;

@end
