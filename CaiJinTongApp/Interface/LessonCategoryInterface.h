//
//  LessonCategoryInterface.h
//  CaiJinTongApp
//
//  Created by david on 13-12-24.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 加载课程分类信息
 */
@protocol LessonCategoryInterfaceDelegate;
@interface LessonCategoryInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<LessonCategoryInterfaceDelegate>delegate;
-(void)downloadLessonCategoryDataWithUserId:(NSString*)userId;
@end
@protocol LessonCategoryInterfaceDelegate <NSObject>
-(void)getLessonCategoryDataDidFinished:(NSArray*)categoryNotes;

-(void)getLessonCategoryDataFailure:(NSString*)errorMsg;
@end
