//
//  DRCommitQuestionViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "QuestionInfoInterface.h"
@protocol DRCommitQuestionViewControllerDelegate;
@interface DRCommitQuestionViewController : BaseViewController<QuestionInfoInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commitTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;  //标题框
@property (weak, nonatomic) IBOutlet UITextView *contentField;  //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak,nonatomic) id<DRCommitQuestionViewControllerDelegate> delegate;

@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;
@property (nonatomic, strong) NSMutableArray *questionList;
- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;

@end

@protocol DRCommitQuestionViewControllerDelegate <NSObject>

-(void)commitQuestionController:(DRCommitQuestionViewController*)controller didCommitQuestionWithTitle:(NSString*)title andText:(NSString*)text;
-(void)commitQuestionControllerCancel;

@end