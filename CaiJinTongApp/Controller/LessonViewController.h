//
//  LessonViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChapterInfoInterface.h"
#import "SearchLessonInterface.h"
#import "QuestionInfoInterface.h"
#import "GetUserQuestionInterface.h"
#import "ChapterQuestionInterface.h"
#import "GetUserQuestionInterface.h"
#import "DRTreeTableView.h"
#import "LessonCategoryInterface.h"
#import "LessonListForCategory.h"
#import "MyQuestionCategatoryInterface.h"
#import "LearningMatarilasCategoryInterface.h"
#import "LearningMatarilasListInterface.h"
@interface LessonViewController : UIViewController<UISearchBarDelegate,ChapterInfoInterfaceDelegate,UITextFieldDelegate,SearchLessonInterfaceDelegate,QuestionInfoInterfaceDelegate,ChapterQuestionInterfaceDelegate,UIScrollViewDelegate,GetUserQuestionInterfaceDelegate,SearchQuestionInterfaceDelegate,UITextFieldDelegate,DRTreeTableViewDelegate,LessonCategoryInterfaceDelegate,LessonListForCategoryDelegate,MyQuestionCategatoryInterfaceDelegate,LearningMatarilasCategoryInterfaceDelegate,LearningMatarilasListInterfaceDelegate>

@property (nonatomic, strong) SearchLessonInterface *searchLessonInterface;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (weak, nonatomic) IBOutlet UIImageView *searchBarView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (nonatomic) BOOL isSearching; //标志某次动作是否为搜索动作
@property (weak, nonatomic) IBOutlet UIView *lessonListBackgroundView;
@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;//获取所有问答分类
@property (nonatomic, strong) MyQuestionCategatoryInterface *myQuestionCategatoryInterface;//获取我的提问分类
@property (nonatomic, strong) MyQuestionCategatoryInterface *myAnswerCategatoryInterface;//获取我的回答分类
@property (nonatomic, strong) ChapterInfoInterface *chapterInterface;
@property (strong,nonatomic) LessonCategoryInterface *lessonCategoryInterface;//获取课程分类
@property (strong,nonatomic) LessonListForCategory *lessonListForCategory;//根据分类获取课程列表
@property (weak, nonatomic) IBOutlet UIView *leftBackGroundview;
@property (weak, nonatomic) IBOutlet UIView *rightBackGroundview;
@property (weak, nonatomic) IBOutlet UIButton *lessonListBt;
@property (weak, nonatomic) IBOutlet UIButton *questionListBt;
@property (weak, nonatomic) IBOutlet UIButton *noteListBt;
@property (weak, nonatomic) IBOutlet UIButton *learningMaterailBt;
@property (weak, nonatomic) IBOutlet UILabel *lessonListTitleLabel;
- (IBAction)lessonListBtClicked:(id)sender;
- (IBAction)questionListBtClicked:(id)sender;
- (IBAction)SearchBrClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImageView;
@property (weak, nonatomic) IBOutlet UILabel *rightNameLabel;
@property (nonatomic, strong) NSMutableArray *lessonList;  //课程数据

@property (nonatomic, strong) NSDictionary *questionDictionary;
@property (nonatomic, strong) NSMutableArray *questionList;//所有问答
@property (nonatomic, strong) NSMutableArray *myQuestionList;//我的问答

@property (nonatomic, strong) ChapterQuestionInterface *chapterQuestionInterface;


@property (nonatomic, strong) NSMutableArray *tempMutableArray;//暂时保存数据
@end
