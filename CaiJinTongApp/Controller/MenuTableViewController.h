//
//  MenuTableViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//


/*
 侧边栏table
 
 */
#import <UIKit/UIKit.h>
#import "MenuTableCell.h"
#import "LessonListHeaderView_iPhone.h"
#import "LessonModel.h"
#import "chapterModel.h"

@interface MenuTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LessonInfoInterfaceDelegate,LessonListHeaderView_iPhoneDelegate,ChapterInfoInterfaceDelegate,LessonCategoryInterfaceDelegate,DRTreeTableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *lessonList;     //课程数据(LessonModel)
@property (nonatomic, strong) NSMutableArray *arrSelSection;  //标记选中
@property (nonatomic, assign) NSInteger tmpSection;

@property (nonatomic, strong) ChapterInfoInterface *chapterInterface;
@property (nonatomic, strong) LessonInfoInterface *lessonInterface;

@end
