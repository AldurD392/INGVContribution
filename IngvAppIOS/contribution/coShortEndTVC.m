//
//  coShortEndTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 19/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coShortEndTVC.h"
#import "coQuestionario.h"

#import "coStartingViewController.h"

@interface coShortEndTVC ()

@end

@implementation coShortEndTVC

- (NSDate *) comfortableNotificationFireDate {
//    Avoid notification on night!
    unsigned unitFlags = NSDayCalendarUnit | NSHourCalendarUnit;

    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:NOTIFICATION_FIRETIME];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    if (components.hour > 22) {
        components.hour = 10;
        components.day++;
        
        date = [calendar dateFromComponents:components];
    } else if (components.hour < 10) {
        components.hour = 10;
        
        date = [calendar dateFromComponents:components];
    }
    
    return date;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    
    if (!localNotification) {
        NSLog(@"Error creating local notification.");
    }
    
    localNotification.fireDate = [self comfortableNotificationFireDate];
    
//    TODO: inserire la funzione per i dettagli del terremoto
    localNotification.alertBody = [NSString stringWithFormat:@"Vuoi compilare il questionario completo per: %@?", [coStartingViewController detailsForTerremoto:self.delegate.questionario.terremotoID]];
    localNotification.alertAction = NSLocalizedString(@"compilare il questionario completo.", @"");
    
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    
    localNotification.userInfo = [self.delegate.questionario dictionaryWithPropertiesOfObject:self.delegate.questionario];
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
