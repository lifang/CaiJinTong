//
//  DRNaviGationBarController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNaviGationBarController.h"

@interface DRNaviGationBarController ()

@end

@implementation DRNaviGationBarController

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
     self.drnavigationBar.searchBar.delegate = self;
     [self.view addSubview:self.drnavigationBar];
     [self.drnavigationBar.navigationRightItem addTarget:self action:@selector(drnavigationBarRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];

     [super viewDidLoad];
     
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)drnavigationBarRightItemClicked:(id)sender {
    
}

#pragma mark DRSearchBarDelegate
-(void)drSearchBar:(DRSearchBar *)searchBar didBeginSearchText:(NSString *)searchText{
     
}

-(void)drSearchBar:(DRSearchBar *)searchBar didCancelSearchText:(NSString *)searchText{
     
}
#pragma mark --


#pragma mark property
-(UIStoryboard *)story{
    return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
}
-(DRNavigationBar *)drnavigationBar{
     if (!_drnavigationBar) {
          _drnavigationBar = [[DRNavigationBar alloc] initWithFrame:(CGRect){0,0,770,55}];
          _drnavigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
     }
     return _drnavigationBar;
}
#pragma --
@end
