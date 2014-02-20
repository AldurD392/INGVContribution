//
//  coEndTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 13/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coEndTVC.h"
#import "Server.h"

@interface coEndTVC ()

@end

@implementation coEndTVC

- (IBAction)linkButtonPressed:(UIButton *)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.haisentitoilterremoto.it"]];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void) sendQuestionario {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSString *post = [self.delegate.questionario questionarioToPostString];
        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        
        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSString *urlstring = [NSString stringWithFormat:@"http://%@/%@", SERVER, QUESTIONARIO];
        [request setURL:[NSURL URLWithString:urlstring]];
        [request setHTTPMethod:@"POST"];
        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        
        if (!connection) {
            NSLog(@"Error on connection!");
        }
    });

}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setHidesBackButton:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self sendQuestionario];
}

@end
