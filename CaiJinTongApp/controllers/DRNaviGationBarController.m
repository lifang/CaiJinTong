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
     if(!self.drnavigationBar){
          UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
          self.drnavigationBar = [story instantiateViewControllerWithIdentifier:@"DRNaviBar"];
     }
    [self.view addSubview:self.drnavigationBar];
     [self.view bringSubviewToFront:self.drnavigationBar];
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.drnavigationBar.navigationRightItem addTarget:self action:@selector(drnavigationBarRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
//    self.drnavigationBar.button = [UIButton buttonWithType:UIButtonTypeCustom];
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

#pragma mark property
-(UIStoryboard *)story{
    return [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
}

-(DRNavigationBar *)drnavigationBar{
    if (!_drnavigationBar) {
        _drnavigationBar = [[DRNavigationBar alloc] initWithFrame:CGRectMake(0,0,768,44)];
        [self.view addSubview:_drnavigationBar];
        
    }
    return _drnavigationBar;
}
#pragma --
@end
