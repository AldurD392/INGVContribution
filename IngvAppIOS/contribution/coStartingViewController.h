//
//  coStartingViewController.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "coQuestionarioProtocol.h"
#import "coQuestionTVC.h"

@interface coStartingViewController: UITableViewController <coQuestionarioProtocol>
@property (strong, nonatomic) coQuestionario *questionario;

@property (strong, nonatomic) NSNumber *terremotoID;

// TODO: questo andrà sostituito con il metodo appropriato!
+ (NSString *) detailsForTerremoto: (NSNumber *) terremotoID;
@end
