//
//  CustomTabbarController.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabbarController : UIViewController<UITabBarDelegate>
@property (strong,nonatomic) NSMutableArray *viewControllers;
@property (strong,nonatomic) UITabBar *tabBar;
@property (assign,nonatomic) NSUInteger selectedIndex;
@end
