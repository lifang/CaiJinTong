//
//  FixTableViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FixTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *fixTextField;
@property (weak, nonatomic) IBOutlet UIImageView *fixClearImg;
@property (nonatomic, assign) BOOL isImage;//判断是否为头像
@property (nonatomic, weak) NSString *txt;//传过来的值
@end
