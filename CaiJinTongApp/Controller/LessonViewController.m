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

#import "ChapterViewController.h"
#import "SectionModel.h"

#import "ForgotPwdViewController.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"

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
    [self.tableView registerClass:[LessonListHeaderView class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    [self initTestData];
}

#pragma mark test
-(void)initTestData{
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
}
#pragma mark --

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{

}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LessonListHeaderViewDelegate
-(void)lessonHeaderView:(LessonListHeaderView *)header selectedAtIndex:(NSIndexPath *)path{
    BOOL isSelSection = NO;
    _tmpSection = path.section;
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
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark --

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
    LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
    header.lessonTextLabel.text = lesson.lessonName;
    header.lessonDetailLabel.text = [NSString stringWithFormat:@"%d",[lesson.chapterList count]];
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    header.delegate = self;
    BOOL isSelSection = NO;
    for (int i = 0; i < self.arrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            isSelSection = YES;
            break;
        }
    }
    header.isSelected = isSelSection;
    return header;
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

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
    chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
    cell.textLabel.text = chapter.chapterName;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
    chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
    DLog(@"id = %@",chapter.chapterId);
    
    //数据来源
    NSDictionary *dictionary = [Utility initWithJSONFile:@"chapterInfo"];
    NSDictionary *dicc = [dictionary objectForKey:@"ReturnObject"];
    NSArray *sectionArray = [dicc objectForKey:@"sectionList"];
    NSMutableArray *tempArray = [[NSMutableArray alloc]init];
    if (sectionArray.count>0) {
        for (int i=0; i<sectionArray.count; i++) {
            NSDictionary *dic = [sectionArray objectAtIndex:i];
            SectionModel *section = [[SectionModel alloc]init];
            section.sectionId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionId"]];
            section.sectionName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionName"]];
            section.sectionImg = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionImg"]];
            section.sectionProgress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"sectionProgress"]];
            [tempArray addObject:section];
        }
        DLog(@"te = %@",tempArray);
    }
    //
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
    chapterView.view.frame = (CGRect){50,20,768-200,1024-20};
    DLog(@"te = %@",tempArray);
    if (tempArray.count>0) {
        chapterView.chapterArray = [[NSArray alloc]initWithArray:tempArray];
        tempArray = nil;
    }
    
    [self presentPopupViewController:chapterView animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO];
}
- (IBAction)lessonListBtClicked:(id)sender {
}

- (IBAction)questionListBtClicked:(id)sender {
}
@end
