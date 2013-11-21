//
//  DRAskQuestionViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNaviGationBarController.h"

@interface DRAskQuestionViewController : DRNaviGationBarController
@property (weak, nonatomic) IBOutlet UITextField *questionTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextField;

- (IBAction)keyboardFuckOff:(id)sender;
@end
