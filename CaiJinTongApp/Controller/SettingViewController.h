//
//  SettingViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfoCell.h"
#import "SuggestionFeedbackViewController.h"

@interface SettingViewController : DRNaviGationBarController<UITableViewDataSource,UITableViewDelegate,InfoCellDelegate,iVersionDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
