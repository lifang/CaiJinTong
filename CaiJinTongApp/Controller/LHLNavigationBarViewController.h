//
//  LHLNavigationBarViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

//本类的意图是提供一个父类
#import <UIKit/UIKit.h>
#import "LHLNavigationBar.h"
@interface LHLNavigationBarViewController : UIViewController
@property (strong ,nonatomic) LHLNavigationBar *lhlNavigationBar;

-(void)leftItemClicked:(id)sender;
-(void)rightItemClicked:(id)sender;
@end
