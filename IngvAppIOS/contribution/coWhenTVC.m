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
- (void) setDate:(NSDate *)date {
    self.delegate.questionario.whenDetail = date;
}

- (NSDate *) date {
    return self.delegate.questionario.whenDetail;
}

# pragma mark - IBActions
- (IBAction)currestPositionSwitchDidChanged:(UISwitch *)sender {
    
    if (sender.isOn) {
        self.date = [NSDate date];
    }

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

- (IBAction)datePickerValueChanger:(UIDatePicker *)sender {
    self.date = sender.date;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    coQuestionTVC* cqtvc = (coQuestionTVC *) [segue destinationViewController];
    cqtvc.delegate = self.delegate;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.date != nil) {
        self.datePicker.date = self.date;
    }
}

@end
