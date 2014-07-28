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
@property (weak, nonatomic) IBOutlet UIButton *screenShotBtn;
@property (weak,nonatomic) id<LHLCommitQuestionViewControllerDelegate> delegate;

@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;
- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *categoryTextField;
/**
 是否开始剪切
 */
@property (assign,nonatomic) BOOL isCut;
@property (strong,nonatomic) UIImage *cutImage;
@property (strong,nonatomic) NSString *selectedQuestionId;//问题分类id
@end

@protocol LHLCommitQuestionViewControllerDelegate <NSObject>

-(void)commitQuestionController:(LHLCommitQuestionViewController*)controller didCommitQuestionWithTitle:(NSString*)title andText:(NSString*)text andQuestionId:(NSString *)questionId;
-(void)commitQuestionControllerCancel;
/**
 开始截屏
 */
-(void)commitQuestionControllerDidStartCutScreenButtonClicked:(LHLCommitQuestionViewController *)controller isCut:(BOOL)isCut;
@end