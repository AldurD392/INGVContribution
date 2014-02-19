//
//  coShortEndTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 19/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coShortEndTVC.h"

@interface coShortEndTVC ()

@end

@implementation coShortEndTVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (!localNotification) {
        NSLog(@"Error creating local notification.");
    }
    
    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:NOTIFICATION_FIRETIME];
    
    localNotification.alertBody = @"Vuoi compilare il questionariok completo?";
    localNotification.alertAction = @"Si!";
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    self.delegate.questionario.where = nil;
    localNotification.userInfo = [self.delegate.questionario dictionaryWithPropertiesOfObject:self.delegate.questionario];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
