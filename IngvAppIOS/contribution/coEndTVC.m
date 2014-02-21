//
//  coEndTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 13/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coEndTVC.h"
#import "Server.h"

@interface coEndTVC () <NSURLConnectionDelegate>

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
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/%@", SERVER, QUESTIONARIO]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPBody = [noteDataString dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPMethod = @"POST";
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        // The server answers with an error because it doesn't receive the params
    }];
    
    [postDataTask resume];
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
//        NSString *post = [self.delegate.questionario questionarioToPostString];
//        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
//        
//        NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
//        
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        NSString *urlstring = [NSString stringWithFormat:@"http://%@/%@", SERVER, QUESTIONARIO];
//        [request setURL:[NSURL URLWithString:urlstring]];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
//        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        
//        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:YES];
//        
//        if (!connection) {
//            NSLog(@"Error on connection!");
//        }
//    });

}

# pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"%@", error);
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
