//
//  SuggestionFeedbackViewController_iPhoneViewController.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "SuggestionFeedbackViewController_iPhone.h"

@interface SuggestionFeedbackViewController_iPhone ()
@property (weak, nonatomic) IBOutlet UITextField *placeholderTextField; //用来显示提示

@end

@implementation SuggestionFeedbackViewController_iPhone
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.lhlNavigationBar.title.text = @"意见反馈";
    
    self.backgroundForTextView.frame = self.contentTextView.frame;
    self.backgroundForTextView.borderStyle = UITextBorderStyleRoundedRect;
    [self.backgroundForTextView setEnabled:NO];
    
    self.placeholderTextField.frame = (CGRect){self.backgroundForTextView.frame.origin,280,30};
    self.placeholderTextField.placeholder = @"请留下您的宝贵意见...";
    
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
    if (self.contentTextView.text.length == 0) {
        [Utility errorAlert:@"请输入您宝贵的意见"];
    }else {
        [self.contentTextView resignFirstResponder];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SuggestionInterface *suggestionInter = [[SuggestionInterface alloc]init];
            self.suggestionInterface = suggestionInter;
            self.suggestionInterface.delegate = self;
            [self.suggestionInterface getAskQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSuggestionContent:self.contentTextView.text];
        }
    }
    
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --

#pragma mark --
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.placeholderTextField.placeholder = nil;
    return YES;
}

#pragma mark --

#pragma mark --SuggestionInterfaceDelegate
-(void)getSuggestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        });
    });
}
-(void)getSuggestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

@end
