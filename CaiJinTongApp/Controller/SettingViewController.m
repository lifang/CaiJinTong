//
//  SettingViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SettingViewController.h"
#import "iRate.h"
#import "InfoViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ASINetworkQueue.h"
#define Info_HEADER_IDENTIFIER @"infoheader"
@interface SettingViewController ()
@property (strong,nonatomic) UILabel *versionnumberLabel;
@end

NSString *appleID = @"6224939";

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}

-(void)willDismissPopoupController{
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView setContentOffset:offset animated:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingViewControllerDismiss" object:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//TODO:新版本通知
-(void)appNewVersionNotification{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (![appVersion isEqualToString:[CaiJinTongManager shared].appstoreNewVersion]) {
        [self.versionnumberLabel setHidden:NO];
    }else{
        [self.versionnumberLabel setHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.versionnumberLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,35,20}];
    [self.versionnumberLabel setTextColor:[UIColor whiteColor]];
    [self.versionnumberLabel setFont:[UIFont systemFontOfSize:12]];
    self.versionnumberLabel.text = @"NEW";
    [self.versionnumberLabel setTextAlignment:NSTextAlignmentCenter];
    [self.versionnumberLabel setBackgroundColor:[UIColor redColor]];
    self.versionnumberLabel.layer.cornerRadius = 5;
    [self appNewVersionNotification];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appNewVersionNotification) name:APPNEWVERSION_Notification object:nil];
    [self.tableView registerClass:[InfoCell class] forHeaderFooterViewReuseIdentifier:Info_HEADER_IDENTIFIER];
    
    
    UIView *footerView = [[UIView alloc]initWithFrame:(CGRect){0,0,400,44}];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 400, 44)];
    label.textColor = [UIColor grayColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    NSString* appver=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    label.text = [NSString stringWithFormat:@"当前版本%@",appver];
    [footerView addSubview:label];
    
    [self.tableView setTableHeaderView:footerView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section  {
    if (section == 2) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 2) {
        InfoCell *footer = (InfoCell *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:Info_HEADER_IDENTIFIER];
        footer.delegate = self;
        return footer;
    }
    return nil;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 3;
            break;
        case 2:
            return 2;
            break;
        default:
            break;
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier =[NSString stringWithFormat:@"Cell%d%d",indexPath.section,indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //    cell.backgroundColor = [UIColor clearColor];
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"我的资料";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    BOOL isloadLargeImage = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOADLARGEIMAGE_KEY];
                    if (isloadLargeImage) {
                        cell.accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    cell.textLabel.text = @"2G/3G网络为无图模式";
                }
                    
                    break;
                case 1:
                    cell.textLabel.text = @"清理缓存";
                    break;
                case 2:
                {
                    cell.textLabel.text = [NSString stringWithFormat:@"版本检测                                  版本v%@",[CaiJinTongManager shared].appstoreNewVersion];
                    cell.accessoryView = self.versionnumberLabel;
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"给予评星";
                    break;
                case 1:
                    cell.textLabel.text = @"意见反馈";
                    break;
                case 2:
                    cell.textLabel.text = @"关于";
                    break;
                    
                default:
                    break;
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    InfoViewController *vc = [story instantiateViewControllerWithIdentifier:@"InfoViewController"];
    switch (indexPath.section) {
        case 0:
            [self.navigationController pushViewController:vc animated:YES];
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                {
                    BOOL isloadLargeImage = [[NSUserDefaults standardUserDefaults] boolForKey:ISLOADLARGEIMAGE_KEY];
                    if (!isloadLargeImage) {
                        ((UITableViewCell *)self.tableView.visibleCells[1]).accessoryType = UITableViewCellAccessoryNone;
                    }else{
                        ((UITableViewCell *)self.tableView.visibleCells[1]).accessoryType = UITableViewCellAccessoryCheckmark;
                    }
                    [[CaiJinTongManager shared] setIsLoadLargeImage:!isloadLargeImage];
                    [[NSUserDefaults standardUserDefaults] setBool:!isloadLargeImage forKey:ISLOADLARGEIMAGE_KEY];
                }
                    break;
                case 1:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"清除缓存，会删除所有已经下载的视频文件。" delegate:self cancelButtonTitle:@"确认删除" otherButtonTitles:@"取消", nil];
                    [alert show];
                    [[SDImageCache sharedImageCache]clearMemory];
                    [[SDImageCache sharedImageCache]clearDisk];
                }
                    break;
                case 2:
                {
                    NSString* appver=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
                    double clientVer = [appver doubleValue];
                    double serverVer = [[CaiJinTongManager shared].appstoreNewVersion doubleValue];
                    if (clientVer>=serverVer){
                        
                    }else {
                        [[UIApplication sharedApplication] openURL:[iVersion sharedInstance].updateURL];
                    }
                }
                    break;
                    
                default:
                    break;
            }
            break;
        case 2:
            switch (indexPath.row) {
                case 0:
                    [[iRate sharedInstance] openRatingsPageInAppStore];
                    break;
                case 1:
                    [self suggestionFeedbackViewClicked];
                    break;
                case 2:
                    
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [DRFMDBDatabaseTool clearAllDownloadedDatasWithSuccess:^{
            [Utility errorAlert:@"清除缓存成功"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        } withFailure:nil];
    }
}
#pragma mark --
#pragma mark -- cellDelegate
-(void)infoCellView:(InfoCell*)header {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"user.archive"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }
    
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.mDownloadService && app.mDownloadService.networkQueue) {
        ASINetworkQueue *queue = app.mDownloadService.networkQueue;
        if (queue.operationCount > 0) {
            [queue cancelAllOperations];
        }
    }
    app.appButtonModelArray = nil;
    [app.lessonViewCtrol.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -- suggestion feedback view
-(void)suggestionFeedbackViewClicked{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    SuggestionFeedbackViewController *suggestion = [story instantiateViewControllerWithIdentifier:@"SuggestionFeedbackViewController"];
    [self.navigationController pushViewController:suggestion animated:YES];
}
@end
