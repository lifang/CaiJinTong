//
//  LearningMaterialsViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-1-8.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningMaterialCell.h"
#import "LearningMatarilasListInterface.h"
#import "SearchLearningMatarilasListInterface.h"
#import "MJRefresh.h"
@interface LearningMaterialsViewController : DRNaviGationBarController<LearningMaterialCellDelegate,UITableViewDataSource,UITableViewDelegate,LearningMatarilasListInterfaceDelegate,SearchLearningMatarilasListInterfaceDelegate,MJRefreshBaseViewDelegate>
@property (strong,nonatomic) NSString *lessonCategoryId;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,assign) BOOL isSearch;//搜索
-(void)changeLearningMaterialsDate:(NSArray*)learningMaterialArr withSortType:(LearningMaterialsSortType)sortType withCategoryId:(NSString*)categoryId widthAllDataCount:(int)dataCount isSearch:(BOOL)isSearch;
@end
