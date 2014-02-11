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
- (void) setTotalFloors:(NSInteger)totalFloors {
    _totalFloors = totalFloors;
    self.delegate.questionario.totalFloors = _totalFloors != 0 ? [NSNumber numberWithInt:_totalFloors] : Nil;
    
    if (_totalFloors == 0) {
        self.totalFloorsCell.hidden = YES;
    }
    
    self.totalFloorsCell.detailTextLabel.text = (_totalFloors != 0) ? [NSString stringWithFormat:@"%d", _totalFloors] : Nil;

    [self.tableView reloadData];
    self.nextBarButtonItem.enabled = YES;
}

- (void) setFloor:(NSInteger)floor {
    _floor = floor;
    self.delegate.questionario.floor = _floor != -2 ? [NSNumber numberWithInt:_floor] : Nil;
    
    
    self.floorCell.detailTextLabel.text = (_floor != -2) ? [NSString stringWithFormat:@"%d", _floor] : Nil;
    self.totalFloorsCell.hidden = NO;
    
    [self.tableView reloadData];
}

- (void) setWhereDetail:(NSInteger)whereDetail {
    _whereDetail = whereDetail;
    self.delegate.questionario.whereDetail = _whereDetail;
    
    [self markDetailCell:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:_whereDetail inSection:0]]];
    
    if (_whereDetail == 0) {
        self.floor = -2;
        self.totalFloors = 0;
        self.nextBarButtonItem.enabled = NO;
    } else {
        self.nextBarButtonItem.enabled = YES;
    }
}

- (void)markDetailCell:(UITableViewCell *) cell {
    self.edificioCell.accessoryType = UITableViewCellAccessoryNone;
    self.mezzoCell.accessoryType = UITableViewCellAccessoryNone;
    self.apertoCell.accessoryType = UITableViewCellAccessoryNone;
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        self.whereDetail = indexPath.row;
        
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
    
    if (self.whereDetail != self.delegate.questionario.whereDetail) {
        self.whereDetail = self.delegate.questionario.whereDetail;
    }
    
    if (self.whereDetail == 0 &&
        self.delegate.questionario.floor != Nil &&
        self.delegate.questionario.totalFloors != nil) {
        self.floor = [self.delegate.questionario.floor integerValue];
        self.totalFloors = [self.delegate.questionario.totalFloors integerValue];
    }
}

@end
