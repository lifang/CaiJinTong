//
//  SearchLessonInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol SearchLessonInterfaceDelegate;

@interface SearchLessonInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, assign) int currentPageIndex;
@property (nonatomic, assign) int  allDataCount;
@property (nonatomic, assign) id<SearchLessonInterfaceDelegate>delegate;

-(void)getSearchLessonInterfaceDelegateWithUserId:(NSString *)userId andText:(NSString *)text withPageIndex:(int)pageIndex withSortType:(LESSONSORTTYPE)sortType;
@end

@protocol SearchLessonInterfaceDelegate <NSObject>

-(void)getSearchLessonListDataForCategoryDidFinished:(NSArray*)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)getSearchLessonListDataForCategoryFailure:(NSString*)errorMsg;
@end