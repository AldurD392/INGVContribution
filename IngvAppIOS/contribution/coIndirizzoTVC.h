//
//  coIndirizzoTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 06/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface coIndirizzoTVC : UITableViewController

- (void) loadRegions;
- (void) loadProvince: (NSString *) regionCode;
- (void) loadComuni: (NSString *) provinciaCode;

@end
