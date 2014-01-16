//
//  LHLTabBarController.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTabBarController.h"

@interface LHLTabBarController ()

@end

@implementation LHLTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setHidden:YES];
    [self.view addSubview:self.lhlTabBar];
    
    [self.lhlTabBar setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:35.0/255.0 blue:56.0/255.0 alpha:1.0]];
    
    [self loadViewControllers];
    [self generateTabBarItems];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark --
#pragma mark -- action
//载入所有的VC
-(void) loadViewControllers{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    NSMutableArray *VCs = [NSMutableArray arrayWithCapacity:5];
    
    LessonViewController_iPhone *lessonVC = [story instantiateViewControllerWithIdentifier:@"LessonViewController_iPhone"];
    [VCs addObject:lessonVC];
    
    MyQuestionAndAnswerViewController_iPhone *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController_iPhone"];
    [VCs addObject:myQAVC];
    
    LearningMaterialsViewController_iPhone *lMVC = [story instantiateViewControllerWithIdentifier:@"LearningMaterialsViewController_iPhone"];
    [VCs addObject:lMVC];
    
    UIViewController *vc = [UIViewController new];
    [VCs addObject:vc];
    
    SettingViewController_iPhone *settingVC = [story instantiateViewControllerWithIdentifier:@"SettingViewController_iPhone"];
    [VCs addObject:settingVC];
    
    self.viewControllers = VCs;
}

//根据viewControllers为lhlTabBar生成Items
-(void) generateTabBarItems{
    NSMutableArray *items = [NSMutableArray arrayWithCapacity:5];
    for(NSUInteger i = 0;i < self.viewControllers.count;i ++){
        LHLTabBarItem *item = [self createItem:i];
        [items addObject:item];
    }
    self.lhlTabBar.items = [NSMutableArray arrayWithArray:items];
}

//生成一个tabBarItem
-(LHLTabBarItem *) createItem:(NSUInteger ) index{
    NSString *title;
    UIImage *image;
    switch (index) {
        case 0:
            title = @"课程";
            image = [UIImage imageNamed:@"lessons.png"];
            break;
        case 1:
            title = @"问答";
            image = [UIImage imageNamed:@"_play_09.png"];
            break;
        case 2:
            title = @"资料";
            image = [UIImage imageNamed:@"material.png"];
            break;
        case 3:
            title = @"笔记";
            image = [UIImage imageNamed:@"play_note.png"];
            break;
        case 4:
            title = @"设置";
            image = [UIImage imageNamed:@"set.png"];
            break;
        default:
            break;
    }
    LHLTabBarItem *item = [[LHLTabBarItem alloc] initWithTitle:title andImage:image];
    item.imageView.tag = index;
    item.delegate = self;
    return item;
}

#pragma mark --
#pragma mark -- property

-(LHLTabBar *) lhlTabBar{
    if(!_lhlTabBar){
        _lhlTabBar = [[LHLTabBar alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.view.frame) - IP5(63, 50), 320, IP5(63, 50)}];
    }
    return _lhlTabBar;
}

#pragma mark --
#pragma mark -- LHLTabBarItemDelegate
-(void)tabBarItemSelected:(LHLTabBarItem *) sender{
    self.selectedIndex = sender.imageView.tag;
    self.lhlTabBar.selectedIndex = sender.imageView.tag;
}
@end