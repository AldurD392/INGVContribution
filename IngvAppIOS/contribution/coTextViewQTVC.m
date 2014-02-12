//
//  coTextViewQTVC.m
//  Project
//
//  Created by Adriano Di Luzio on 12/02/14.
//  Copyright (c) 2014 Swipe Stack Ltd. All rights reserved.
//

#import "coTextViewQTVC.h"

@interface coTextViewQTVC ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextBarButtonItem;

@property (strong, nonatomic) NSString* altriFenomeni;
@property (strong, readonly) NSString* placeHolder;
@end

@implementation coTextViewQTVC

# pragma mark - Setters & Getters
- (void) setAltriFenomeni:(NSString *)altriFenomeni {
    self.delegate.questionario.altriFenomeni = altriFenomeni;
}

- (NSString *)altriFenomeni {
    return self.delegate.questionario.altriFenomeni;
}

- (NSString *)placeHolder {
    return @"Scrivi qui...";
}

# pragma mark - Notification handler
- (void) textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:self.placeHolder]) {
        self.textView.text = nil;
        self.textView.textColor = [UIColor blackColor];
    } else {
        [self performSelector:@selector(selectAllTextInTextView:) withObject:textView afterDelay:0.01f];
    }
}

- (void) selectAllTextInTextView: (UITextView *)textView {
    UITextRange* range = [self.textView textRangeFromPosition:self.textView.beginningOfDocument
                                                   toPosition:self.textView.endOfDocument];
    [self.textView setSelectedTextRange:range];
}

- (void) textViewDidChange:(UITextView *)textView {
    self.altriFenomeni = self.textView.text;
}

# pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {
    self.altriFenomeni = self.textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    // Any new character added is passed in as the "text" parameter
    if ([text isEqualToString:@"\n"]) {
        // Be sure to test for equality using the "isEqualToString" message
        [textView resignFirstResponder];
        
        // Return FALSE so that the final '\n' character doesn't get added
        return FALSE;
    }
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.textView.delegate = self;
}

@end
