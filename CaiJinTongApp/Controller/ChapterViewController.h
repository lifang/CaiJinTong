//
//  ChapterViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChapterViewController : DRNaviGationBarController <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIScrollView *myScrollView;
@property (nonatomic, strong) UITableView *myTable;
@property (nonatomic, strong) NSArray *chapterArray;
@end
