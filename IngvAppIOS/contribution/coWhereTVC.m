//
//  coWhereTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 22/01/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhereTVC.h"
#import "coIndirizzoTVC.h"

typedef enum tipoIndirizzo {
    regione = 1,
    provincia,
    comuni,
    frazione
} tipoIndirizzo;

@interface coWhereTVC () <coIndirizzoTVCDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *currentPositionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *viaTextField;
@property (weak, nonatomic) IBOutlet UIView *dettagliTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property tipoIndirizzo tipoIndirizzo;
@end

@implementation coWhereTVC

# pragma mark - Setters and getters
- (void) setRegion:(NSDictionary *)region {
    _region = region;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = [[_region allValues] firstObject];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.hidden = NO;
    
    self.provincia = Nil;
}

- (void) setProvincia:(NSDictionary *)provincia {
    _provincia = provincia;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.detailTextLabel.text = [[_provincia allValues] firstObject];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (_provincia != Nil) {
        cell.hidden = NO;
    } else {
        cell.hidden = YES;
    }
    self.comune = Nil;
}

- (void) setComune:(NSDictionary *)comune {
    _comune = comune;
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.detailTextLabel.text = [[_comune allValues] firstObject];
    
    if (_comune != Nil) {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        cell.hidden = NO;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
        cell.hidden = NO;
    } else {
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
        cell.hidden = YES;
        
        cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:1]];
        cell.hidden = YES;
    }
    
    self.frazione = Nil;
    self.viaTextField.text = Nil;
}

- (void) setFrazione:(NSDictionary *)frazione {
    _frazione = frazione;
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
    cell.detailTextLabel.text = [[_frazione allValues] firstObject];
}

# pragma mark - coIndirizzoTVC Delegate Methods
- (void)didFinishSelectingAddress:(NSDictionary *)dataDictionary {
    if (self.tipoIndirizzo == regione) {
        self.region = dataDictionary;
    } else if (self.tipoIndirizzo == provincia) {
        self.provincia = dataDictionary;
    } else if (self.tipoIndirizzo == comuni) {
        self.comune = dataDictionary;
    } else if (self.tipoIndirizzo == frazione) {
        self.frazione = dataDictionary;
    }
}

# pragma mark - IBActions
- (IBAction)currestPositionSwitchDidChanged:(UISwitch *)sender {
    if ([sender isOn]) {
        self.nextBarButtonItem.enabled = TRUE;
    } else {
        self.nextBarButtonItem.enabled = FALSE;
    }
    
    //Put this code where you want to reload your table view
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView transitionWithView:self.tableView
                          duration:0.1f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^(void) {
                            [self.tableView reloadData];
                        } completion:NULL];
    });
}

- (IBAction)didEndOnExitEnteringDetail:(UITextField *)sender {
    // Quando l'utente preme "Fatto" sulla tastiera, viene mostrato il dettaglio.
    if ([sender isEqual:self.viaTextField]) {
        self.nextBarButtonItem.enabled = TRUE;
    } else {
        
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.currentPositionSwitch isOn]) {
        return 1;
    } else {
        return 2;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"coRegioneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Regione"];
        
        dvc.delegate = self;
        self.tipoIndirizzo = regione;
        [dvc loadRegions];
    } else if ([segue.identifier isEqualToString:@"coProvinciaSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Provincia"];
        
        dvc.delegate = self;
        self.tipoIndirizzo = provincia;
        [dvc loadProvince:[[self.region allKeys] firstObject]];
    } else if ([segue.identifier isEqualToString:@"coComuneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Comune"];
        
        dvc.delegate = self;
        self.tipoIndirizzo = comuni;
        [dvc loadComuni:[[self.provincia allKeys] firstObject]];
    } else if ([segue.identifier isEqualToString:@"coFrazioneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Frazione"];
        
        dvc.delegate = self;
        self.tipoIndirizzo = frazione;
        [dvc loadFrazioni:[[self.comune allKeys] firstObject] withRegionCode:[[self.region allKeys] firstObject]];
    }
}

@end
