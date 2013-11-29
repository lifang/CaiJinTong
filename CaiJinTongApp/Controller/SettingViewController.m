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

#define Info_HEADER_IDENTIFIER @"infoheader"
@interface SettingViewController ()

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
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"设置";

    [self.tableView registerClass:[InfoCell class] forHeaderFooterViewReuseIdentifier:Info_HEADER_IDENTIFIER];
    if (platform<7.0) {
        self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    }else {
        self.tableView.contentInset = UIEdgeInsetsMake(-10, 0, 0, 0);
    }

    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    self.drnavigationBar.titleLabel.text = @"设置";
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
            return 3;
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
                    cell.textLabel.text = @"版本检测";
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
                    [[SDImageCache sharedImageCache]clearMemory];
                    [[SDImageCache sharedImageCache]clearDisk];
                    break;
                case 2:
                {
//                    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//                    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@",appleID]]];
//                    [request setHTTPMethod:@"GET"];
//                    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//                    NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
//                    NSString *latestVersion = [jsonData objectForKey:@"version"];
//                    NSString *trackName = [jsonData objectForKey:@"trackName"];
//                    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
//                    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
                    [iVersion sharedInstance].delegate = self;
                    [[iVersion sharedInstance] checkForNewVersion];
                    
//                    if (currentVersion < latestVersion) {
//                        UIAlertView *alert;
//                        alert = [[UIAlertView alloc] initWithTitle:trackName
//                                                           message:@"有新版本，是否升级！"
//                                                          delegate: self
//                                                 cancelButtonTitle:@"取消"
//                                                 otherButtonTitles: @"升级", nil];
//                        alert.tag = 1001;
//                        [alert show];
//                    }
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

#pragma mark iVersionDelegate
-(void)iVersionDidNotDetectNewVersion{
    iVersion *version = [iVersion sharedInstance];
 ((UITableViewCell *)self.tableView.visibleCells[3]).textLabel.text = [NSString stringWithFormat:@"版本检测                                        最新版本%@",version.applicationVersion];
}

-(void)iVersionDidDetectNewVersion:(NSString *)version details:(NSString *)versionDetails{
 ((UITableViewCell *)self.tableView.visibleCells[3]).textLabel.text = [NSString stringWithFormat:@"版本检测                                            最新版本%@",version];
}

-(void)iVersionVersionCheckDidFailWithError:(NSError *)error{

}
#pragma mark --

#pragma mark -- cellDelegate
-(void)infoCellView:(InfoCell*)header {
}

#pragma mark -- suggestion feedback view
-(void)suggestionFeedbackViewClicked{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:[NSBundle mainBundle]];
    SuggestionFeedbackViewController *suggestion = [story instantiateViewControllerWithIdentifier:@"SuggestionFeedbackViewController"];
    [self.navigationController pushViewController:suggestion animated:YES];
}
@end
