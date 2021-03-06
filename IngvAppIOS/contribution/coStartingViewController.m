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
#import "coWhereTVC.h"
#import "AppDelegate.h"

/* 
 TODO
 Questo viewController è soltanto di esempio, per mostrare come poter integrare il questionario nelle proprie view (information)!
 */

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

/* TODO
 Questo metodo dovrà essere rimpiazzato con l'opportuno metodo, in grado di
 ritornare, tra le altre cose, una stringa contenente i dettagli di un terremoto a partire dall'ID */
+ (NSString *) detailsForTerremoto: (NSNumber *) terremotoID {
    return @"terremoto di prova";
}


#define ID_TERREMOTO_SEL 3
- (NSNumber *) terremotoID {
    if (!_terremotoID) {
        /* TODO
         Questo metodo dovrà essere rimpiazzato con l'opportuno metodo per ritornare l'id del terremoto a partire dalla view in cui ci si trova. */
        return [NSNumber numberWithInt:ID_TERREMOTO_SEL];
    } else {
        return _terremotoID;
    }
}

// Al momento del prepare for segue, si setta se stessi come delegati!
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"coQuestionarioSegue"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        if ([nc.topViewController isKindOfClass:[coQuestionTVC class]]) {
            coQuestionTVC* cqtvc = (coQuestionTVC *)nc.topViewController;
            cqtvc.delegate = self;
            
//            Quando il terremoto non ha ancora un ID assegnato da INGV, si utilizza il valore nil.
//            In questo caso infatti, si sta compilando un questionario per un terremoto non in lista
            cqtvc.delegate.questionario.terremotoID = nil;
            cqtvc.delegate.questionario.deviceuid = [AppDelegate getApplicationUUID]; // TODO: Qui va inserito l'id dell'utente!
        }
    } else if ([segue.identifier isEqualToString:@"coQuestionarioTerremotoSegue"] ||
               [segue.identifier isEqualToString:@"coQuestionarioTerremotoSegueNoAnimation"]) {
        UINavigationController *nc = (UINavigationController *)[segue destinationViewController];
        if ([nc.topViewController isKindOfClass:[coQuestionTVC class]]) {
            coQuestionTVC* cqtvc = (coQuestionTVC *)nc.topViewController;
            cqtvc.delegate = self;
            
            cqtvc.delegate.questionario.terremotoID = self.terremotoID; //TODO: Qui va inserito l'id del terremoto!
            cqtvc.delegate.questionario.deviceuid = [AppDelegate getApplicationUUID]; // TODO: Qui va inserito l'id dell'utente, ma allo stato attuale non sappiamo come sarà!
            
            if ([segue.identifier isEqualToString:@"coQuestionarioTerremotoSegueNoAnimation"]) {
                coWhereTVC *cwtvc = (coWhereTVC *)nc.topViewController;
                cwtvc.push = YES;  // Per far comparire l'alert di informazione.
            }
        }
    } else if ([segue.identifier isEqualToString:@"coTerremotoDetailSegue"]) {
/*        TODO: immaginando che sia qui che il gruppo di information prepara la vista dei dettagli del terremoto da visualizzare,
        si suppone che sia qui, che a seconda dell'ID del terremoto selezionato si prepari il dettaglio da visualizzare all'utente, magari tramite apposita
        property all'interno della stessa classe ospitante la lista. Ai fini dell'integrazione, e visto che vi è un solo oggetto in lista,
        abbiamo tenuto il tutto statico.
*/
        if ([segue.destinationViewController isKindOfClass:[self class]]) {
            coStartingViewController *destination = (coStartingViewController *)segue.destinationViewController;
            destination.terremotoID = self.terremotoID;
        }
    }
}

@end
