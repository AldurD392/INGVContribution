//
//  coStartingViewController.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coStartingViewController.h"
#import "coQuestionario.h"
#import "coQuestionTVC.h"

@interface coStartingViewController ()

@end

@implementation coStartingViewController

// Lazy initialization dell'oggetto relativo al questionario
- (coQuestionario *) questionario {
    if (_questionario == nil) {
        _questionario = [[coQuestionario alloc] init];
    }
    
    return _questionario;
}

// Al momento del prepare for segue, si setta se stessi come delegati!
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coQuestionarioSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        if ([nc.topViewController isKindOfClass:[coQuestionTVC class]]) {
            coQuestionTVC* cqtvc = (coQuestionTVC *)nc.topViewController;
            cqtvc.delegate = self;
            
//            Quando il terremoto non ha ancora un ID assegnato da INGV, si utilizza -1.
//            In questo caso infatti, si sta compilando un questionario per un terremoto non in lista
            cqtvc.delegate.questionario.terremotoID = [NSString stringWithFormat:@"%d", -1];
            cqtvc.delegate.questionario.utenteID = @"ID_UTENTE"; // Qui va inserito l'id dell'utente!
        }
    } else if ([segue.identifier isEqualToString:@"coQuestionarioTerremotoSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        if ([nc.topViewController isKindOfClass:[coQuestionTVC class]]) {
            coQuestionTVC* cqtvc = (coQuestionTVC *)nc.topViewController;
            cqtvc.delegate = self;
            
            cqtvc.delegate.questionario.terremotoID = @"ID_TERREMOTO"; // Qui va inserito l'id del terremoto!
            cqtvc.delegate.questionario.utenteID = @"ID_UTENTE"; // Qui va inserito l'id dell'utente!
        }
    }
}

@end
