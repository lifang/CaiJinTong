//
//  SearchLearningMatarilasListInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "LearningMaterials.h"
/*
 搜索资料列表
 */

@protocol SearchLearningMatarilasListInterfaceDelegate;
@interface SearchLearningMatarilasListInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<SearchLearningMatarilasListInterfaceDelegate>delegate;
@property (assign,nonatomic) int currentPageIndex;
@property (assign,nonatomic) int allDataCount;
//sortType :1:时间，2:名称
-(void)searchLearningMaterilasListWithUserId:(NSString*)userId withSearchContent:(NSString*)searchContent withPageIndex:(int)pageIndex withSortType:(NSString*)sortType;
@end

@protocol SearchLearningMatarilasListInterfaceDelegate <NSObject>
-(void)searchLearningMaterilasListDataForCategoryDidFinished:(NSArray*)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)searchLearningMaterilasListDataForCategoryFailure:(NSString*)errorMsg;
@end