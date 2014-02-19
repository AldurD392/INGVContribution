//
//  coQuestionario.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import <objc/runtime.h>
#import "coQuestionario.h"

@implementation coQuestionario
- (id)init {
    self = [super init];
    
    if (self) {
        self.whenCompiled = [NSDate date];
    }
    
    return self;
}

- (void) resetBuildingAnswer {
    self.lampadari = nil;
    self.porcellane = nil;
    self.soprammobili = nil;
    self.porcellane = nil;
    self.liquidi = nil;
    self.quadri = nil;
    self.mobili = nil;
    self.struttura = nil;
    self.muri = nil;
    self.tegole = nil;
    self.camini = nil;
}

- (void) resetOpenAirAnswer {
    self.piante =nil;
    self.piscine = nil;
}

- (void) resetAllAnswer {
    self.lampadari = nil;
    self.porcellane = nil;
    self.soprammobili = nil;
    self.porcellane = nil;
    self.liquidi = nil;
    self.quadri = nil;
    self.mobili = nil;
    self.struttura = nil;
    self.muri = nil;
    self.tegole = nil;
    self.camini = nil;
    self.piante =nil;
    self.piscine = nil;
    self.altriFenomeni = nil;
    self.rumore = nil;
    self.inizioRumore = nil;
    self.provenienzaRumore = nil;
    self.effects = nil;
    self.paura = nil;
    self.equilibrio = nil;
}

//Add this utility method in your class.
- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSLog(@"%@", key);
        if ([obj valueForKey:key]) {
            [dict setObject:[obj valueForKey:key] forKey:key];
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}

@end
