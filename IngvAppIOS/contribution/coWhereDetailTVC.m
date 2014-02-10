//
//  WhereDetailTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 07/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhereDetailTVC.h"
#import "coFloorTVC.h"

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
    
    if (_totalFloors == 0) {
        self.totalFloorsCell.hidden = YES;
    }
    
    self.totalFloorsCell.detailTextLabel.text = (_totalFloors != 0) ? [NSString stringWithFormat:@"%d", _totalFloors] : Nil;

    [self.tableView reloadData];
    self.nextBarButtonItem.enabled = YES;
}

- (void) setFloor:(NSInteger)floor {
    _floor = floor;
    self.floorCell.detailTextLabel.text = (_floor != -2) ? [NSString stringWithFormat:@"%d", _floor] : Nil;
    self.totalFloorsCell.hidden = NO;
    
    [self.tableView reloadData];
}

- (void) setWhereDetail:(NSInteger)whereDetail {
    _whereDetail = whereDetail;
    if (_whereDetail == 0) {
        self.nextBarButtonItem.enabled = NO;
        self.floor = -2;
        self.totalFloors = 0;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self markDetailCell:self.edificioCell];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        [self markDetailCell:[self.tableView cellForRowAtIndexPath:indexPath]];
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
    UINavigationController *nc = segue.destinationViewController;
    coFloorTVC *cftvc = (coFloorTVC *)[nc topViewController];
    cftvc.delegate = self;
    
    if ([segue.identifier isEqualToString:@"coWhereFloorSegue"]) {
        self.value = numberFloor;
    } else if ([segue.identifier isEqualToString:@"coWhereTotalFloorsSegue"]) {
        self.value = totalFloor;
    }
}

@end
