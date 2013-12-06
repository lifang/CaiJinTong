//
//  MenuQuestionTableViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonListHeaderView_iPhone.h"
#import "LessonListCell.h"
typedef  enum  {
    QuestionAndAnswerALL = 1,
    QuestionAndAnswerMYQUESTION = 2,
    QuestionAndAnswerMYANSWER = 3
} QuestionAndAnswerScope;

@interface MenuQuestionTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LessonListHeaderView_iPhoneDelegate,ChapterQuestionInterfaceDelegate,QuestionInfoInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *questionList;
@property (strong, nonatomic) NSMutableArray *questionArrSelSection;
@property (strong, nonatomic) ChapterQuestionInterface *chapterQuestionInterface;
@property (nonatomic,strong) NSString *questionAndSwerRequestID;//请求问题列表ID
@property (nonatomic,assign) QuestionAndAnswerScope questionScope;
@property (nonatomic,assign) QuestionInfoInterface *questionInfoInterface;
@property (nonatomic, assign) NSInteger questionTmpSection;
@end
