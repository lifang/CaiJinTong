//
//  LessonViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonViewController.h"
#import "LessonModel.h"
#import "chapterModel.h"
#import "ForgotPwdViewController.h"
@interface LessonViewController ()

@end

@implementation LessonViewController

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

    //数据来源
	self.lessonDictionary = [Utility initWithJSONFile:@"lessonInfo"];
    NSDictionary *dic =[self.lessonDictionary objectForKey:@"ReturnObject"];
    NSArray *array = [dic objectForKey:@"lessonList"];
    if (array.count>0) {
        self.lessonList = [[NSMutableArray alloc]init];
        for (int i=0; i<array.count; i++) {
            NSDictionary *dic_lessoon = [array objectAtIndex:i];
            LessonModel *lesson = [[LessonModel alloc]init];
            lesson.lessonId = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonId"]];
            lesson.lessonName = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonName"]];
            
            NSArray *arr_chapter = [dic_lessoon objectForKey:@"chapterList"];
            if (arr_chapter.count >0) {
                lesson.chapterList = [[NSMutableArray alloc]init];
                for (int k=0; k<arr_chapter.count; k++) {
                    NSDictionary *dic_chapter = [arr_chapter objectAtIndex:k];
                    chapterModel *chapter = [[chapterModel alloc]init];
                    chapter.chapterId = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterId"]];
                    chapter.chapterName = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterName"]];
                    [lesson.chapterList addObject:chapter];
                }
                DLog(@"chapterList = %@",lesson.chapterList);
            }
            [self.lessonList  addObject:lesson];
        }
    }
    DLog(@"%@",self.lessonList);
    //标记是否选中了
    self.arrSelSection = [[NSMutableArray alloc] init];
    for (int i =0; i<self.lessonList.count; i++) {
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //tableView初始化
    CGRect rect = CGRectMake(0, 20, self.view.frame.size.width/2, self.view.frame.size.height-20);
    self.lessonTable = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.lessonTable.delegate = self;
    self.lessonTable.dataSource = self;
    self.lessonTable.backgroundColor = [UIColor clearColor];
    [self.lessonTable.layer setBorderWidth:1];
    [self.lessonTable.layer setBorderColor:[UIColor grayColor].CGColor];
    [self.view addSubview:self.lessonTable];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 40;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/2, 40)];
    [view.layer setBorderWidth:1];

    UIButton *customView = [[UIButton alloc] initWithFrame:view.bounds];
    [customView.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [customView setBackgroundColor:[UIColor orangeColor]];
    [customView setTitle:lesson.lessonName forState:UIControlStateNormal];
    [customView setTag:section];
    [customView addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:customView];
    
    UIImageView *directionView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    [view addSubview:directionView];
    
    BOOL isSelSection = NO;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            isSelSection = YES;
            [directionView setImage:Image(@"jiantou_up.png")];
            break;
        }
    }
    if (!isSelSection) {
        [directionView setImage:Image(@"jiantou_down.png")];
    }
    [customView setImageEdgeInsets:UIEdgeInsetsMake(3, 145, 3, 0)];
    [customView setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 15)];
    return view;
}
-(void)onClick:(id)sender{
    UIButton *btn = (UIButton *)sender;
    BOOL isSelSection = NO;
    _tmpSection = btn.tag;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (_tmpSection == selSection) {
            isSelSection = YES;
            [self.arrSelSection removeObjectAtIndex:i];
            break;
        }
    }
    if (!isSelSection) {
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%i",_tmpSection]];
    }
    UITableView *tableView = (UITableView *)[[btn superview] superview];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [tableView reloadData];
    [UIView commitAnimations];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lessonList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            return 0;
        }
    }
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
    count = lesson.chapterList.count;
    return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSInteger section = indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    BOOL isSelSection = NO;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            isSelSection = YES;
            break;
        }
    }
    if (!isSelSection) {
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        
        [cell.textLabel setFont:[UIFont systemFontOfSize:18]];
        cell.textLabel.text = chapter.chapterName;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
    chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
    DLog(@"id = %@",chapter.chapterId);
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    ForgotPwdViewController *forgotControl = [story instantiateViewControllerWithIdentifier:@"ForgotPwdViewController"];
    forgotControl.view.frame = (CGRect){50,0,768-50,1024};
//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    app.popupedController = self;
    [self presentPopupViewController:forgotControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO];
}
@end
