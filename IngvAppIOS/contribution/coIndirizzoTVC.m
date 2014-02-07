//
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

@end

@implementation coIndirizzoTVC

# pragma mark - Getters and setters
- (void) setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;

    self.placeHolderArray = [[NSArray alloc] initWithArray:
                             [_dataDict keysSortedByValueUsingComparator: ^(NSString* obj1, NSString* obj2) {
                                    return [obj1 caseInsensitiveCompare:obj2];
    }]];
}

# pragma mark - File parsing

#define REGIONLIST @"coRegionList"
#define PROVINCELIST @"coProvinceList"
#define COMUNILIST @"coComuniList"

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
        });
    });
}

- (void) loadComuni:(NSString *)provinciaCode {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
        
        NSString* provincePath = [[NSBundle mainBundle] pathForResource:COMUNILIST ofType:@"txt"];
        
        //TODO: handle accents
        NSError *error;
        NSString *bufferString = [NSString stringWithContentsOfFile:provincePath encoding:NSISOLatin1StringEncoding error:&error];
        
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

- (void) loadFrazioni:(NSString *)comuneCode {
    //TODO
    self.dataDict = @{@"A" : @"Acilia"};
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.placeHolderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"coBasicIndirizzoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.dataDict objectForKey:[self.placeHolderArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *object = @[[self.dataDict objectForKey:[self.placeHolderArray objectAtIndex:indexPath.row]]];
    NSArray *key = @[[self.placeHolderArray objectAtIndex:indexPath.row]];
    [self.delegate didFinishSelectingAddress:[NSDictionary dictionaryWithObjects:object forKeys:key]];
    
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

@end
