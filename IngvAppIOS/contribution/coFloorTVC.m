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

# pragma mark - Setters and Getters
-(void)setFloorsArray:(NSArray *)floorsArray {
    _floorsArray = floorsArray;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.floorsArray count];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate.value == numberFloor) {
        self.delegate.floor = indexPath.row - 1;
    } else if (self.delegate.value == totalFloor) {
        self.delegate.totalFloors = indexPath.row;
    }
    
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"coFloorIdentifierCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.floorsArray objectAtIndex:indexPath.row];
    
    return cell;
}

@end
