//
//  coQuestionTVC.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coQuestionarioProtocol.h"

@interface coQuestionTVC : UITableViewController
@property (strong, nonatomic) id <coQuestionarioProtocol> delegate;

- (IBAction)cancelButtonPressed:(UIBarButtonItem *)sender;
@end

