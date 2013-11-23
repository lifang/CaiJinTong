//
//  AppDelegate.h
//  CaiJinTongApp
//
//  Created by david on 13-10-30.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadService.h"
#import "LessonViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  NSMutableArray *popupedControllerArr;
@property (strong, nonatomic)  void (^popupedControllerDimissBlock)(void);
//网络监听所用
@property (retain, nonatomic) Reachability *hostReach;
//网络是否连接
@property (assign, nonatomic) BOOL isReachable;
@property (assign, nonatomic) BOOL isLocal;
@property (strong, nonatomic) DownloadService *mDownloadService;
@property (strong, nonatomic)  LessonViewController *lessonViewCtrol;
+(AppDelegate *)sharedInstance;
- (void)showRootView;
@end
