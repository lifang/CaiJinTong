//
//  LHLCommitQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLCommitQuestionViewController.h"
static CGRect defaultFrame;
static BOOL subViewsMoved = NO;
@interface LHLCommitQuestionViewController ()

@end

@implementation LHLCommitQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentField.delegate = self;
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.titleField.frame = CGRectMake(49, 13,IP5(453, 373), 44);
    [self.titleField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    [self.contentField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    self.contentField.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.contentField.layer.borderWidth =0.6;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];
    
    //响应键盘出现/消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//键盘消失
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
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionController:didCommitQuestionWithTitle:andText:andQuestionId:)]) {
        [self.delegate commitQuestionController:self didCommitQuestionWithTitle:self.titleField.text andText:self.contentField.text andQuestionId:@"42"];//42为"综合问题"的分类编号
    }
}

#pragma mark 响应键盘出现/消失事件
- (void)keyboardWillShow:(NSNotification *)notification{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    [self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
}

//本view上移,view中所有控件上移
-(void) moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)animationDuration{
    [UIView animateWithDuration:animationDuration animations:^{
        defaultFrame = self.view.frame;
        [self.view setFrame:CGRectMake(29, 0, IP5(516, 435), 255)];
        if(self.contentField.isFirstResponder && !subViewsMoved){
            NSArray *subViews = [self.view subviews];
            for(UIView *child in subViews){
                CGRect frame = child.frame;
                if([child isKindOfClass:[UITextView class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 65, frame.size.width, 116)];
                }else if([child isKindOfClass:[UIButton class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 85, frame.size.width, frame.size.height)];
                }else{
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 65, frame.size.width, frame.size.height)];
                }
            }
            subViewsMoved = YES;
        }
    }];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [aValue getValue:&animationDuration];
    [UIView animateWithDuration:animationDuration animations:^{
        [self.view setFrame:defaultFrame];
        if(subViewsMoved){
            NSArray *subViews = [self.view subviews];
            for(UIView *child in subViews){
                CGRect frame = child.frame;
                if([child isKindOfClass:[UITextView class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y + 65, frame.size.width, 136)];
                }else if([child isKindOfClass:[UIButton class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y + 85, frame.size.width, frame.size.height)];
                }else{
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y + 65, frame.size.width, frame.size.height)];
                }
            }
            subViewsMoved = NO;
        }
    }];
}

#pragma mark --
#pragma mark TestView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [self moveInputBarWithKeyboardHeight:1 withDuration:0.5];
}
@end
