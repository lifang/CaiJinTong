//
//  SuggestionFeedbackViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-21.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SuggestionFeedbackViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *backgroundForTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;//文本输入框

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;  //返回按钮
@property (weak, nonatomic) IBOutlet UIButton *submitButton;  //提交按钮
- (IBAction)keyboardFuckOff:(id)sender;
- (IBAction)cancelButtonClicked:(UIButton *)sender;
- (IBAction)submitButtonClicked:(UIButton *)sender;


@end
