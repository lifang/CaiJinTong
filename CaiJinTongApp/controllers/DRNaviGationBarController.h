//
//  DRNaviGationBarController.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DRNavigationBar.h"
@interface DRNaviGationBarController : UIViewController
@property (strong, nonatomic)   DRNavigationBar *drnavigationBar;
@property (nonatomic,strong,readonly) UIStoryboard *story;
 - (void)drnavigationBarRightItemClicked:(id)sender;
-(void)willDismissPopoupController;//当要退出当前界面时调用
@end
