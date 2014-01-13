//
//  LHLTabBar.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//  使用本TabBar只需要初始化之后,为其指定LHLTabBarItem数组(items)即可

#import <UIKit/UIKit.h>
#import "LHLTabBarItem.h"

@interface LHLTabBar : UIView
@property (strong,nonatomic) NSMutableArray *items;
@property (nonatomic,assign) NSUInteger selectedIndex;
@end
