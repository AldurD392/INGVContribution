//
//  coWhenTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 06/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhenTVC.h"

@interface coWhenTVC ()
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

#pragma mark - Table view data source

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
