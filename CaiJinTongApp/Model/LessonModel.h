//
//  LessonModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonModel : NSObject

@property (nonatomic, strong) NSString *lessonId;//课程id
@property (nonatomic, strong) NSString *lessonName;//课程名称
@property (nonatomic, strong) NSString *lessonImageURL;//课程封面url
@property (nonatomic, strong) NSString *lessonStudyProgress;//用户对本课程学习进度
@property (nonatomic, strong) NSString *lessonDetailInfo;//课程详细介绍
@property (nonatomic, strong) NSString *lessonTeacherName;//课程讲师
@property (nonatomic, strong) NSString *lessonDuration;//课程时长
@property (nonatomic, strong) NSString *lessonStudyTime;//用户已经学习时间
@property (nonatomic, strong) NSString *lessonScore;//课程平均分
@property (nonatomic, strong) NSString *lessonIsScored;//当前用户是否已经打分
@property (nonatomic, strong) NSMutableArray *chapterList;//章列表
@property (nonatomic, strong) NSMutableArray *lessonCommentList;//评论列表
@end
