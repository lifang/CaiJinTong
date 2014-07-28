//
//  LessonListForCategory.h
//  CaiJinTongApp
//
//  Created by david on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 根据分类id加载课程列表
 */
@protocol LessonListForCategoryDelegate;
@interface LessonListForCategory : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<LessonListForCategoryDelegate>delegate;
@property (assign,nonatomic) int currentPageIndex;
@property (assign,nonatomic) int allDataCount;
@property (strong,nonatomic) NSString *lessonCategoryId;//课程分类的id
//sortType : 1:最近播放学习，2:学习进度排序，3:名称排序
-(void)downloadLessonListForCategoryId:(NSString*)categoryId withUserId:(NSString*)userId withPageIndex:(int)pageIndex withSortType:(LESSONSORTTYPE)sortType;
@end

@protocol LessonListForCategoryDelegate <NSObject>
-(void)getLessonListDataForCategoryDidFinished:(NSArray*)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)getLessonListDataForCategoryFailure:(NSString*)errorMsg;
@end


