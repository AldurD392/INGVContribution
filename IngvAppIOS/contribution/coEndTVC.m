//
//  coEndTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 13/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coEndTVC.h"

@interface coEndTVC ()

@end

@implementation coEndTVC

- (IBAction)linkButtonPressed:(UIButton *)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.haisentitoilterremoto.it"]];
}

- (IBAction)returnButtonPressed:(UIButton *)sender {
//    Invia il questionario e torna alla home.
//    TODO!
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
