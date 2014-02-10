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
@property (strong, nonatomic) NSDate* date;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation coWhenTVC

# pragma mark - Setters / Getters


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

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([self.currentDateTimeSwitch isOn]) {
        self.date = [NSDate date];
    } else {
        self.date = [self.datePicker date];
    }
    
    self.delegate.questionario.whenDetail = self.date;
    coQuestionTVC* cqtvc = (coQuestionTVC *) [segue destinationViewController];
    cqtvc.delegate = self.delegate;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.delegate.questionario.whenDetail != nil) {
        self.datePicker.date = self.delegate.questionario.whenDetail;
    }
}

@end
