//
//  QuestionV2ViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionCellV2.h"
#import "AnswerForQuestionCellV2.h"
#import "LHLNavigationBarViewController.h"
#import "ChapterSearchBar_iPhone.h"
#import "DRTreeTableView.h"
#import "LHLAskQuestionViewController.h"
/** QuestionV2ViewController
 *
 * 问答界面显示，第二版本,iphone版本
 */
@interface QuestionV2ViewController : LHLNavigationBarViewController<UITableViewDataSource,UITableViewDelegate,QuestionCellV2Delegate,AnswerForQuestionCellV2Delegate,UIActionSheetDelegate,ChapterSearchBarDelegate_iPhone,LHLAskQuestionViewControllerDelegate,DRTreeTableViewDelegate,MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

///存放QuestionModel 和AnswerModel对象
@property (nonatomic,strong) NSMutableArray *questionDataArray;

///存放QuestionModel 和AnswerModel对象
@property (nonatomic,strong) NSMutableArray *questionSearchDataArray;

///重新加载问答数据，所需的分类id，分类类型在CaiJinTongManager单利中
-(void)reloadQuestionData;
@end
