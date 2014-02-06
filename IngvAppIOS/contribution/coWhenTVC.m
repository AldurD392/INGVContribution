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
    [self.tableView reloadData];
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
