//
//  SuggestionFeedbackViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-21.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SuggestionFeedbackViewController.h"

@interface SuggestionFeedbackViewController ()

@end

@implementation SuggestionFeedbackViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"意见反馈"];
    
    self.backgroundForTextView.frame = CGRectMake(20, 55, 360, 181);
    self.backgroundForTextView.borderStyle = UITextBorderStyleRoundedRect;
    [self.backgroundForTextView setEnabled:NO];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.submitButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.cancelButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.submitButton setTitleColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)keyboardFuckOff:(id)sender {
    [self.contentTextView resignFirstResponder];
}

- (IBAction)cancelButtonClicked:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitButtonClicked:(UIButton *)sender {
}

#pragma mark keybord movings

@end
