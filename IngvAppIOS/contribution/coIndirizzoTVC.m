//  coIndirizzoTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 06/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coIndirizzoTVC.h"
#import "coWhereTVC.h"

@interface coIndirizzoTVC ()
@property (strong, nonatomic) NSDictionary* dataDict;

@property (strong, nonatomic) NSArray* placeHolderArray;

@property (strong, nonatomic) NSArray* indexTitle;
@property (strong, nonatomic) NSArray* alphaPlaceHolderArray;
@property (strong, nonatomic) NSDictionary* alphaDict;

@end

@implementation coIndirizzoTVC

# pragma mark - Getters and setters
- (void) setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;

    self.placeHolderArray = [[NSArray alloc] initWithArray:
                             [_dataDict keysSortedByValueUsingComparator: ^(NSString* obj1, NSString* obj2) {
                                    return [obj1 caseInsensitiveCompare:obj2];
    }]];
    
    NSMutableDictionary *mutableDictionary = [[NSMutableDictionary alloc] init];
    for (NSString *string in [dataDict allValues]) {
        unichar c = [string characterAtIndex:0];
        NSString* charString = [NSString stringWithFormat:@"%c", c];
        
        if (![mutableDictionary objectForKey:charString]) {
            [mutableDictionary setObject:[NSMutableArray arrayWithObject:string] forKey:charString];
        } else {
            NSMutableArray *stringsArray = [mutableDictionary objectForKey:charString];
            [stringsArray addObject:string];
        }
    }
    
    self.alphaDict = [mutableDictionary copy];
}

- (void) setAlphaDict:(NSDictionary *)alphaDict {
    _alphaDict = alphaDict;
    

    NSMutableDictionary *mutableCopy = [_alphaDict mutableCopy];
    for (NSString *key in [mutableCopy allKeys]) {
        NSArray *array = [mutableCopy objectForKey:key];
        array = [array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
        [mutableCopy setObject:array forKey:key];
    }
    _alphaDict = [mutableCopy copy];
    
    self.alphaPlaceHolderArray = [[_alphaDict allKeys] sortedArrayUsingComparator:^(NSString* obj1, NSString* obj2)
                                        {
                                            return [obj1 caseInsensitiveCompare:obj2];
                                        }
                                  ];
}

- (NSArray *)indexTitle {
    if (!_indexTitle) {
        NSMutableArray* temporaryArray = [[NSMutableArray alloc] init];
        for (char a = 'A'; a <= 'Z'; a++) {
            [temporaryArray addObject:[NSString stringWithFormat:@"%c", a]];
        }
        
        _indexTitle = [temporaryArray copy];
    }
    
    return _indexTitle;
}

# pragma mark - File parsing

#define STATILIST @"coStatiList"
#define REGIONLIST @"coRegionList"
#define PROVINCELIST @"coProvinceList"
#define COMUNILIST @"coComuniList"

- (IBAction)didPressCancel:(UIBarButtonItem *)sender {
    self.dataDict = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loadCountries {
    NSString* countriesPath = [[NSBundle mainBundle] pathForResource:STATILIST ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:countriesPath];
    
    if (file == Nil) {
        NSLog(@"Error opening countries file.");
    }
    
    NSData* buffer = [file readDataToEndOfFile];
    NSString* bufferString = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    NSArray *splitString = [bufferString componentsSeparatedByCharactersInSet:cset];
    
    self.dataDict = [NSDictionary dictionaryWithObjects:splitString forKeys:splitString];
}

- (void) loadRegions {
    NSMutableDictionary* mutableDict = [[NSMutableDictionary alloc] init];
    
    NSString* regionsPath = [[NSBundle mainBundle] pathForResource:REGIONLIST ofType:@"txt"];
    NSFileHandle* file = [NSFileHandle fileHandleForReadingAtPath:regionsPath];
    
    if (file == Nil) {
        NSLog(@"Error opening region file.");
    }
    
    NSData* buffer = [file readDataToEndOfFile];
    NSString* bufferString = [[NSString alloc] initWithData:buffer encoding:NSUTF8StringEncoding];
    
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
    for (NSString *string in [bufferString componentsSeparatedByCharactersInSet:cset]) {
        NSCharacterSet *tabSet = [NSCharacterSet characterSetWithCharactersInString:@"\t"];
        NSArray* splitString = [string componentsSeparatedByCharactersInSet:tabSet];
        
        NSString* code = [splitString firstObject];
        NSString *region = [[splitString lastObject] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
        [mutableDict setValue:region forKey:code];
    }
    
    self.dataDict = [mutableDict copy];
}

- (void) loadProvince:(NSString *)regionCode {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
        
        NSString* provincePath = [[NSBundle mainBundle] pathForResource:PROVINCELIST ofType:@"txt"];

        //TODO: handle accents
        NSError *error;
        NSString *bufferString = [NSString stringWithContentsOfFile:provincePath encoding:NSISOLatin1StringEncoding error:&error];
        
        if (error != Nil) {
            NSLog(@"%@", [error description]);
        }
        
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
        for (NSString *string in [bufferString componentsSeparatedByCharactersInSet:cset]) {
            NSCharacterSet *tabSet = [NSCharacterSet characterSetWithCharactersInString:@"\t"];
            NSArray* splitString = [string componentsSeparatedByCharactersInSet:tabSet];
            
            if ([[splitString firstObject] isEqualToString:regionCode]) {
                NSString* code = [splitString objectAtIndex:1];
                NSString *provincia = [splitString objectAtIndex:2];
                                
                [returnDict setValue:provincia forKey:code];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.dataDict = [returnDict copy];
            [self.tableView reloadData];
        });
    });
}

- (void) loadComuni:(NSString *)provinciaCode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
        
        NSString* comuniPath = [[NSBundle mainBundle] pathForResource:COMUNILIST ofType:@"txt"];
        
        //TODO: handle accents
        NSError *error;
        NSString *bufferString = [NSString stringWithContentsOfFile:comuniPath encoding:NSISOLatin1StringEncoding error:&error];
        
        if (error != Nil) {
            NSLog(@"%@", [error description]);
        }
        
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"\n"];
        
        BOOL code = FALSE;
        for (NSString *string in [bufferString componentsSeparatedByCharactersInSet:cset]) {
            NSCharacterSet *tabSet = [NSCharacterSet characterSetWithCharactersInString:@"\t"];
            NSArray* splitString = [string componentsSeparatedByCharactersInSet:tabSet];
            
            if ([[splitString firstObject] isEqualToString:provinciaCode]) {
                code = TRUE;
                NSString *code = [splitString objectAtIndex:1];
                NSString *comune = [[splitString objectAtIndex:2] stringByTrimmingCharactersInSet:[NSCharacterSet newlineCharacterSet]];
                
                [returnDict setValue:comune forKey:code];
                
            } else if (code == TRUE) {
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.dataDict = [returnDict copy];
            [self.tableView reloadData];
        });
    });
}

- (void) loadFrazioni:(NSString *)comuneCode withRegionCode:(NSString*) regionCode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
        
        NSString* frazioniPath = [[NSBundle mainBundle] pathForResource:regionCode ofType:@"csv"];
        
        //TODO: handle accents
        NSError *error;
        NSString *bufferString = [NSString stringWithContentsOfFile:frazioniPath encoding:NSISOLatin1StringEncoding error:&error];
        
        if (error != Nil) {
            NSLog(@"%@", [error description]);
        }
        
        NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"\r"];
        
        BOOL code = FALSE;
        for (NSString *string in [bufferString componentsSeparatedByCharactersInSet:cset]) {
           
            NSCharacterSet *tabSet = [NSCharacterSet characterSetWithCharactersInString:@";"];
            NSArray* splitString = [string componentsSeparatedByCharactersInSet:tabSet];
            
            if ([[splitString firstObject] isEqualToString:comuneCode]) {
                code = TRUE;
                NSString *code = [splitString objectAtIndex:1];
                NSString *frazione = [splitString objectAtIndex:2];
                
                [returnDict setValue:frazione forKey:code];
                
            } else if (code == TRUE) {
                break;
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            self.dataDict = [returnDict copy];
            [self.tableView reloadData];
        });
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.alphaDict allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *characterString = [self.alphaPlaceHolderArray objectAtIndex:section];
    return [[self.alphaDict objectForKey:characterString] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"coBasicIndirizzoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSString *characterString = [self.alphaPlaceHolderArray objectAtIndex:indexPath.section];
    cell.textLabel.text = [[self.alphaDict objectForKey:characterString] objectAtIndex:indexPath.row];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *charString = [self.alphaPlaceHolderArray objectAtIndex:indexPath.section];
    
    NSString *selected = [[self.alphaDict objectForKey:charString] objectAtIndex:indexPath.row];
    NSString *selectedKey = [[self.dataDict allKeysForObject:selected] firstObject];
    
    [self.whereDelegate didFinishSelectingAddress:@{selectedKey: selected}];

    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self dismissViewControllerAnimated:YES completion:Nil];
    });
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.indexTitle;
}

- (NSInteger) tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([self.alphaDict objectForKey:title]) {
        return [self.alphaPlaceHolderArray indexOfObject:title];
    } else {
        return -1;
    }
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.alphaPlaceHolderArray objectAtIndex:section];
}

# pragma mark - UITableViewController LifeCycle

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
}

- (void) viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView setContentOffset:self.tableView.contentOffset animated:NO];
}

@end
