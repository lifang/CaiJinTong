//
//  LessonViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonModel.h"
#import "chapterModel.h"
#import "SectionCustomView_iPhone.h"
#import "ChapterInfoInterface.h"
#import "ChapterSearchBar_iPhone.h"
#import "CJTMainToolbar_iPhone.h"
#import "ChineseString.h"
#import "pinyin.h"
#import "SearchLessonInterface.h"
#import "LHLNavigationBarViewController.h"
#import "SectionViewController_iPhone.h"
#import "MenuTableViewController.h"
#import "MJRefresh.h"
typedef enum{
    recent = 1,
    progress,
    a_z
} FilterStatus;
@interface LessonViewController_iPhone : LHLNavigationBarViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate,CJTMainToolbar_iPhoneDelegate,SearchLessonInterfaceDelegate,ChapterSearchBarDelegate_iPhone,LessonInfoInterfaceDelegate,LessonCategoryInterfaceDelegate,DRTreeTableViewDelegate,LessonListForCategoryDelegate,MJRefreshBaseViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) UIScrollView *myScrollView;

@property (nonatomic) FilterStatus filterStatus;

@property (strong,nonatomic) NSMutableArray *lessonList;
@property (strong,nonatomic) NSMutableArray *chapterList;
@property (strong,nonatomic) NSMutableArray *sectionList;//collectionViewDataSource使用的数据源
@property (strong,nonatomic) NSMutableArray *recentArray;//最近播放
@property (strong,nonatomic) NSArray *progressArray;//进度排序
@property (strong,nonatomic) NSArray *nameArray;//名称排序

@property (strong,nonatomic) SectionCustomView_iPhone *sectionCustomView;
@property (strong,nonatomic) MenuTableViewController *menu;//侧边栏
@property (nonatomic) BOOL menuVisible;

@property (strong,nonatomic) ChapterInfoInterface *chapterInterface;
@property (strong,nonatomic) SectionInfoInterface *sectionInfoInterface;
@property (strong,nonatomic) SearchLessonInterface *searchInterface;
@property (nonatomic, strong) ChapterSearchBar_iPhone *searchBar;
@property (nonatomic,strong) NSString *oldSearchText;//搜索之前字符串

@property (strong,nonatomic) CJTMainToolbar_iPhone *mainToolBar;

@property (assign,nonatomic) LESSONSORTTYPE sortType;
@end