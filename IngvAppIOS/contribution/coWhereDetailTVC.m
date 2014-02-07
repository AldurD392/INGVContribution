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

@end

@implementation coWhereDetailTVC

# pragma mark - Setters and Getters
- (void) setTotalFloors:(NSInteger)totalFloors {
    _totalFloors = totalFloors;
    self.totalFloorsCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _totalFloors];

    [self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:self.totalFloorsCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void) setFloor:(NSInteger)floor {
    _floor = floor;
    self.floorCell.detailTextLabel.text = [NSString stringWithFormat:@"%d", _floor];
    
    [self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:@[[self.tableView indexPathForCell:self.floorCell]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        
        cftvc.title = @"Piano";
        cftvc.floorsArray = @[@"Interrato",
                              @"Terreno",
                              @"1° Piano",
                              @"2° Piano",
                              @"3° Piano",
                              @"4° Piano",
                              @"5° Piano",
                              @"6° Piano",
                              @"7° Piano",
                              @"8° Piano",
                              @"9° Piano",
                              @"10° Piano",
                              @"Superiore"
                              ];
        self.value = numberFloor;
    } else if ([segue.identifier isEqualToString:@"coWhereTotalFloorsSegue"]) {
        
        cftvc.title = @"Numero totale di piani";
        cftvc.floorsArray = @[@"1 Piano",
                              @"2 Piani",
                              @"3 Piani",
                              @"4 Piani",
                              @"5 Piani",
                              @"6 Piani",
                              @"7 Piani",
                              @"8 Piani",
                              @"9 Piani",
                              @"10 Piani",
                              @"Superiore"
                              ];
        self.value = totalFloor;
    }
}

@end
