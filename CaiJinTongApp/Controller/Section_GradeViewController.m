//
//  Section_GradeViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_GradeViewController.h"

@interface Section_GradeViewController ()

@end

@implementation Section_GradeViewController

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
	TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(20, 100, 250, 50) numberOfStar:5];
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
}
- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    DLog(@"score = %f",score);
//    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score*5 ];
}
@end
