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
@property (strong, nonatomic) IBOutletCollection(UITableViewCell) NSArray *whatCells;
@end

@implementation coCheckmarkQuestionTVC

- (void) setChoosenValue:(NSInteger)choosenValue {
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

    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:choosenValue inSection:0]];
    
    [self markCellForSelection:cell];
}

- (NSInteger) choosenValue {
    
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
            return -1;
    }
}

- (void) markCellForSelection:(UITableViewCell *)cell {
    
    for (UITableViewCell *c in self.whatCells) {
        c.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    self.nextBarButton.enabled = YES;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [self markCellForSelection:cell];

    self.choosenValue = indexPath.row;
}

- (void) viewWillAppear:(BOOL)animated {
    [self markCellForSelection:[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:self.choosenValue inSection:0]]];
    NSLog(@"%d", self.choosenValue);
}

//
//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//
//    // Uncomment the following line to preserve selection between presentations.
//    // self.clearsSelectionOnViewWillAppear = NO;
// 
//    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//}
//
//- (void)didReceiveMemoryWarning
//{
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
//#pragma mark - Table view data source
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
//    // Configure the cell...
//    
//    return cell;
//}

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
