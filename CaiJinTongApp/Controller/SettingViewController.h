//
//  SettingViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : DRNaviGationBarController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
