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
#import "ChapterSearchBar.h"
#import "SectionInfoInterface.h"
@interface ChapterViewController : UIViewController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CJTMainToolbarDelegate, SectionInfoInterfaceDelegate,ChapterInfoInterfaceDelegate>
@property (nonatomic, strong) SectionInfoInterface *sectionInterface;
@property (nonatomic, strong) CJTMainToolbar *mainToolBar;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSArray *recentArray;//默认(最近播放)
@property (nonatomic, strong) NSArray *progressArray;//学习进度
@property (nonatomic, strong) NSArray *nameArray;//名称(A-Z)
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SectionCustomView *sectionView;
@property (nonatomic, strong) ChapterSearchBar *searchBar;

@property (nonatomic,strong) ChapterInfoInterface *chapterInfoInterface;
@property (nonatomic,strong) NSMutableArray *searchResultArray;//搜索结果

@property (assign,nonatomic) BOOL isSearch;

-(void)reloadDataWithDataArray:(NSArray*)data;
@end
