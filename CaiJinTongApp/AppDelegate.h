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
#import "iVersion.h"
#import "QuestionV2ViewController.h"

#import "SectionModel.h"

///网络判断
#import "Reachability.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate,iVersionDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic)  NSMutableArray *popupedControllerArr;
@property (strong, nonatomic)  void (^popupedControllerDimissBlock)(void);
///网络监听所用
@property (strong, nonatomic) Reachability *hostReach;
@property (assign, nonatomic) BOOL isReachable;
@property (assign, nonatomic) BOOL isLocal;
@property (strong, nonatomic) DownloadService *mDownloadService;
@property (strong, nonatomic)  LessonViewController *lessonViewCtrol;
@property (strong, nonatomic) NSMutableArray *alertViewArray;

@property (nonatomic, strong) NSMutableArray *appButtonModelArray;
+(AppDelegate *)sharedInstance;
- (void)showRootView;
@end
