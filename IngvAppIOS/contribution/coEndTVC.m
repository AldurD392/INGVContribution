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

    NSString *noteDataString = [self.delegate.questionario questionarioToPostString];
    NSLog(@"Sending questionario.");
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", SERVER, QUESTIONARIO]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (!error) {         
            NSString *text = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
            NSLog(@"Data = %@",text);
            [session invalidateAndCancel];
        } else {
            NSLog(@"%@", error);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelector:@selector(sendQuestionario) withObject:nil afterDelay:30];
            });
        }
    }];
    
    [postDataTask resume];
}

# pragma mark - ViewController Life Cycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	[self.navigationItem setHidesBackButton:YES];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    [self sendQuestionario];
}

@end
