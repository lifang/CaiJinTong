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
//    UIImage *selectedImage;
//    switch (index) {
//        case 0:
//            title = @"课程";
//            image = [UIImage imageNamed:@"question1.png"];
//            selectedImage = [UIImage imageNamed:@"Lesson_Item_S.png"];
//            break;
//        case 1:
//            title = @"问答";
//            image = [UIImage imageNamed:@"Q&A_Item.png"];
//            selectedImage = [UIImage imageNamed:@"question1.png"];
//            break;
//        case 2:
//            title = @"资料";
//            image = [UIImage imageNamed:@"play_note.png"];
//            selectedImage = [UIImage imageNamed:@"question1.png"];
//            break;
//        case 3:
//            title = @"笔记";
//            image = [UIImage imageNamed:@"play_note.png"];
//            selectedImage = [UIImage imageNamed:@"question1.png"];
//            break;
//        case 4:
//            title = @"设置";
//            image = [UIImage imageNamed:@"play_note.png"];
//            selectedImage = [UIImage imageNamed:@"question1.png"];
//            break;
//        default:
//            break;
//    }
    switch (index) {
        case 0:
            title = @"课程";
            image = [UIImage imageNamed:@"question1.png"];
            break;
        case 1:
            title = @"问答";
            image = [UIImage imageNamed:@"Q&A_Item.png"];
            break;
        case 2:
            title = @"资料";
            image = [UIImage imageNamed:@"play_note.png"];
            break;
        case 3:
            title = @"笔记";
            image = [UIImage imageNamed:@"play_note.png"];
            break;
        case 4:
            title = @"设置";
            image = [UIImage imageNamed:@"play_note.png"];
            break;
        default:
            break;
    }
    LHLTabBarItem *item = [[LHLTabBarItem alloc] initWithTitle:title andImage:image];
    item.imageView.tag = index;
    [item.imageView setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClicked:)];
    [item.imageView addGestureRecognizer:singleTap];
    return item;
}

//item点击
-(void)itemClicked:(UITapGestureRecognizer *)sender{
    UIImageView *imageView = (UIImageView *) sender;
    self.selectedIndex = imageView.tag;
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
#pragma mark -- UITabBar Delegate
//-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    self.selectedIndex = item.tag;
//}
@end
