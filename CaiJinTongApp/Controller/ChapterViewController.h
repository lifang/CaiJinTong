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
@interface ChapterViewController : DRNaviGationBarController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,CJTMainToolbarDelegate, SectionInfoInterfaceDelegate>
@property (nonatomic, strong) SectionInfoInterface *sectionInterface;
@property (nonatomic, strong) CJTMainToolbar *mainToolBar;
@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSArray *recentArray;//默认(最近播放)
@property (nonatomic, strong) NSArray *progressArray;//学习进度
@property (nonatomic, strong) NSArray *nameArray;//名称(A-Z)
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) SectionCustomView *sectionView;
@end
