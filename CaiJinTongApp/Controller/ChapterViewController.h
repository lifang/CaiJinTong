//
//  ChapterViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionCustomView.h"
#import "CJTMainToolbar.h"
#import "SectionInfoInterface.h"

#import "CollectionCell.h"
#import "CollectionHeader.h"
#import "LessonListForCategory.h"
#import "MJRefresh.h"
/*
 课程列表
 */
@interface ChapterViewController : DRNaviGationBarController <UIScrollViewDelegate,CJTMainToolbarDelegate, SectionInfoInterfaceDelegate,SearchLessonInterfaceDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CollectionHeaderDelegate,LessonListForCategoryDelegate,MJRefreshBaseViewDelegate,LessonInfoInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titleBarLabel;
@property (nonatomic, strong) CJTMainToolbar *mainToolBar;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SectionCustomView *sectionView;
@property (nonatomic,strong) NSString *lessonCategoryId;
@property (nonatomic,strong) ChapterInfoInterface *chapterInfoInterface;
@property (nonatomic, strong) LessonInfoInterface *lessonInterface;//获取课程详细信息
@property (assign,nonatomic) BOOL isSearch;//是否是搜索

@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果
@property (assign,nonatomic) LESSONSORTTYPE sortType;
@property (strong,nonatomic) LessonListForCategory *lessonListForCategory;//根据分类获取课程列表

-(void)reloadDataWithDataArray:(NSArray*)data withCategoryId:(NSString*)lessonCategoryId isSearch:(BOOL)isSearch;
@end
