//
//  coWhereTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 22/01/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhereTVC.h"
#import "coIndirizzoTVC.h"

@interface coWhereTVC ()
@property (weak, nonatomic) IBOutlet UISwitch *currentPositionSwitch;

@end

@implementation coWhereTVC

# pragma mark - Setters and getters
- (void) setRegion:(NSDictionary *)region {
    _region = region;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.textLabel.text = [[_region allValues] firstObject];
    
    NSLog(@"%@", cell);
}

# pragma mark - IBActions
- (IBAction)currestPositionSwitchDidChanged:(UISwitch *)sender {
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.

    if ([self.currentPositionSwitch isOn]) {
        return 1;
    } else {
        return 2;
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"coIndirizzoSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc loadRegions];
    }
}

@end
