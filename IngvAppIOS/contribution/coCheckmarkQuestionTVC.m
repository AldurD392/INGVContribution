//
//  coCheckmarkQuestionTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coCheckmarkQuestionTVC.h"

@interface coCheckmarkQuestionTVC ()
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButton;
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *cells;

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
            
        default:
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
            
        default:
            NSLog(@"Invalid tag.");
            return Nil;
    }
}

- (IBAction)nextButtonPressed:(UIBarButtonItem *)sender {

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
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self markCellForSelection:cell];

    self.choosenValue = [NSNumber numberWithInt:indexPath.row];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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

@end
