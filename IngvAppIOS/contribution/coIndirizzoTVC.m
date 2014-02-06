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

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.placeHolderArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"coBasicIndirizzoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = [self.dataDict objectForKey:[self.placeHolderArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController* nc = self.navigationController;
    coWhereTVC *ptvc = (coWhereTVC *)[nc parentViewController];
    
    [ptvc setRegion: [NSDictionary dictionaryWithObjects:@[[self.dataDict objectForKey:[self.placeHolderArray objectAtIndex:indexPath.row]]]
                                              forKeys:@[[self.placeHolderArray objectAtIndex:indexPath.row]]]];
    [self dismissViewControllerAnimated:TRUE completion:Nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
