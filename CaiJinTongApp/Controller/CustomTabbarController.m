//
//  CustomTabbarController.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "CustomTabbarController.h"

@interface CustomTabbarController ()

@end

@implementation CustomTabbarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //
    
    //根据VC array生成相应的tabbarItem
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark --
#pragma mark -- property
-(NSMutableArray *)viewControllers{
    if(!_viewControllers){
        _viewControllers = [NSMutableArray arrayWithCapacity:5];
    }
    return _viewControllers;
}

-(UITabBar *) tabBar{
    if(!_tabBar){
        _tabBar = [[UITabBar alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.view.frame) - IP5(63, 50), 320, IP5(63, 50)}];
        _tabBar.delegate = self;
    }
    return _tabBar;
}

#pragma mark --
#pragma mark -- UITabBar Delegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}

@end
