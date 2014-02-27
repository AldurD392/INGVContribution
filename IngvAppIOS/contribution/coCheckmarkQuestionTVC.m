//
//  coCheckmarkQuestionTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coCheckmarkQuestionTVC.h"
#import "coStartingViewController.h"

@interface coCheckmarkQuestionTVC () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;
@property (weak, nonatomic) IBOutlet UIProgressView *progressionBar;

@property (strong, nonatomic) NSNumber* choosenValue;
@end

@implementation coCheckmarkQuestionTVC

# pragma mark - Setters and getters
- (void) setChoosenValue:(NSNumber *)choosenValue {
    switch (self.view.tag) {
// In case alla view, aggiorniamo il valore appropriato del delegate.
            
        case -1:
            //            Cosa stavi facendo?
            self.delegate.questionario.what = choosenValue;
            break;
            
        case 1:
            self.delegate.questionario.paura = choosenValue;
            break;
            
        case 2:
            self.delegate.questionario.equilibrio = choosenValue;
            break;
            
        case 3:
            self.delegate.questionario.animali = choosenValue;
            break;
            
        case 4:
            self.delegate.questionario.lampadari = choosenValue;
            break;
            
        case 5:
            self.delegate.questionario.porcellane = choosenValue;
            break;
            
        case 6:
            self.delegate.questionario.soprammobili = choosenValue;
            break;
            
        case 7:
            self.delegate.questionario.porte = choosenValue;
            break;
            
        case 8:
            self.delegate.questionario.liquidi = choosenValue;
            break;
            
        case 9:
            self.delegate.questionario.quadri = choosenValue;
            break;
            
        case 10:
            self.delegate.questionario.mobili = choosenValue;
            break;
            
        case 11:
            self.delegate.questionario.rumore = choosenValue;
            break;
            
        case 12:
            self.delegate.questionario.inizioRumore = choosenValue;
            break;
            
        case 13:
            self.delegate.questionario.provenienzaRumore = choosenValue;
            break;
            
        case 14:
            self.delegate.questionario.piscine = choosenValue;
            break;
            
        case 15:
            self.delegate.questionario.piante = choosenValue;
            break;
        case 16:
            self.delegate.questionario.danni = choosenValue;
            break;
            
        case 17:
            self.delegate.questionario.struttura = choosenValue;
            break;
            
        case 18:
            self.delegate.questionario.muri = choosenValue;
            break;
            
        case 19:
            self.delegate.questionario.tegole = choosenValue;
            break;
            
        case 20:
            self.delegate.questionario.camini = choosenValue;
            break;
            
        default:
            NSLog(@"Invalig tag.");
            break;
    }

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:[choosenValue integerValue] inSection:0]];
    
    [self markCellForSelection:cell];
}

- (NSNumber *) choosenValue {
    
    switch (self.view.tag) {
        case -1:
            //            Cosa stavi facendo?
            return self.delegate.questionario.what;
            break;
            
        case 1:
            return self.delegate.questionario.paura;
            break;
            
        case 2:
            return self.delegate.questionario.equilibrio;
            break;
            
        case 3:
            return self.delegate.questionario.animali;
            break;
            
        case 4:
            return self.delegate.questionario.lampadari;
            break;
            
        case 5:
            return self.delegate.questionario.porcellane;
            break;
            
        case 6:
            return self.delegate.questionario.soprammobili;
            break;
            
        case 7:
            return self.delegate.questionario.porte;
            break;
            
        case 8:
            return self.delegate.questionario.liquidi;
            break;
            
        case 9:
            return self.delegate.questionario.quadri;
            break;
            
        case 10:
            return self.delegate.questionario.mobili;
            break;
            
        case 11:
            return self.delegate.questionario.rumore;
            break;
            
        case 12:
            return self.delegate.questionario.inizioRumore;
            break;
            
        case 13:
            return self.delegate.questionario.provenienzaRumore;
            break;
            
        case 14:
            return self.delegate.questionario.piscine;
            break;
            
        case 15:
            return self.delegate.questionario.piante;
            break;
            
        case 16:
            return self.delegate.questionario.danni;
            break;
            
        case 17:
            return self.delegate.questionario.struttura;
            break;
            
        case 18:
            return self.delegate.questionario.muri;
            break;
            
        case 19:
            return self.delegate.questionario.tegole;
            break;
            
        case 20:
            return self.delegate.questionario.camini;
            break;
            
        default:
            NSLog(@"Invalid tag.");
            return Nil;
    }
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {
    [self performSwitchedSegueWithSender:sender];
}

- (void) performSwitchedSegueWithSender:(id)sender {
    switch (self.view.tag) {
        case -1:
            if (self.delegate.questionario.whereDetail.integerValue == 1) {  // Se si trova in un mezzo di trasporto
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle: @"Proseguendo non si potranno più modificare le risposte inserite. Vuoi continuare?"
                                              delegate: self
                                              cancelButtonTitle: @"Annulla"
                                              destructiveButtonTitle: nil
                                              otherButtonTitles: @"Si", nil];
                [actionSheet showInView:self.view];
            } else {
                [self performSegueWithIdentifier:@"coEffectSegue" sender:sender];
            }
            break;
            
        case 1:
            [self performSegueWithIdentifier:@"coEquilibroSegue" sender:sender];
            break;
            
        case 2:
            [self performSegueWithIdentifier:@"coAnimaliSegue" sender:sender];
            break;
            
        case 3:
            //            Se si era in un edificio:
            if (self.delegate.questionario.whereDetail.integerValue == 0) {
                [self performSegueWithIdentifier:@"coLampadariSegue" sender:sender];
            } else {
                [self performSegueWithIdentifier:@"coPiscineSegue" sender:sender];
            }
            break;
            
        case 4:
            [self performSegueWithIdentifier:@"coPorcellaneSegue" sender:sender];
            break;
            
        case 5:
            [self performSegueWithIdentifier:@"coSoprammobiliSegue" sender:sender];
            break;
            
        case 6:
            [self performSegueWithIdentifier:@"coFinestreSegue" sender:sender];
            break;
            
        case 7:
            [self performSegueWithIdentifier:@"coLiquidiSegue" sender:sender];
            break;
            
        case 8:
            [self performSegueWithIdentifier:@"coQuadriSegue" sender:sender];
            break;
            
        case 9:
            [self performSegueWithIdentifier:@"coMobiliSegue" sender:sender];
            break;
            
        case 10:
            [self performSegueWithIdentifier:@"coRumoreDaEdificioSegue" sender:sender];
            break;
            
        case 11:
            [self performSegueWithIdentifier:@"coInizioRumoreSegue" sender:sender];
            break;
            
        case 12:
            [self performSegueWithIdentifier:@"coProvenienzaRumoreSegue" sender:sender];
            break;
            
        case 13:
            [self performSegueWithIdentifier:@"coAltriFenomeniSegue" sender:sender];
            break;
            
        case 14:
            [self performSegueWithIdentifier:@"coPianteSegue" sender:sender];
            break;
            
        case 15:
            [self performSegueWithIdentifier:@"coRumoreDaApertoSegue" sender:sender];
            break;
            
        case 16:
            [self performSegueWithIdentifier:@"coMaterialeSegue" sender:sender];
            break;
            
        case 17:
            [self performSegueWithIdentifier:@"coMuriSegue" sender:sender];
            break;

        case 18:
            [self performSegueWithIdentifier:@"coTegoleSegue" sender:sender];
            break;
            
        case 19:
            [self performSegueWithIdentifier:@"coCaminiSegue" sender:sender];
            break;
            
        case 20:
            if (TRUE) {  // switch bug!
                UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                              initWithTitle: @"Proseguendo non si potranno più modificare le risposte inserite. Vuoi continuare?"
                                              delegate: self
                                              cancelButtonTitle: @"Annulla"
                                              destructiveButtonTitle: nil
                                              otherButtonTitles: @"Si", nil];
                [actionSheet showInView:self.view];
                [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForItem:self.delegate.questionario.camini.integerValue inSection:0] animated:TRUE];
            }
            break;

        default:
            break;
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* buttonName = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonName isEqualToString:@"Si"]) {
        if (self.view.tag == -1) {
            [self performSegueWithIdentifier:@"coEndThanksSegue" sender:self];
        } else {
            [self performSegueWithIdentifier:@"coThanksSegue" sender:self];
        }
    }
}

- (void) markCellForSelection:(UITableViewCell *)cell {
    
    for (UITableViewCell *c in self.cells) {
        c.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.nextBarButton.enabled = YES;
}

- (void) updateView {
    if (self.choosenValue != nil) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:[self.choosenValue integerValue] inSection:0]];
        [self markCellForSelection:cell];
        self.nextBarButton.enabled = YES;
    } else {
        [self markCellForSelection:nil];
        self.nextBarButton.enabled = NO;
    }
    [self upgradeBar];

}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self markCellForSelection:cell];
    self.choosenValue = [NSNumber numberWithInt:indexPath.row];

    [self performSwitchedSegueWithSender:cell];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.view.tag == -1 || self.view.tag == 20) {
        if (self.delegate.questionario.whereDetail.integerValue == 1) {
            self.nextBarButton.title = @"Fine";
        }
    } else {
        self.nextBarButton.title = @"Avanti";
    }
    
    if (self.view.tag == 1 && self.resume) {
//        TODO: Inserire il metodo per ottenere la stringa di dettagli per un terremoto
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Questionario esteso" message:[NSString stringWithFormat:@"Stai compilando il questionario esteso per: %@.", [coStartingViewController detailsForTerremoto:self.delegate.questionario.terremotoID]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.resume = NO;
    }
    
    [self updateView];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* cqtvc = (coQuestionTVC *) segue.destinationViewController;
        cqtvc.delegate = self.delegate;
    }
}

#pragma mark - View
- (void) upgradeBar {
    switch (self.view.tag) {
        case 1:
            self.progressionBar.progress = 0;
            break;
            
        case 2:
            if (self.delegate.questionario.whereDetail.integerValue == 0){
                self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 1;
            } else {
                self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 1;
            }
            break;
            
        case 3:
            if (self.delegate.questionario.whereDetail.integerValue == 0){
                self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 2;
            } else {
                self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 2;
            }
            break;
            
        case 4:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 3;
            break;
            
        case 5:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 4;
            break;
            
        case 6:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 5;
            break;
            
        case 7:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 6;
            break;
            
        case 8:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 7;
            break;
            
        case 9:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 8;
            break;
            
        case 10:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 9;
            break;
            
        case 11:
            if (self.delegate.questionario.whereDetail.integerValue == 0){
                self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 10;
            } else {
                self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 5;
            }
            break;
            
        case 12:
            if (self.delegate.questionario.whereDetail.integerValue == 0){
                self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 11;
            } else {
                self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 6;
            }
            break;
            
        case 13:
            if (self.delegate.questionario.whereDetail.integerValue == 0){
                self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 12;
            } else {
                self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 7;
            }
            break;
            
        case 14:
            self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 3;
            break;
            
        case 15:
            self.progressionBar.progress = APERTO_QUESTION_PROGRESS * 4;
            break;
            
        case 16:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 14;
            break;
            
        case 17:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 15;
            break;
            
        case 18:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 16;
            break;
            
        case 19:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 17;
            break;
            
        case 20:
            self.progressionBar.progress = EDIFICIO_QUESTION_PROGRESS * 18;
            break;
            
        default:
            break;
    }

}

@end
