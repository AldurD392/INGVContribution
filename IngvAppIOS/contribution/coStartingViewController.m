//
//  coStartingViewController.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coStartingViewController.h"
#import "coQuestionario.h"
#import "coQuestionTVC.h"

@interface coStartingViewController ()
@property (strong, nonatomic, readwrite) coQuestionario *questionario;
@end

@implementation coStartingViewController

- (coQuestionario *) questionario {
    if (_questionario == nil) {
        _questionario = [[coQuestionario alloc] init];
    }
    
    return _questionario;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coQuestionarioSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        if ([nc.topViewController isKindOfClass:[coQuestionTVC class]]) {
            coQuestionTVC* cqtvc = (coQuestionTVC *)nc.topViewController;
            cqtvc.delegate = self;
        }
    }
}

@end
