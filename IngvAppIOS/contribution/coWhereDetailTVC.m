//
//  WhereDetailTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 07/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhereDetailTVC.h"
#import "coFloorTVC.h"
#import "coQuestionTVC.h"

@interface coWhereDetailTVC ()
@property (weak, nonatomic) IBOutlet UITableViewCell *edificioCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *mezzoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *apertoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *floorCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *totalFloorsCell;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

@end

@implementation coWhereDetailTVC

# pragma mark - Setters and Getters

- (void) setTotalFloors:(NSNumber *)totalFloors {
    self.delegate.questionario.totalFloors = totalFloors;
}

- (NSNumber *)totalFloors {
    return self.delegate.questionario.totalFloors;
}

- (void) setFloor:(NSNumber *)floor {
    self.delegate.questionario.floor = floor;
}

- (NSNumber *)floor {
    return self.delegate.questionario.floor;
}

- (void) setWhereDetail:(NSNumber *)whereDetail {
    self.delegate.questionario.whereDetail = whereDetail;
    
    if (whereDetail.integerValue == 0) {
        self.totalFloors = nil;
        self.floor = nil;
    }
}

- (NSNumber *)whereDetail {
    return self.delegate.questionario.whereDetail;
}

- (void)markDetailCell:(UITableViewCell *) cell {
    self.edificioCell.accessoryType = UITableViewCellAccessoryNone;
    self.mezzoCell.accessoryType = UITableViewCellAccessoryNone;
    self.apertoCell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.whereDetail = [NSNumber numberWithInt:indexPath.row];
        
        //Put this code where you want to reload your table view
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView transitionWithView:self.tableView
                              duration:0.2f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^(void) {
                                [self.tableView reloadData];
                            } completion:NULL];
        });
        
        [self updateView];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.edificioCell.accessoryType != UITableViewCellAccessoryNone) {
        return 2;
    } else {
        return 1;
    }
}

- (void) updateView {
    
    [self markDetailCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.whereDetail.integerValue inSection:0               ]]];
    
    if (self.whereDetail.integerValue != 0) {
        self.nextBarButtonItem.enabled = YES;
    } else {
        
        if (self.floor == nil) {
            self.floorCell.detailTextLabel.text = nil;
            self.totalFloorsCell.hidden = YES;
        } else {
            self.floorCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.floor];
            self.totalFloorsCell.hidden = NO;
        }
        
        if (self.totalFloors == nil) {
            self.totalFloorsCell.detailTextLabel.text = nil;
            self.nextBarButtonItem.enabled = NO;
        } else {
            self.totalFloorsCell.detailTextLabel.text = [NSString stringWithFormat:@"%@", self.totalFloors];
            self.nextBarButtonItem.enabled = YES;
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* cqtvc = (coQuestionTVC *) segue.destinationViewController;
        cqtvc.delegate = self.delegate;
    }
    
    if ([segue.identifier isEqualToString:@"coWhereFloorSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coFloorTVC *cftvc = (coFloorTVC *)[nc topViewController];
        cftvc.detailDelegate = self;
        
        self.value = numberFloor;
    } else if ([segue.identifier isEqualToString:@"coWhereTotalFloorsSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coFloorTVC *cftvc = (coFloorTVC *)[nc topViewController];
        cftvc.detailDelegate = self;
        
        self.value = totalFloor;
    }
}

# pragma mark - ViewController Life Cycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateView];
}

@end
