//
//  coQuestionario.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coQuestionario.h"

@implementation coQuestionario
- (id)init {
    self = [super init];
    
    if (self) {
        self.whenCompiled = [NSDate date];
    }
    
    return self;
}
@end
