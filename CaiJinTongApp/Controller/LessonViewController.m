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
#import "Section.h"
#import "ForgotPwdViewController.h"

#import "QuestionModel.h"
#import "LessonQuestionModel.h"
#import "ChapterQuestionModel.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SettingViewController.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"
typedef enum {LESSON_LIST,QUEATION_LIST}TableListType;

@interface LessonViewController ()
@property(nonatomic,assign) TableListType listType;
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
-(void)getLessonInfo {
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
        LessonInfoInterface *lessonInter = [[LessonInfoInterface alloc]init];
        self.lessonInterface = lessonInter;
        self.lessonInterface.delegate = self;
        [self.lessonInterface getLessonInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[LessonListHeaderView class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    self.listType = LESSON_LIST;
//    [self initTestData];
    [self getLessonInfo];
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
    [self.lessonList  addObject:@"本地下载"];

    //标记是否选中了
    self.arrSelSection = [[NSMutableArray alloc] init];
    for (int i =0; i<self.lessonList.count; i++) {
        [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    
    //question
    LessonQuestionModel *myquestion = [[LessonQuestionModel alloc] init];
    myquestion.lessonQuestionName = @"我的提问";
    [self.questionList addObject:myquestion];
    LessonQuestionModel *myAnswer= [[LessonQuestionModel alloc] init];
    myAnswer.lessonQuestionName = @"我的回答";
    [self.questionList addObject:myAnswer];
    
    for (int index = 0; index < 20; index++) {
        LessonQuestionModel *qu = [[LessonQuestionModel alloc] init];
        qu.lessonQuestionName = @"TEST";
        NSMutableArray *chapterQu = [NSMutableArray array];
        for (int i =0; i < 20; i++) {
            ChapterQuestionModel *model = [[ChapterQuestionModel alloc] init];
            model.chapterQuestionName = @"水电管理学";
            [chapterQu addObject:model];
        }
        qu.chapterQuestionList = chapterQu;
        [self.questionList addObject:qu];
    }
    for (int i =0; i<self.questionList.count; i++) {
        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
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
    if (self.listType == LESSON_LIST) {
        if (path.section != self.lessonList.count-1) {
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
        }else {//本地课程
            //本地数据的获取
//            Section *sectionDb = [[Section alloc]init];
//            NSArray *local_array = [sectionDb getAllInfo];
        }
    }else{
        if (path.section == 0) {
            header.isSelected = NO;
        }else
        if (path.section == 1) {
            header.isSelected = NO;
        }else{
            BOOL isSelSection = NO;
            _questionTmpSection = path.section;
            for (int i = 0; i < self.questionArrSelSection.count; i++) {
                NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
                NSInteger selSection = strSection.integerValue;
                if (_questionTmpSection == selSection) {
                    isSelSection = YES;
                    [self.questionArrSelSection removeObjectAtIndex:i];
                    break;
                }
            }
            if (!isSelSection) {
                [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%i",_questionTmpSection]];
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}
#pragma mark --

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.listType == LESSON_LIST) {
        if (section != self.lessonList.count-1) {
            LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
            LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
            header.lessonTextLabel.font = [UIFont systemFontOfSize:18];
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
        }else {
            LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
            header.flagImageView.image = Image(@"backgroundStar.png");
            header.lessonTextLabel.text = @"本地下载";
            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
            header.delegate = self;
            return header;
        }
    }else{
        LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
        LessonQuestionModel *question = (LessonQuestionModel *)[self.questionList objectAtIndex:section];
        header.lessonTextLabel.text =question.lessonQuestionName;
        header.lessonDetailLabel.text = [NSString stringWithFormat:@"%d",[question.chapterQuestionList count]];
        header.path = [NSIndexPath indexPathForRow:0 inSection:section];
        header.delegate = self;
        BOOL isSelSection = NO;
        for (int i = 0; i < self.questionArrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                isSelSection = YES;
                break;
            }
        }
        if (section > 1) {
                    header.isSelected = isSelSection;
        }

        return header;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listType == LESSON_LIST) {
         return self.lessonList.count;
    }else{
        return  self.questionList.count;
    }
   
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.listType == LESSON_LIST) {
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
    }else{
        if (section < 2) {
            return 0;
        }
        NSInteger count = 0;
        for (int i = 0; i < self.questionArrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                return 0;
            }
        }
        LessonQuestionModel *question = (LessonQuestionModel *)[self.questionList objectAtIndex:section];
        count = question.chapterQuestionList.count;
        return count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == LESSON_LIST) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = chapter.chapterName;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",chapter.chapterImg]];
        [cell.imageView setImageWithURL:url placeholderImage:Image(@"defualt.jpg")];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        LessonQuestionModel *question = (LessonQuestionModel *)[self.questionList objectAtIndex:indexPath.section];
        
        ChapterQuestionModel*chapter = (ChapterQuestionModel *)[question.chapterQuestionList objectAtIndex:indexPath.row];
        cell.textLabel.text = chapter.chapterQuestionName;
        
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == LESSON_LIST) {
        //根据chapterId获取章下面视频信息
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
            self.chapterInterface = chapterInter;
            self.chapterInterface.delegate = self;
            [self.chapterInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:chapter.chapterId];
        }
         /*
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
        }
        //
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
        chapterView.view.frame = CGRectMake(50, 20, 768-200, 1024-20);
        if (tempArray.count>0) {
            chapterView.recentArray = [[NSMutableArray alloc]initWithArray:tempArray];
            tempArray = nil;
        }
        
        [self presentPopupViewController:chapterView animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO];
          */
    }else{

    }
}
- (IBAction)lessonListBtClicked:(id)sender {
    self.listType = LESSON_LIST;
    dispatch_async ( dispatch_get_main_queue (), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)questionListBtClicked:(id)sender {
    self.listType = QUEATION_LIST;
    dispatch_async ( dispatch_get_main_queue (), ^{
        [self.tableView reloadData];
    });
}

-(IBAction)setBtnPressed:(id)sender {
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    SettingViewController *setView = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];
}
#pragma mark property
-(NSMutableArray *)questionArrSelSection{
    if (!_questionArrSelSection) {
        _questionArrSelSection = [NSMutableArray array];
    }
    return _questionArrSelSection;
}

-(NSMutableArray *)questionList{
    if (!_questionList) {
        _questionList = [NSMutableArray array];
    }
    return _questionList;
}

-(void)setListType:(TableListType)listType{
    if (listType == LESSON_LIST) {
        self.lessonListTitleLabel.text = @"我的课程";
        self.lessonListBt.alpha = 1;
        self.questionListBt.alpha = 0.3;
    }else{
    self.lessonListTitleLabel.text = @"我的问答";
        self.lessonListBt.alpha = 0.3;
        self.questionListBt.alpha = 1;
    }
    _listType = listType;
}
#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
            chapterView.view.frame = CGRectMake(50, 20, 768-200, 1024-20);
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                chapterView.recentArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self presentPopupViewController:chapterView animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO];
            }
        });
    });
}
-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}

#pragma mark-- LessonInfoInterfaceDelegate
-(void)getLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        self.lessonList = [NSMutableArray arrayWithArray:[result objectForKey:@"lessonList"]];
        [self.lessonList  addObject:@"本地下载"];
        
        //标记是否选中了
        self.arrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.lessonList.count; i++) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}
-(void)getLessonInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
@end
