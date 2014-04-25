//
//  CaiJinTongManager.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserModel.h"
#import "LessonModel.h"
@interface CaiJinTongManager : NSObject
{
    BOOL _free;
    BOOL _holding;
}

@property (nonatomic, strong) NSString * userId;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *question;//过时
@property (nonatomic, strong) NSArray *questionCategoryArr;//问答分类信息
@property (nonatomic, assign) int tagOfBtn;
@property (nonatomic, assign) CGFloat defaultPortraitTopInset;
@property (nonatomic, assign) CGFloat defaultWidth;
@property (nonatomic, assign) CGFloat defaultHeight;
@property (nonatomic, assign) CGFloat defaultLeftInset;
@property (nonatomic, assign) BOOL isLoadLargeImage;//是否加载图片
///服务器最新版本
@property (nonatomic, strong)  NSString *appstoreNewVersion;

///要加载的问答分类
@property (nonatomic, strong) NSString *selectedQuestionCategoryId;
///选中的问答分类类型
@property (assign,nonatomic) CategoryType selectedQuestionCategoryType;

///共享的lessonModel
@property (nonatomic, strong) LessonModel *lesson;
///是否显示本地保存数据
@property (nonatomic, assign) BOOL isShowLocalData;

///yes:显示本地的课程信息，NO：显示本地的资料信息
@property (nonatomic, assign) BOOL isShowLocalLessonData;

#pragma mark 问答操作
///问答所在的行
@property (nonatomic,strong) NSIndexPath *path;
///要操作的问题,只有当 reaskType ＝ ReaskType_Answer 才有意义
@property (nonatomic,strong) QuestionModel *questionModel;
///要操作的回答,只有当 reaskType ！＝ ReaskType_Answer 才有意义
@property (nonatomic,strong) AnswerModel *answerModel;
///回复的类型
@property (nonatomic,assign) ReaskType reaskType;
#pragma mark --
+ (CaiJinTongManager *)shared;

/** hold the thread when background task will terminate */
- (void)hold;

/** free from holding when applicaiton become active */
- (void)stop;

/** running in background, call this funciton when application become background */
- (void)run;

+(NSString*)getMovieLocalPathWithSectionID:(NSString*)sectionID;
+(NSString*)getMovieLocalTempPathWithSectionID:(NSString*)sectionID;
@end
