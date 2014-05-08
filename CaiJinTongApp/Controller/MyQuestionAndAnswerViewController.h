//
//  MyQuestionAndAnswerViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionAndAnswerCell.h"
#import "QuestionAndAnswerCellHeaderView.h"
#import "DRAskQuestionViewController.h"

#import "AcceptAnswerInterface.h"
#import "MJRefresh.h"
@protocol MyQuestionAndAnswerViewControllerDelegate;
@interface MyQuestionAndAnswerViewController : DRNaviGationBarController<UITableViewDataSource,UITableViewDelegate,QuestionAndAnswerCellDelegate,QuestionAndAnswerCellHeaderViewDelegate,AcceptAnswerInterfaceDelegate,MJRefreshBaseViewDelegate,QuestionListInterfaceDelegate,GetUserQuestionInterfaceDelegate,SubmitAnswerInterfaceDelegate,AnswerPraiseInterfaceDelegate,DRAskQuestionViewControllerDelegate,SearchQuestionInterfaceDelegate,DRAttributeStringViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBarImageView;
@property (weak, nonatomic) IBOutlet UIButton *askQuestionButton;
@property (nonatomic,strong) NSMutableArray *myQuestionArr;
@property (nonatomic, strong) AcceptAnswerInterface *acceptAnswerInterface;
@property (assign,nonatomic) QuestionAndAnswerScope questionAndAnswerScope;
@property (assign, nonatomic) NSInteger question_pageIndex;
@property (assign, nonatomic) NSInteger question_pageCount;
@property (strong,nonatomic) NSString *chapterID;
//@property (strong,nonatomic) NSString *searchQuestionText;
@property (nonatomic,assign) BOOL isSearch;//判断是否是搜索
@property (weak,nonatomic) id<MyQuestionAndAnswerViewControllerDelegate> delegate;
@property (strong, nonatomic) id lessonViewController; 
- (IBAction)noticeHideBtnClick:(id)sender;
//scope :设置问题的范围，我的回答，我的提问，所有回答
-(void)reloadDataWithDataArray:(NSArray*)data  withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope isSearch:(BOOL)isSearch;
@end

@protocol MyQuestionAndAnswerViewControllerDelegate <NSObject>

-(void)myQuestionAndAnswerControllerAskQuestionFinished;

@end