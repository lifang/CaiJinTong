//
//  Const.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//
//


typedef  enum  {//问答类型
    QuestionAndAnswerALL = 1,
    QuestionAndAnswerMYQUESTION,
    QuestionAndAnswerMYANSWER,
    QuestionAndAnswerSearchQuestion
} QuestionAndAnswerScope;

typedef enum {//追问类型
    ReaskType_Reask=100,//追问
    ReaskType_AnswerForReasking,//对追问进行回复
    ReaskType_ModifyReask,//修改追问
    ReaskType_ModifyAnswer,//对回复进行修改,
    ReaskType_None,
}ReaskType;

typedef enum {DownloadStatus_UnDownload,DownloadStatus_Downloading,DownloadStatus_Downloaded,DownloadStatus_Pause}DownloadStatus;

typedef enum {LearningMaterialsSortType_Default,LearningMaterialsSortType_Date,LearningMaterialsSortType_Name}LearningMaterialsSortType;

typedef enum {LESSONSORTTYPE_CurrentStudy,
    LESSONSORTTYPE_ProgressStudy,
    LESSONSORTTYPE_LessonName}LESSONSORTTYPE;//课程排序类型
#define POPOUCHANGEVIEWFRAME @"popouChangeViewFrame"
//#define kHost @"http://wmi.finance365.com/api/ios.ashx"
#define kImageHost @"http://lms.finance365.com"
#define kHost @"http://lms.finance365.com/api/ios.ashx"
//#define kSummitQuestHost  @"http://lms.finance365.com/api/ios.ashx"
//#define kQuestHost  kHost
#define kDomain @"http://116.255.135.175:3004"

#define kUsingTestData 0//使用json测试数据

#define kLogin @"/chapters/user_round"
#define kIndex @"/orders/index_list"
#define kSearchCar @"/orders/search_car"
#define kShowCar @"/orders/show_car"
#define kBrandProduct @"/orders/brands_products"
#define kFinish @"/orders/finish"
#define kDone @"/orders/add"
#define kComplaint @"/orders/complaint"
#define kConfirmReserv @"/orders/confirm_reservation"
#define kPay @"/orders/pay"
#define kSendCode @"/orders/send_code"
#define kRefresh @"/orders/refresh"
#define kPayOrder @"/orders/pay_order"
#define kcheckIn @"/orders/checkin"
#define kCustomerInfo @"/orders/search_by_car_num2"
#define ksync @"/orders/sync_orders_and_customer"
#define kwork_order @"/orders/work_order_finished"

#define MDKey @"c9302245-0cbe-475d-a009-a0d22aa06fbb"

//允许最长的字符
#define MAX_CONTENT_LENGTH  5000

#import "DRTreeTableView.h"
#import "TestModelData.h"
#import "LogInterface.h"//登录
#import "FindPassWordInterface.h"//找回密码
#import "LessonInfoInterface.h"//课程信息
#import "ChapterInfoInterface.h"//章节下视频信息
#import "SectionInfoInterface.h"//视频详细信息
#import "PlayVideoInterface.h"//播放视频
#import "PlayBackInterface.h"//播放返回
#import "GradeInterface.h"//打分或者评论
#import "CommentListInterface.h"//评论列表的分页加载
#import "SumitNoteInterface.h"//提交笔记
#import "SearchLessonInterface.h"//搜索课程
#import "QuestionInfoInterface.h"//问题信息
#import "QuestionListInterface.h"//问题的分页加载
#import "AnswerListInterface.h"//回答的分页加载
#import "AcceptAnswerInterface.h"//采纳答案
#import "ChapterQuestionInterface.h"//章节下问题
#import "AnswerPraiseInterface.h"//赞
#import "GetUserQuestionInterface.h"//我的提问或者我的回答
#import "SubmitAnswerInterface.h"//提交答案或者追问
#import "SearchQuestionInterface.h"//搜索问题
#import "AskQuestionInterface.h"//提交问题
#import "SuggestionInterface.h"//提交建议