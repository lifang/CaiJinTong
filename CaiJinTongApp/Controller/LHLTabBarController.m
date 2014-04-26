//
//  LHLTabBarController.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LHLTabBarController.h"
#import "QuestionV2ViewController.h"
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

///是否显示本地菜单
-(void)loadLocalItem:(BOOL)isLocalItem{
    self.lhlTabBar.items = nil;
    if (isLocalItem) {
        if ([CaiJinTongManager shared].isShowLocalData) {
            LHLTabBarItem *lessonItem = [[LHLTabBarItem alloc] initWithTitle:@"课程" andImage:[UIImage imageNamed:@"play_0h5.png"]];
            LHLTabBarItem *materialItem = [[LHLTabBarItem alloc] initWithTitle:@"资料" andImage:[UIImage imageNamed:@"material.png"]];
            lessonItem.delegate = self;
            materialItem.delegate = self;
            self.lhlTabBar.items = [NSMutableArray arrayWithObjects:lessonItem,materialItem, nil];
            return;
        }
    }else{
        [self generateTabBarItems];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tabBar setHidden:YES];
    [self.view addSubview:self.lhlTabBar];
    
    [self.lhlTabBar setBackgroundColor:[UIColor colorWithRed:10.0/255.0 green:35.0/255.0 blue:56.0/255.0 alpha:1.0]];
    
    [self loadViewControllers];
//    [self generateTabBarItems];
    if (self.selectedIndex < 3) {
        self.lhlTabBar.selectedIndex = self.selectedIndex;
    }else if (self.selectedIndex > 3){
        self.lhlTabBar.selectedIndex = self.selectedIndex+1;
    }
    
    
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
    
    NoteListViewController_iPhone *vc = [story instantiateViewControllerWithIdentifier:@"NoteListViewController_iPhone"];
    [VCs addObject:vc];
    
    LearningMaterialsViewController_iPhone *lMVC = [story instantiateViewControllerWithIdentifier:@"LearningMaterialsViewController_iPhone"];
    [VCs addObject:lMVC];
    
   
    
//    MyQuestionAndAnswerViewController_iPhone *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController_iPhone"];
//    [VCs addObject:myQAVC];
    QuestionV2ViewController *myQAVC = [[QuestionV2ViewController alloc] initWithNibName:@"QuestionV2ViewController" bundle:nil];
    [VCs addObject:myQAVC];
    
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
    LHLTabBarItem *fakeItem = [[LHLTabBarItem alloc] initWithTitle:@"学习" andImage:[UIImage imageNamed:@"lessons.png"]];
    fakeItem.tag = 86;
//    fakeItem.imageView.alpha = 1.0;
    fakeItem.delegate = self;
    [items insertObject:fakeItem atIndex:3];
    self.lhlTabBar.items = [NSMutableArray arrayWithArray:items];
}

//生成一个tabBarItem
-(LHLTabBarItem *) createItem:(NSUInteger ) index{
    NSString *title;
    UIImage *image;
    switch (index) {
        case 0:
            title = @"课程";
            image = [UIImage imageNamed:@"play_0h5.png"];
            break;
        case 3:
            title = @"问答";
            image = [UIImage imageNamed:@"_play_09.png"];
            break;
        case 2:
            title = @"资料";
            image = [UIImage imageNamed:@"material.png"];
            break;
        case 1:
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
//    item.imageView.tag = index;
    item.delegate = self;
    return item;
}

-(void)backButtonClicked:(UIButton *)sender{
//    _backButton.hidden = YES;
    self.selectedIndex = 0;
    [self.lhlTabBar layoutItems_fake];
}

#pragma mark --
#pragma mark -- property

-(LHLTabBar *) lhlTabBar{
    if(!_lhlTabBar){
        _lhlTabBar = [[LHLTabBar alloc] initWithFrame:(CGRect){0, CGRectGetHeight(self.view.frame) - IP5(63, 50), 320, IP5(63, 50)}];
        _lhlTabBar.clipsToBounds = YES;
    }
    return _lhlTabBar;
}

#pragma mark --

-(void)selectedAtIndexItem:(int)index{
    self.selectedIndex = index>= self.childViewControllers.count? (self.childViewControllers.count-1):index;
    if (index < 3) {
         self.lhlTabBar.selectedIndex = index;
    }else{
        self.lhlTabBar.selectedIndex = index+1;
    }
   [self.lhlTabBar layoutItemsWithIndex:self.lhlTabBar.selectedIndex];
}

#pragma mark -- LHLTabBarItemDelegate
-(void)tabBarItemSelected:(LHLTabBarItem *) sender{
    if ([CaiJinTongManager shared].isShowLocalData) {
        switch (sender.tag) {
            case 0:
            {
                if (sender.selected) {
                    [self.lhlTabBar layoutItems];
                    //            LHLTabBarItem *item1 = [self.lhlTabBar.items objectAtIndex:3];
                    //            item1.alpha = 1.0;
                }else{
                    self.lhlTabBar.selectedIndex = sender.tag;
                    LHLTabBarItem *item2 = [self.lhlTabBar.items objectAtIndex:0];
                    item2.selected = YES;
                    self.selectedIndex = 0;
                }
            }
                break;
                
            case 1:
            {
                self.lhlTabBar.selectedIndex = sender.tag;
                 self.selectedIndex = 2;

            }
                break;
            default:
                break;
        }
        return;
    }
    
    if (sender.tag == 0) {
        if (sender.selected) {
             [self.lhlTabBar layoutItems];
//            LHLTabBarItem *item1 = [self.lhlTabBar.items objectAtIndex:3];
//            item1.alpha = 1.0;
        }else{
            self.lhlTabBar.selectedIndex = sender.tag;
            LHLTabBarItem *item2 = [self.lhlTabBar.items objectAtIndex:0];
            item2.selected = YES;
            self.selectedIndex = 0;
        }
    }else
    if (sender.tag == 3) {
         [self.lhlTabBar layoutItems];
        self.lhlTabBar.selectedIndex = sender.tag;
        LHLTabBarItem *item2 = [self.lhlTabBar.items objectAtIndex:0];
        item2.selected = YES;
        self.selectedIndex = 0;
    }else{
        self.lhlTabBar.selectedIndex = sender.tag;
        if (sender.tag < 3) {
            self.selectedIndex = sender.tag;
        }else
            if (sender.tag > 3) {
                self.selectedIndex = sender.tag-1;
            }
    }
}


@end
