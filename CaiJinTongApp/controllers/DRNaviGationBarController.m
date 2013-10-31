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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    UIViewController *cotr = [self.story instantiateViewControllerWithIdentifier:@"DRNaviBar"];
    DRNavigationBar *bar = (DRNavigationBar*)[cotr view];
    bar.frame = (CGRect){0,0,768,44};
    [self.view addSubview:bar];
    [bar.navigationRightItem addTarget:self action:@selector(drnavigationBarRightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    return bar;
}
#pragma --
@end
