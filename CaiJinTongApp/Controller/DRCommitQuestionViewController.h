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

@interface DRCommitQuestionViewController : BaseViewController<QuestionInfoInterfaceDelegate, UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *commitTimeLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleField;  //标题框
@property (weak, nonatomic) IBOutlet UITextView *contentField;  //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectTableBtn;
@property (weak, nonatomic) IBOutlet UITableView *selectTable;
@property (weak, nonatomic) IBOutlet UITableViewCell *selectTableCell;
@property (weak,nonatomic) id<DRCommitQuestionViewControllerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *questionArrSelSection;
@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;
@property (nonatomic, strong) NSMutableArray *questionList;
@property (nonatomic, assign) NSInteger questionTmpSection;
@property (nonatomic,strong) NSString *selectedQuestionId;
@property (weak, nonatomic) IBOutlet UILabel *selectedQuestionName;
- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;
- (IBAction)inputBegin:(id)sender;


@end

@protocol DRCommitQuestionViewControllerDelegate <NSObject>

-(void)commitQuestionController:(DRCommitQuestionViewController*)controller didCommitQuestionWithTitle:(NSString*)title andText:(NSString*)text andQuestionId:(NSString *)questionId;
-(void)commitQuestionControllerCancel;

@end