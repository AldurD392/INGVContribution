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
#import "coQuestionario.h"
#import "coStartingViewController.h"
#import <CoreLocation/CoreLocation.h>

typedef enum tipoIndirizzo {
    stato = 1,
    regione,
    provincia,
    comuni,
    frazione
} tipoIndirizzo;

@interface coWhereTVC () <coIndirizzoTVCDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UISwitch *currentPositionSwitch;
@property (weak, nonatomic) IBOutlet UITextField *viaTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;
@property tipoIndirizzo tipoIndirizzo;

@property (weak, nonatomic) IBOutlet UITableViewCell *statoCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *regioneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *provinciaCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *comuneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *frazioneCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *viaCell;
@property (weak, nonatomic) IBOutlet UILabel *viaLabel;

@property (weak, nonatomic) IBOutlet UITableViewCell *internationalAddressCell;
@property (weak, nonatomic) IBOutlet UITextField *internationalAddressTextField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *internationalAddressActivityIndicator;

@property (nonatomic) BOOL international;
@property (strong, nonatomic) NSMutableDictionary *where;
@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSError* locationError;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *locationActivityIndicator;

@property (strong, nonatomic) NSString *stato;
@property (strong, nonatomic) NSDictionary *region;
@property (strong, nonatomic) NSDictionary *provincia;
@property (strong, nonatomic) NSDictionary *comune;
@property (strong, nonatomic) NSDictionary *frazione;
@property (strong, nonatomic) NSString *via;
@property (strong, nonatomic) NSString *temporaryVia;
@end

@implementation coWhereTVC

# pragma mark - Setters and getters
- (NSMutableDictionary *) where {
    if (self.delegate.questionario.where == Nil) {
        self.delegate.questionario.where = [[NSMutableDictionary alloc] init];
    }
    
    return self.delegate.questionario.where;
}

- (CLLocationManager *) locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        _locationManager.distanceFilter = 100;
    }
    return _locationManager;
}

- (void) setStato:(NSString *)stato {
    [self.where setValue:stato forKey:STATO_KEY];
    self.region = nil;
    
    self.international = ![stato isEqualToString:@"Italia"];
    
    [self reloadTableView];
}

- (NSString *) stato {
    if (!self.where[STATO_KEY]) {
        [self.where setValue:@"Italia" forKey:STATO_KEY];
    }
    return self.where[STATO_KEY];
}

- (void) setRegion:(NSDictionary *)region {
    [self.where setValue:region forKey:REGIONE_KEY];
    self.provincia = nil;
    
    [self reloadTableView];
}

- (NSDictionary *) region {
    return self.where[REGIONE_KEY];
}

- (void) setProvincia:(NSDictionary *)provincia {
    [self.where setValue:provincia forKey:PROVINCIA_KEY];
    self.comune = nil;
    
    [self reloadTableView];
}

- (NSDictionary *) provincia {
    return self.where[PROVINCIA_KEY];
}

- (void) setComune:(NSDictionary *)comune {
    [self.where setValue:comune forKey:COMUNE_KEY];
    
    self.frazione = nil;
    self.viaTextField.text = nil;
    
    [self reloadTableView];
}

- (NSDictionary *) comune {
    return self.where[COMUNE_KEY];
}

- (void) setFrazione:(NSDictionary *)frazione {
    [self.where setValue:frazione forKey:FRAZIONE_KEY];
    
    [self reloadTableView];
}

- (NSDictionary *) frazione {
    return self.where[FRAZIONE_KEY];
}

- (void) setVia:(NSString *)via {
    [self.where setValue:via forKey:VIA_KEY];
    
    [self reloadTableView];
}

- (NSString *) via {
    return self.where[VIA_KEY];
}

# pragma mark - Location methods
- (void) fillDictionaryFromCoordinate2D:(CLLocationCoordinate2D) coordinate {
    [self.where setValue:[NSNumber numberWithFloat:coordinate.latitude] forKey:LATITUDE_KEY];
    [self.where setValue:[NSNumber numberWithFloat:coordinate.longitude] forKey:LONGITUDE_KEY];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //    Take the last updated location, and put it in the location object.
    CLLocationCoordinate2D coordinate = [[locations lastObject] coordinate];
    [self fillDictionaryFromCoordinate2D:coordinate];
    
    self.nextBarButtonItem.enabled = YES;
    [self.locationActivityIndicator stopAnimating];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    self.locationError = error;
}

- (void)getCoordinatesFromAddress {
//    Try to get coordinate from italian addresses
    if (![self.currentPositionSwitch isOn]) {
        if ([self.stato isEqualToString:@"Italia"]) {
            NSString *address = [[NSString alloc] init];

            if (self.via != nil) {
                address = [address stringByAppendingString:[NSString stringWithFormat:@"%@, ", self.via]];
            }
            if (self.frazione != nil) {
                address = [address stringByAppendingString:[NSString stringWithFormat:@"%@, ", [[self.frazione allValues] firstObject]]];
            }
            address = [address stringByAppendingString:[NSString stringWithFormat:@"%@, %@, %@, %@", [[self.comune allValues] firstObject], [[self.provincia allValues] firstObject], [[self.region allValues] firstObject], self.stato]];
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:address inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    if (!placemarks) {
                        // TODO: Error handling
                        if (error.code == kCLErrorNetwork) {
                            NSLog(@"Maximum request exceded!");
                        }
                    } else {
                        CLPlacemark *lastObject = (CLPlacemark *)[placemarks lastObject];
                        [self fillDictionaryFromCoordinate2D:lastObject.location.coordinate];
                    }
                });
            }];
        }
    }
}

# pragma mark - coIndirizzoTVC Delegate Methods
- (void)didFinishSelectingAddress:(NSDictionary *)dataDictionary {
    if (self.tipoIndirizzo == stato) {
        self.stato = [[dataDictionary allValues] firstObject];
    } else if (self.tipoIndirizzo == regione) {
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
        [self.locationManager startUpdatingLocation];
        [self.locationActivityIndicator startAnimating];
        
        self.region = nil;
    } else {
        [self.locationActivityIndicator stopAnimating];
        self.locationManager.delegate = nil;
        [self.locationManager stopUpdatingLocation];
        self.nextBarButtonItem.enabled = NO;

        self.locationManager = nil;
        self.where = nil;
    }
    
    [self reloadTableView];
}

- (IBAction)viaTextFieldDidChange:(UITextField *)sender {
    self.temporaryVia = sender.text;
}

- (IBAction)didEndOnExitEnteringDetail:(UITextField *)sender {
    // Quando l'utente preme "Fatto" sulla tastiera, può andare avanti.
    self.temporaryVia = nil;
    self.via = sender.text;
    
    if (sender == self.internationalAddressTextField) {
        self.where = nil;
        self.nextBarButtonItem.enabled = NO;
        
        [self.internationalAddressActivityIndicator startAnimating];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        NSString *completeString = [self.internationalAddressTextField.text stringByAppendingString:[NSString stringWithFormat:@", %@", self.stato]];
        [geocoder geocodeAddressString:completeString inRegion:nil completionHandler:^(NSArray *placemarks, NSError *error) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                if (!placemarks) {
                    // TODO: Error handling
                    if (error.code == kCLErrorNetwork) {
                        NSLog(@"Maximum request exceded!");
                    }
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        CLPlacemark *lastObject = (CLPlacemark *)[placemarks lastObject];
                        [self fillDictionaryFromCoordinate2D:lastObject.location.coordinate];
                        self.nextBarButtonItem.enabled = YES;
                        [self.internationalAddressActivityIndicator stopAnimating];
                    });
                }
            });
        }];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.currentPositionSwitch isOn]) {
        return 1;
    } else {
        if (!self.international) {
            return 2;
        } else {
            return 3;
        }
    }
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    else if (section == 1) {
        if (self.international) {
            return 1;
        } else {
            return 6;
        }
    } else {
        return 1;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.comune) {
            return @"Nota: frazione e via sono opzionali.";
        } else {
            return nil;
        }
    } else if (section == 0) {
        return @"Scegli se utilizzare la posizione corrente.";
    } else if (section == 2) {
        if (self.international) {
            return @"Inserisci l'indirizzo come da segnaposto.";
        } else {
            return nil;
        }
    }
    else {
        return nil;
    }
}

- (void) reloadTableView {
    if (!self.currentPositionSwitch.isOn) {
        self.nextBarButtonItem.enabled = NO;
        
        self.statoCell.detailTextLabel.text = self.stato;
        
        if ([self.stato isEqualToString:@"Italia"]) {
            self.regioneCell.hidden = NO;
            self.regioneCell.detailTextLabel.text = [[self.region allValues] firstObject];
        } else {
            self.regioneCell.hidden = YES;
        }
        
        if (self.region != nil) {
            self.provinciaCell.hidden = NO;
        } else {
            self.provinciaCell.hidden = YES;
        }
        
        self.provinciaCell.detailTextLabel.text = [[self.provincia allValues] firstObject];
        
        if (self.provincia != nil) {
            self.comuneCell.hidden = NO;
        } else {
            self.comuneCell.hidden = YES;
        }
        
        self.comuneCell.detailTextLabel.text = [[self.comune allValues] firstObject];
        
        if (self.comune != nil) {
            self.nextBarButtonItem.enabled = YES;
            self.frazioneCell.hidden = NO;
            self.viaCell.hidden = NO;
        } else {
            self.frazioneCell.hidden = YES;
            self.viaCell.hidden = YES;
        }
        
        self.frazioneCell.detailTextLabel.text = [[self.frazione allValues] firstObject];
        self.viaTextField.text = self.via;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* qtvc = (coQuestionTVC *) [segue destinationViewController];
        qtvc.delegate = self.delegate;
        
        [self getCoordinatesFromAddress];
    }
    
    if ([segue.identifier isEqualToString:@"coStatoSegue"]) {
        UINavigationController *nc = segue.destinationViewController;
        coIndirizzoTVC *dvc = (coIndirizzoTVC *)[nc topViewController];
        [dvc setTitle:@"Stato"];
        
        dvc.whereDelegate = self;
        self.tipoIndirizzo = stato;
        [dvc loadCountries];
        
    } else if ([segue.identifier isEqualToString:@"coRegioneSegue"]) {
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
- (IBAction)didPressCancelButton:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.push) {
        //        TODO: Inserire il metodo per ottenere la stringa di dettagli per un terremoto
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Questionario" message:[NSString stringWithFormat:@"Stai compilando il questionario per: %@.", [coStartingViewController detailsForTerremoto:self.delegate.questionario.terremotoID]] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusRestricted) {
        self.currentPositionSwitch.enabled = NO;
    }
    
    if (self.delegate.questionario.whenDetail) {
        self.navigationItem.leftBarButtonItem = nil;
    }

    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    self.nextBarButtonItem.enabled = NO;
    
    self.locationManager = nil;
    self.where = nil;
    
    self.currentPositionSwitch.on = NO;
    
    [self reloadTableView];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if (self.temporaryVia) {
        self.via = self.temporaryVia;
        self.temporaryVia = nil;
    }
    [self.locationManager stopUpdatingLocation];
}

@end
