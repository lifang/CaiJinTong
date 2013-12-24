//
//  DRCommitQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRCommitQuestionViewController.h"

static CGRect frame;
static CGRect tableFrame;
@interface DRCommitQuestionViewController ()

@end

@implementation DRCommitQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)keyBoardWillHide:(id)sender{
    CGRect selfRect = self.view.frame;
    self.view.frame = (CGRect){selfRect.origin.x,100,selfRect.size};
}

-(void)keyBoardWillShow:(id)sender{
    CGRect selfRect = self.view.frame;
    self.view.frame = (CGRect){selfRect.origin.x,10,selfRect.size};
}

-(void)popouViewFinishedFrameRect:(id)sender{
    [self.titleField becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentField.delegate = self;
    self.commitTimeLabel.text = [Utility getNowDateFromatAnDate];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    
    self.contentField.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentField.layer.borderWidth =1.0;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];

    frame = CGRectMake(6, 151, 41, 80);//按钮坐标
    tableFrame = CGRectMake(-229, 30, 235, 300);//table坐标
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)spaceAreaClicked:(id)sender {
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerCancel)]) {
        [self.delegate commitQuestionControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
   
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return;
    }
    
    if (!self.titleField.text || [[self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"标题不能为空"];
        return;
    }
     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionController:didCommitQuestionWithTitle:andText:andQuestionId:)]) {
        [self.delegate commitQuestionController:self didCommitQuestionWithTitle:self.titleField.text andText:self.contentField.text andQuestionId:self.selectedQuestionId];
    }
}

- (IBAction)inputBegin:(id)sender {

}

#pragma mark property
-(NSMutableArray *)questionArrSelSection{
    if (!_questionArrSelSection) {
        _questionArrSelSection = [NSMutableArray array];
    }
    return _questionArrSelSection;
}

#pragma mark textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

@end
