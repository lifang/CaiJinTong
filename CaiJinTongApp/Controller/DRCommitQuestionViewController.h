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
/*
 提问题
 */
@protocol DRCommitQuestionViewControllerDelegate;

@interface DRCommitQuestionViewController : BaseViewController<UITextFieldDelegate,UITextViewDelegate,AskQuestionInterfaceDelegate,DRTreeTableViewDelegate,QuestionInfoInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commitTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;  //标题框
@property (weak, nonatomic) IBOutlet UITextView *contentField;  //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong,nonatomic) UIImage *cutImage;
@property (weak,nonatomic) id<DRCommitQuestionViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *dropDownBt;
@property (nonatomic, strong) NSMutableArray *questionCategoryList;
@property (nonatomic, strong) AskQuestionInterface *askQuestionInterface;
@property (nonatomic,strong) NSString *selectedQuestionCategoryId;

- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;
- (IBAction)inputBegin:(id)sender;
- (IBAction)dropDownMenuBtClicked:(id)sender;

@end

@protocol DRCommitQuestionViewControllerDelegate <NSObject>

-(void)commitQuestionController:(DRCommitQuestionViewController*)controller didCommitQuestionWithTitle:(NSString*)title andText:(NSString*)text andQuestionId:(NSString *)questionId;
-(void)commitQuestionControllerCancel;
@end