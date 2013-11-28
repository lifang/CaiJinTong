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
@interface LessonViewController_iPhone : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ChapterInfoInterfaceDelegate,CJTMainToolbar_iPhoneDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong,nonatomic) UIScrollView *myScrollView;

@property (nonatomic) BOOL isSearching;

@property (strong,nonatomic) NSMutableArray *lessonList;
@property (strong,nonatomic) NSMutableArray *chapterList;
@property (strong,nonatomic) NSMutableArray *sectionList;
@property (strong,nonatomic) NSMutableArray *recentArray;//最近播放
@property (strong,nonatomic) NSArray *progressArray;//进度排序
@property (strong,nonatomic) NSArray *nameArray;//名称排序

@property (strong,nonatomic) SectionCustomView_iPhone *sectionCustomView;
@property (strong,nonatomic) ChapterInfoInterface *chapterInterface;
@property (nonatomic, strong) ChapterSearchBar_iPhone *searchBar;
@property (strong,nonatomic) CJTMainToolbar_iPhone *mainToolBar;
@end