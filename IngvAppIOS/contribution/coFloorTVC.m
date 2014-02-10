//
//  coFloorTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 07/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coFloorTVC.h"

@interface coFloorTVC ()

@end

@implementation coFloorTVC

#pragma mark - Table view data source

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.detailDelegate.value == numberFloor) {
        self.detailDelegate.floor = indexPath.row - 1;
    } else if (self.detailDelegate.value == totalFloor) {
        self.detailDelegate.totalFloors = indexPath.row + 1;
    }
    
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.detailDelegate.floor && self.detailDelegate.value == totalFloor) {
            return 0;
    }
    
    return tableView.rowHeight;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.detailDelegate.value == totalFloor) {
        for (int i = 0; i < self.detailDelegate.floor; i++) {
            [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]].hidden = YES;
        }
        
        [self.tableView reloadData];
    }
}

@end
