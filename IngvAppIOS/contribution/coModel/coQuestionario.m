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

- (NSDictionary *) questionarioToDictionary {
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    
    if (self.terremotoID) {
        [mutableDictionary setObject:self.terremotoID forKey:TERREMOTO_ID];
    }
    
    if (self.utenteID) {
        [mutableDictionary setObject:self.utenteID forKey:UTENTE_ID];
    }
    
    
    
    return [mutableDictionary copy];
};

@end
