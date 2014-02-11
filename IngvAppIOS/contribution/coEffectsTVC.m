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
        [self performSegueWithIdentifier:@"coPauraSegue" sender:self];
    }
    else if ([buttonName isEqualToString:@"No"]) {
        
    } else {
        
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 80;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[coQuestionTVC class]]) {
        coQuestionTVC* cqtvc = (coQuestionTVC *) segue.destinationViewController;
        cqtvc.delegate = self.delegate;
        
        cqtvc.delegate.questionario.effects = self.effectSlider.value;
    }
}

# pragma mark - ViewController Life Cycle
- (void) viewWillAppear:(BOOL)animated {
    if (self.delegate.questionario.effects) {
        self.effectSlider.value = self.delegate.questionario.effects;
    }
}

@end
