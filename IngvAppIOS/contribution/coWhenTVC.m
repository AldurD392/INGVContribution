//
//  coWhenTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 06/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhenTVC.h"

@interface coWhenTVC ()
@property (weak, nonatomic) IBOutlet UISwitch *currentDateTimeSwitch;

@end

@implementation coWhenTVC

# pragma mark - IBActions
- (IBAction)currestPositionSwitchDidChanged:(UISwitch *)sender {

    //Put this code where you want to reload your table view
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.tableView
                          duration:0.2f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self.tableView reloadData];
                        } completion:NULL];
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{   
    if ([self.currentDateTimeSwitch isOn]) {
        return 1;
    } else {
        return 2;
    }
}

@end
