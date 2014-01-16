//
//  LHLAskQuestionViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLNavigationBarViewController.h"

#import "AskQuestionInterface.h"
@protocol LHLAskQuestionViewControllerDelegate;
@interface LHLAskQuestionViewController : LHLNavigationBarViewController<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate,AskQuestionInterfaceDelegate,QuestionInfoInterfaceDelegate,UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet  UITextField *questionTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITextField *backgroundTextField;
@property (weak, nonatomic) IBOutlet UITableView *selectTable;
@property (weak, nonatomic) IBOutlet UIButton *selectTableBtn;
@property (weak, nonatomic) IBOutlet UITableViewCell *selectTableCell;
@property (nonatomic, strong) NSMutableArray *questionList;
@property (weak,nonatomic) id<LHLAskQuestionViewControllerDelegate> delegate;

@property (nonatomic,strong) NSMutableArray *questionArrSelSection;
@property (nonatomic,strong) NSString *selectedQuestionId;
@property (weak, nonatomic) IBOutlet UILabel *selectedQuestionName;
@property (nonatomic, assign) NSInteger questionTmpSection;

@property (nonatomic, strong) AskQuestionInterface *askQuestionInterface;
- (IBAction)keyboardFuckOff:(id)sender;
- (IBAction)inputBegin:(id)sender;
@end

@protocol LHLAskQuestionViewControllerDelegate <NSObject>

-(void)askQuestionViewControllerDidAskingSuccess:(LHLAskQuestionViewController*)controller;

@end