//
//  LHLCommitQuestionViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "QuestionInfoInterface.h"
@protocol LHLCommitQuestionViewControllerDelegate;

@interface LHLCommitQuestionViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,DRTreeTableViewDelegate,QuestionInfoInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *titleField;  //标题框
@property (weak, nonatomic) IBOutlet UITextView *contentField;  //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak,nonatomic) id<LHLCommitQuestionViewControllerDelegate> delegate;

@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;
- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;

@end

@protocol LHLCommitQuestionViewControllerDelegate <NSObject>

-(void)commitQuestionController:(LHLCommitQuestionViewController*)controller didCommitQuestionWithTitle:(NSString*)title andText:(NSString*)text andQuestionId:(NSString *)questionId;
-(void)commitQuestionControllerCancel;

@end