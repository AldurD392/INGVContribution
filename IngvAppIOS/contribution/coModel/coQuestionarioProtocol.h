//
//  coQuestionarioProtocol.h
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "coQuestionario.h"

@protocol coQuestionarioProtocol <NSObject>

@required
// This will be the main "questionario", all mvc will be able to access it.
@property (strong, nonatomic) coQuestionario *questionario;

@end
