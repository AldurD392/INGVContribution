//
//  WhatDetailTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhatTVC.h"

@interface coWhatTVC ()

@end

@implementation coWhatTVC

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* cqtvc = (coQuestionTVC *) segue.destinationViewController;
        cqtvc.delegate = self.delegate;
        
        cqtvc.delegate.questionario.what = self.choosenValue;
    }
}

# pragma mark - ViewController Life Cycle
- (void) viewWillAppear:(BOOL)animated {
    NSLog(@"%d", self.delegate.questionario.whereDetail);
    if (self.delegate.questionario.what) {
        self.choosenValue = self.delegate.questionario.what;
    }
}

@end
