//
//  MyAnswerListForQuestionViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionAndAnswerCell.h"
#import "QuestionAndAnswerCellHeaderView.h"
#import "DRAskQuestionViewController.h"

#import "AcceptAnswerInterface.h"
#import "MJRefresh.h"

//
//  MyQuestionAndAnswerViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

@interface MyAnswerListForQuestionViewController : DRNaviGationBarController<UITableViewDataSource,UITableViewDelegate,QuestionAndAnswerCellDelegate,QuestionAndAnswerCellHeaderViewDelegate,AcceptAnswerInterfaceDelegate,MJRefreshBaseViewDelegate,SubmitAnswerInterfaceDelegate,AnswerPraiseInterfaceDelegate,AnswerListInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBarImageView;
@property (nonatomic, strong) QuestionModel *questionModel;
@property (nonatomic, strong) AcceptAnswerInterface *acceptAnswerInterface;
@property (assign,nonatomic) QuestionAndAnswerScope questionAndAnswerScope;
- (IBAction)noticeHideBtnClick:(id)sender;
/*
 显示每个问题的所有答案，分页加载答案
 //scope :设置问题的范围，我的回答，我的提问，所有回答
 */

-(void)reloadMoreAnswerListForQuestion:(QuestionModel*)question withScope:(QuestionAndAnswerScope)scope;

@end
