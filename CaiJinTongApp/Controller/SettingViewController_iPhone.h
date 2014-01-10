//
//  SettingViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNavigationBarViewController.h"
#import "InfoCell.h"
#import "SuggestionFeedbackViewController_iPhone.h"

@interface SettingViewController_iPhone : LHLNavigationBarViewController<UITableViewDataSource,UITableViewDelegate,InfoCellDelegate,iVersionDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
