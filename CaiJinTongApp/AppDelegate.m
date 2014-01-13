//
//  AppDelegate.m
//  CaiJinTongApp
//
//  Created by david on 13-10-30.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "CaiJinTongManager.h"
#import "iRate.h"
#import "Section.h"
#import "SectionSaveModel.h"
@implementation AppDelegate

+ (void)initialize
{
    //设置appstore上评分
    [iRate sharedInstance].appStoreID = 355313284;
    [iRate sharedInstance].messageTitle = @"应用打分";
    [iRate sharedInstance].message = @"喜欢这个app，就去打个分吧，或者给我们一些宝贵的建议吧";
    [iRate sharedInstance].cancelButtonLabel = @"取消";
    [iRate sharedInstance].remindButtonLabel = @"下次再说";
    [iRate sharedInstance].rateButtonLabel = @"去评分";
    //检测版本
    [iVersion sharedInstance].inThisVersionTitle = NSLocalizedString(@"新版本", @"iVersion local version alert title");
    [iVersion sharedInstance].updateAvailableTitle = NSLocalizedString(@"A new version of MyApp is available to download", @"iVersion new version alert title");
    [iVersion sharedInstance].versionLabelFormat = NSLocalizedString(@"Version %@", @"iVersion version label format");
    [iVersion sharedInstance].okButtonLabel = NSLocalizedString(@"确定", @"iVersion OK button");
    [iVersion sharedInstance].ignoreButtonLabel = NSLocalizedString(@"取消", @"iVersion ignore button");
    [iVersion sharedInstance].remindButtonLabel = NSLocalizedString(@"下次再说", @"iVersion remind button");
    [iVersion sharedInstance].downloadButtonLabel = NSLocalizedString(@"下载", @"iVersion download button");
    [iVersion sharedInstance].appStoreID = 355313284;
    [iVersion sharedInstance].checkAtLaunch = YES;
}

+(AppDelegate *)sharedInstance {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)showRootView {
    
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //设置是否加载图片
    BOOL isloadLargeImage = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOADLARGEIMAGE_KEY];
    [[CaiJinTongManager shared] setIsLoadLargeImage:isloadLargeImage];
    
    
    //开启网络状况的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [[Reachability reachabilityWithHostName:@"www.baidu.com"] startNotifier];  //开始监听，会启动一个run loop
    
    self.mDownloadService = [[DownloadService alloc]init];
    UserModel *user = [[UserModel alloc] init];
    user.userId = @"17082";
    [[CaiJinTongManager shared] setUser:user];
    return YES;
}
//连接改变
-(void)reachabilityChanged:(NSNotification *)note
{
    Reachability *currReach = [note object];
    NSParameterAssert([currReach isKindOfClass:[Reachability class]]);
    
    //对连接改变做出响应处理动作
    NetworkStatus status = [currReach currentReachabilityStatus];
    //如果没有连接到网络就弹出提醒实况
    self.isReachable = YES;
    if(status == NotReachable)
    {
        self.isReachable = NO;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if ([[UIDevice currentDevice] isMultitaskingSupported]) {
        [[CaiJinTongManager shared] run];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[CaiJinTongManager shared] stop];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//程序退出
- (void)applicationWillTerminate:(UIApplication *)application
{
    //停止下载任务
    Section *sectionDb = [[Section alloc]init];
    NSArray *local_array = [sectionDb getDowningInfo];
    if (local_array.count>0) {
        for (int i=0; i<local_array.count; i++) {
            SectionSaveModel *nm = (SectionSaveModel *)[local_array objectAtIndex:i];
            [self.mDownloadService stopTask:nm];
        }
    }
}


//-(NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
//    NSUInteger orientations = UIInterfaceOrientationMaskAll;
//    return orientations;
//}

#pragma mark property
-(NSMutableArray *)popupedControllerArr{
    if (!_popupedControllerArr) {
        _popupedControllerArr = [NSMutableArray array];
    }
    return _popupedControllerArr;
}
#pragma mark --
@end
