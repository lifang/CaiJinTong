//
//  DRNaviGationBarController.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRNaviGationBarController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *drnavigationBar;
- (IBAction)drnavigationBarRightItemClicked:(id)sender;

@end
