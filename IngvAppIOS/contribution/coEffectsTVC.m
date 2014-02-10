//
//  coEffectsTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 10/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coEffectsTVC.h"


@interface coEffectsTVC () <UIActionSheetDelegate>
@property (weak, nonatomic) IBOutlet UISlider *effectSlider;
@property (weak, nonatomic) IBOutlet UITextView *effectsTextView;

@property (strong, nonatomic) NSArray *labelArray;

@end

@implementation coEffectsTVC

- (IBAction)sliderValueChanged:(UISlider *)sender {
    self.effectSlider.value = round(sender.value);
    
    self.effectsTextView.selectable = YES;
    self.effectsTextView.text = [self.labelArray objectAtIndex:sender.value];
    self.effectsTextView.selectable = NO;
}

-(void)viewDidLoad {
    [super viewDidLoad];

    self.labelArray = @[@"Nessun effetto.",
                        @"Vibrazione appena percettibile.",
                        @"Vibrazione leggera o moderata.",
                        @"Vibrazione forte, piccoli oggetti spostati o caduti.",
                        @"Scuotimento, caduta di oggetti, spostamento mobili, possibilità danni leggeri.",
                        @"Scuotimento molto forte, danni."];
    
    self.effectsTextView.selectable = YES;
    self.effectsTextView.text = [self.labelArray objectAtIndex:0];
    self.effectsTextView.selectable = NO;
}

- (IBAction)nextButtonTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"Vuoi compilare il questionario esteso?"
                                  delegate:self
                                  cancelButtonTitle:@"Indietro"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"Si",@"No",nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString* buttonName = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonName isEqualToString:@"Si"]) {
        [self performSegueWithIdentifier:@"coPauraEquilibrioSegue" sender:self];
    }
    else if ([buttonName isEqualToString:@"No"]) {
        
    } else {
        
    }
}


- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
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
