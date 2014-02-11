//
//  coWhereTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 22/01/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coWhereTVC.h"
#import "coIndirizzoTVC.h"
#import "coWhereLocation.h"
#import <CoreLocation/CoreLocation.h>

typedef enum tipoIndirizzo {
    regione = 1,
    provincia,
    comuni,
    frazione
} tipoIndirizzo;

@interface coWhereTVC () <coIndirizzoTVCDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *currentPositionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *viaTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property tipoIndirizzo tipoIndirizzo;

@property (strong, nonatomic) coWhereLocation *location;
@property (strong, nonatomic) CLLocationManager* locationManager;
@end

@implementation coWhereTVC

# pragma mark - Setters and getters
- (coWhereLocation *) location {
    if (self.delegate.questionario.where == Nil) {
        self.delegate.questionario.where = [[coWhereLocation alloc] init];
    }
    
    return self.delegate.questionario.where;
}

- (CLLocationManager *) locationManager {
    if (_locationManager == Nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
    }
    return _locationManager;
}

- (void) setRegion:(NSDictionary *)region {
    self.location.regione = region;
    self.provincia = Nil;
    
    [self reloadTableView];
}

- (NSDictionary *) region {
    return self.location.regione;
}

- (void) setProvincia:(NSDictionary *)provincia {
    self.location.provincia = provincia;
    self.comune = Nil;
    
    [self reloadTableView];
}

- (NSDictionary *) provincia {
    return self.location.provincia;
}

- (void) setComune:(NSDictionary *)comune {
    self.location.comune = comune;
    
    self.frazione = Nil;
    self.viaTextField.text = Nil;
    
    [self reloadTableView];
}

- (NSDictionary *) comune {
    return self.location.comune;
}

- (void) setFrazione:(NSDictionary *)frazione {
    self.location.frazione = frazione;
    
    [self reloadTableView];
}

- (NSDictionary *) frazione {
    return self.location.frazione;
}

- (void) setVia:(NSString *)via {
    self.location.via = via;
    
    [self reloadTableView];
}

- (NSString *) via {
    return self.location.via;
}

# pragma mark - Location methods
- (CLLocationCoordinate2D) getLocation {
    [self.locationManager startUpdatingLocation];
    CLLocation *location = [self.locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //    Take the last updated location, and put it in the location object.
    self.location.coordinate = [[locations lastObject] coordinate];
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    //    TODO!
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
        self.location.coordinate = [self getLocation];
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
    // Quando l'utente preme "Fatto" sulla tastiera, può andare avanti.
    if ([sender isEqual:self.viaTextField]) {
        self.nextBarButtonItem.enabled = TRUE;
        self.via = sender.text;
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

- (void) reloadTableView {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
    cell.detailTextLabel.text = [[self.region allValues] firstObject];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.hidden = NO;
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]];
    cell.detailTextLabel.text = [[self.provincia allValues] firstObject];
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    if (self.provincia != Nil) {
        cell.hidden = NO;
    } else {
        cell.hidden = YES;
    }
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]];
    cell.detailTextLabel.text = [[self.comune allValues] firstObject];
    
    if (self.comune != Nil) {
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
    
    cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:1]];
    cell.detailTextLabel.text = [[self.frazione allValues] firstObject];
    
    self.viaTextField.text = self.via;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* qtvc = (coQuestionTVC *) [segue destinationViewController];
        qtvc.delegate = self.delegate;
    }
    
    if ([segue.identifier isEqualToString:@"coRegioneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Regione"];
        
        dvc.whereDelegate = self;
        self.tipoIndirizzo = regione;
        [dvc loadRegions];
        
    } else if ([segue.identifier isEqualToString:@"coProvinciaSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Provincia"];
        
        dvc.whereDelegate = self;
        self.tipoIndirizzo = provincia;
        [dvc loadProvince:[[self.region allKeys] firstObject]];
        
    } else if ([segue.identifier isEqualToString:@"coComuneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Comune"];
        
        dvc.whereDelegate = self;
        self.tipoIndirizzo = comuni;
        [dvc loadComuni:[[self.provincia allKeys] firstObject]];
        
    } else if ([segue.identifier isEqualToString:@"coFrazioneSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Frazione"];
        
        dvc.whereDelegate = self;
        self.tipoIndirizzo = frazione;
        [dvc loadFrazioni:[[self.comune allKeys] firstObject] withRegionCode:[[self.region allKeys] firstObject]];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.delegate.questionario.where != Nil) {     
        self.nextBarButtonItem.enabled = YES;

        [self reloadTableView];
    }
}

@end
