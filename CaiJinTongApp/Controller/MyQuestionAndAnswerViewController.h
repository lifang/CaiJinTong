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

@interface MyQuestionAndAnswerViewController : DRNaviGationBarController<UITableViewDataSource,UITableViewDelegate,QuestionAndAnswerCellDelegate,QuestionAndAnswerCellHeaderViewDelegate,AcceptAnswerInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noticeBarView;
@property (weak, nonatomic) IBOutlet UIImageView *noticeBarImageView;

@property (nonatomic, strong) AcceptAnswerInterface *acceptAnswerInterface;

@property (assign, nonatomic) NSInteger question_pageIndex;
@property (assign, nonatomic) NSInteger question_pageCount;
@property (assign, nonatomic) NSInteger answer_pageIndex;
@property (assign, nonatomic) NSInteger answer_pageCount;

- (IBAction)noticeHideBtnClick:(id)sender;
-(void)reloadDataWithDataArray:(NSArray*)data;
@end
