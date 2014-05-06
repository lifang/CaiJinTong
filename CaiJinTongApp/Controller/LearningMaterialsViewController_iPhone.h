//
//  LearningMaterialsViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-13.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningMaterialCell.h"
#import "LHLNavigationBarViewController.h"
#import "LearningMatarilasListInterface.h"
#import "SearchLearningMatarilasListInterface.h"
#import "MJRefresh.h"
#import "LearningMatarilasCategoryInterface.h"
#import "ChapterSearchBar_iPhone.h"
@interface LearningMaterialsViewController_iPhone : LHLNavigationBarViewController<LearningMaterialCellDelegate,UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,LearningMatarilasListInterfaceDelegate,SearchLearningMatarilasListInterfaceDelegate,MJRefreshBaseViewDelegate,DRTreeTableViewDelegate,ChapterSearchBarDelegate_iPhone,LearningMatarilasCategoryInterfaceDelegate>
@property (strong,nonatomic) NSString *lessonCategoryId;
@property (strong,nonatomic) NSMutableArray *dataArray;
@property (nonatomic,weak) id lhlTabBarController;

@end
