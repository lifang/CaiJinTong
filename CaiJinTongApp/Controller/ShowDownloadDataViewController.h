//
//  ShowDownloadDataViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-4-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LearningMaterialCell.h"
#import "DRTreeNode.h"
#define LoadLocalLessonCategory @"LoadLocalLessonCategory"
#define LoadLocalLearningMaterialCategory @"LoadLocalLearningMaterialCategory"
#define LoadLocalNotificationData @"LoadLocalNotificationData"
/** ShowDownloadDataViewController
 *
 * 显示下载记录，包括已经下载的课程和资料
 */
@interface ShowDownloadDataViewController : UIViewController<LearningMaterialCellDelegate,UITableViewDelegate,UITableViewDataSource,UICollectionViewDataSource,UICollectionViewDelegate,UIAlertViewDelegate>
@property (assign,nonatomic) BOOL isShowLesson;
///从数据库加载课程信息
-(void)reloadLessonDataFromDatabase;

///从数据库加载资料信息
-(void)reloadLearningMaterialDataFromDataBase;

///根据分类过滤
-(void)filterDataFromCategory:(DRTreeNode*)treeNote;
@end
