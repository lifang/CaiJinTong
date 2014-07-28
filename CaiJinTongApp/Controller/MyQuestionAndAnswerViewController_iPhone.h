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
#import "LHLAskQuestionViewController.h"
#import "LHLNavigationBarViewController.h"
#import "AcceptAnswerInterface.h"
#import "MJRefresh.h"
#import "ChapterSearchBar_iPhone.h"

@interface MyQuestionAndAnswerViewController_iPhone : LHLNavigationBarViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,QuestionAndAnswerCell_iPhoneDelegate,QuestionAndAnswerCell_iPhoneHeaderViewDelegate,AcceptAnswerInterfaceDelegate,LHLAskQuestionViewControllerDelegate,MJRefreshBaseViewDelegate,QuestionListInterfaceDelegate,GetUserQuestionInterfaceDelegate,LHLNavigationBarDelegate,DRTreeTableViewDelegate,QuestionInfoInterfaceDelegate,MyQuestionCategatoryInterfaceDelegate,SearchQuestionInterfaceDelegate,DRAttributeStringViewDelegate,ChapterSearchBarDelegate_iPhone>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBarImageView;

@property (nonatomic,strong)  AnswerPraiseInterface *answerPraiseinterface;//提交赞接口
@property (nonatomic, strong) AcceptAnswerInterface *acceptAnswerInterface;
@property (assign, nonatomic) NSInteger question_pageIndex;
@property (assign, nonatomic) NSInteger question_pageCount;
@property (strong,nonatomic) NSString *chapterID;
@property (nonatomic,assign) QuestionAndAnswerScope questionScope;//当前页面的问题类型
@property (strong,nonatomic) GetUserQuestionInterface *getUserQuestionInterface;
@property (nonatomic,assign) BOOL menuVisible;//菜单是否可见
@property (nonatomic,weak) id lhlTabBarController;
- (IBAction)noticeHideBtnClick:(id)sender;
//scope :设置问题的范围，我的回答，我的提问，所有回答
-(void)reloadDataWithDataArray:(NSArray*)data  withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope;
-(void)keyboardDismiss;
-(void)requestNewPageDataWithLastQuestionID:(NSString*)lastQuestionID;
@end
