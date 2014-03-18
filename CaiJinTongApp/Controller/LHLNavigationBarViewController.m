//
//  LHLNavigationBarViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLNavigationBarViewController.h"
#define BAR_HEIGHT (IS_4_INCH ? 55 : 55)

@interface LHLNavigationBarViewController ()

@end

@implementation LHLNavigationBarViewController

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
    [self.navigationController setNavigationBarHidden:YES];
    
    if(!self.lhlNavigationBar){
        self.lhlNavigationBar = [[LHLNavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, BAR_HEIGHT)];
        [self.lhlNavigationBar.leftItem addTarget:self action:@selector(leftItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.lhlNavigationBar.rightItem addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.lhlNavigationBar];
    }
}

-(void)rightItemClicked:(id)sender{
    
}

-(void)leftItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
