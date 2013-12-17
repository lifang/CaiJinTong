//
//  MyQuestionAndAnswerViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionAndAnswerCell_iPhone.h"
#import "QuestionAndAnswerCell_iPhoneHeaderView.h"
#import "DRAskQuestionViewController.h"
#import "LHLNavigationBarViewController.h"

#import "AcceptAnswerInterface.h"
#import "MJRefresh.h"

//typedef  enum  {
//    QuestionAndAnswerALL = 1,
//    QuestionAndAnswerMYQUESTION = 2,
//    QuestionAndAnswerMYANSWER = 3
//} QuestionAndAnswerScope;

@interface MyQuestionAndAnswerViewController_iPhone : LHLNavigationBarViewController<UITableViewDataSource,UITableViewDelegate,QuestionAndAnswerCell_iPhoneDelegate,QuestionAndAnswerCell_iPhoneHeaderViewDelegate,AcceptAnswerInterfaceDelegate,MJRefreshBaseViewDelegate,QuestionListInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBarImageView;

@property (nonatomic, strong) AcceptAnswerInterface *acceptAnswerInterface;
@property (assign,nonatomic) QuestionAndAnswerScope questionAndAnswerScope;
@property (assign, nonatomic) NSInteger question_pageIndex;
@property (assign, nonatomic) NSInteger question_pageCount;
@property (strong,nonatomic) NSString *chapterID;
- (IBAction)noticeHideBtnClick:(id)sender;
//scope :设置问题的范围，我的回答，我的提问，所有回答
-(void)reloadDataWithDataArray:(NSArray*)data  withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope;
@end
