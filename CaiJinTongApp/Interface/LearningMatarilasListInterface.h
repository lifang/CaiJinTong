//
//  LearningMatarilasListInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "LearningMaterials.h"
/*
 下载资料列表
 */

@protocol LearningMatarilasListInterfaceDelegate;
@interface LearningMatarilasListInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<LearningMatarilasListInterfaceDelegate>delegate;
@property (assign,nonatomic) int currentPageIndex;
@property (assign,nonatomic) int allDataCount;
@property (strong,nonatomic) NSString *lessonCategoryId;//课程分类的id
//sortType :1:时间，2:名称
-(void)downloadlearningMaterilasListForCategoryId:(NSString*)categoryId withUserId:(NSString*)userId withPageIndex:(int)pageIndex withSortType:(LearningMaterialsSortType)sortType;
@end

@protocol LearningMatarilasListInterfaceDelegate <NSObject>
-(void)getlearningMaterilasListDataForCategoryDidFinished:(NSArray*)learningMaterialsList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)getlearningMaterilasListDataForCategoryFailure:(NSString*)errorMsg;
@end
