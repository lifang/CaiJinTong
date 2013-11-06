//
//  SectionViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionViewController.h"


@interface SectionViewController ()

@end

@implementation SectionViewController

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
    
	[self displayView];
}
-(void)drnavigationBarRightItemClicked:(id)sender{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"%f",self.view.frame.size.width);
    if (self.section) {
        SectionCustomView *sv = [[SectionCustomView alloc]initWithFrame:CGRectMake(10, 54, 250, 250) andSection:self.section andItemLabel:0];
        self.sectionView = sv;
        
        [self.view addSubview:self.sectionView];
        
        
    }
}

-(void)displayView {
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [SUNSlideSwitchView colorFromHexRGB:@"bb0b15"];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"red_line_and_shadow.png"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    self.section_ChapterView = [story instantiateViewControllerWithIdentifier:@"Section_ChapterViewController"];
    self.section_ChapterView.title = @"章节目录";
    self.section_GradeView = [story instantiateViewControllerWithIdentifier:@"Section_GradeViewController"];
    self.section_GradeView.title = @"打分";
    self.section_NoteView = [story instantiateViewControllerWithIdentifier:@"Section_NoteViewController"];
    self.section_NoteView.title = @"笔记";
    
    [self.slideSwitchView buildUI];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    if (number == 0) {
        return self.section_ChapterView;
    } else if (number == 1) {
        return self.section_GradeView;
    } else if (number == 2) {
        return self.section_NoteView;
    }  else {
        return nil;
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
//    SUNViewController *drawerController = (SUNViewController *)self.navigationController.mm_drawerController;
//    [drawerController panGestureCallback:panParam];
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    Section_ChapterViewController *section_ChapterView = nil;
    Section_GradeViewController *section_GradeView = nil;
    Section_NoteViewController *section_NoteView = nil;
    if (number == 0) {
        section_ChapterView = self.section_ChapterView;
        [section_ChapterView viewDidCurrentView];
    } else if (number == 1) {
        section_GradeView = self.section_GradeView;
        [section_GradeView viewDidCurrentView];
    } else if (number == 2) {
        section_NoteView = self.section_NoteView;
        [section_NoteView viewDidCurrentView];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
