//
//  LHLTabBarController.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonViewController_iPhone.h"
#import "MyQuestionAndAnswerViewController_iPhone.h"
#import "LHLTabBar.h"
#import "LHLTabBarItem.h"
#import "SettingViewController_iPhone.h"

@interface LHLTabBarController : UITabBarController<UIGestureRecognizerDelegate,LHLTabBarItemDelegate>
@property (nonatomic,strong) LHLTabBar *lhlTabBar;//替代默认的tabBar
@end
