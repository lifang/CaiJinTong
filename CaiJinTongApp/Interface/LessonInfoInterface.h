//
//  LessonInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "LessonModel.h"
/*
 根据课程id返回课程信息
 */
@protocol LessonInfoInterfaceDelegate;

@interface LessonInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<LessonInfoInterfaceDelegate>delegate;
-(void)downloadLessonInfoWithLessonId:(NSString*)lessonId withUserId:(NSString*)userId;
@end

@protocol LessonInfoInterfaceDelegate <NSObject>

-(void)getLessonInfoDidFinished:(LessonModel*)lesson;
-(void)getLessonInfoDidFailed:(NSString *)errorMsg;

@end