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
#import "MyQuestionAndAnswerViewController.h"
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
    [Utility setBackgroungWithView:self.LogoImageView.superview andImage6:@"login_bg" andImage7:@"login_bg_7"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    self.searchBarView.backgroundColor = [UIColor clearColor];
    self.searchText.backgroundColor = [UIColor clearColor];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"搜索课程"];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, placeholder.length)];
    self.searchText.attributedPlaceholder = placeholder;
    self.searchText.returnKeyType = UIReturnKeySearch;
    self.isSearching = NO;
    self.searchText.delegate = self;
    self.editBtn.backgroundColor = [UIColor clearColor];
    self.editBtn.alpha = 0.3;
//    self.searchBarView.tintColor = [UIColor clearColor];
//    self.searchBarView.backgroundImage = [UIImage new];
//    self.searchBarView.translucent = YES;
//    self.searchBarView.tintColor = [UIColor redColor];
//    self.searchBarView.backgroundImage = [UIImage imageNamed:@"1.png"];
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
    
    
//    //question
//    LessonQuestionModel *myquestion = [[LessonQuestionModel alloc] init];
//    myquestion.lessonQuestionName = @"我的提问";
//    [self.questionList addObject:myquestion];
//    LessonQuestionModel *myAnswer= [[LessonQuestionModel alloc] init];
//    myAnswer.lessonQuestionName = @"我的回答";
//    [self.questionList addObject:myAnswer];
//    
//    for (int index = 0; index < 20; index++) {
//        LessonQuestionModel *qu = [[LessonQuestionModel alloc] init];
//        qu.lessonQuestionName = @"TEST";
//        NSMutableArray *chapterQu = [NSMutableArray array];
//        for (int i =0; i < 20; i++) {
//            ChapterQuestionModel *model = [[ChapterQuestionModel alloc] init];
//            model.chapterQuestionName = @"水电管理学";
//            [chapterQu addObject:model];
//        }
//        qu.chapterQuestionList = chapterQu;
//        [self.questionList addObject:qu];
//    }
//    for (int i =0; i<self.questionList.count; i++) {
//        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
//    }
}
#pragma mark --

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"警告:lessionviewcontroller searchbarSearchButtonClicked");
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
            Section *sectionDb = [[Section alloc]init];
            NSArray *local_array = [sectionDb getAllInfo];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            [CaiJinTongManager shared].defaultLeftInset = 200;
            [CaiJinTongManager shared].defaultPortraitTopInset = 20;
            [CaiJinTongManager shared].defaultWidth = 568;
            [CaiJinTongManager shared].defaultHeight = 984;
            
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
            if(self.isSearching)chapterView.isSearch = YES;
            chapterView.searchBar.searchTextField.text = self.searchText.text;
            
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
    if (self.listType == LESSON_LIST) {
       return 50;
    }else{
        if (section == 0) {
            return 50;
        }else{
            return 50;
        }
    }
    
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
        if (section == 0) {
            header.lessonTextLabel.text = @"所有问答";
            header.lessonDetailLabel.text = [NSString stringWithFormat:@"5"];
            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
            header.delegate = self;
            header.isSelected = NO;
            return header;
        }else {
            header.lessonTextLabel.text = @"我的问答";
            header.lessonDetailLabel.text = [NSString stringWithFormat:@"5"];
            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
            header.delegate = self;
            header.isSelected = NO;
//            [header setNeedsDisplay];
            return header;
        }
        }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.listType == LESSON_LIST) {
         return self.lessonList.count;
    }else{
        return  2;
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
        if (section == 0) {
            return self.questionList.count;
        }else{
            return 2;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.listType == LESSON_LIST) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lessonCell"];
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        cell.textLabel.text = chapter.chapterName;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
//        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",chapter.chapterImg]];
//        [cell.imageView setImageWithURL:url placeholderImage:Image(@"defualt.jpg")];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        if (indexPath.section == 0) {
            cell.textLabel.text=[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"name"];
            [cell setIndentationLevel:[[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"level"] intValue]];
        }else{
            if (indexPath.row == 0) {
                cell.textLabel.text = @"   我的提问";
            }else{
                cell.textLabel.text = @"   我的回答";
            }
        }

        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }

}
static NSString *titleName = nil;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.listType == LESSON_LIST) {
        self.isSearching = NO;
        //根据chapterId获取章下面视频信息
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            titleName = cell.textLabel.text;
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
        [CaiJinTongManager shared].defaultLeftInset = 200;
        [CaiJinTongManager shared].defaultPortraitTopInset = 20;
        [CaiJinTongManager shared].defaultWidth = 568;
        [CaiJinTongManager shared].defaultHeight = 1004;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
        if (tempArray.count>0) {
            [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
            tempArray = nil;
        }
        UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:chapterView];
        MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:navControl];
        formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromRight;
        formSheet.shadowRadius = 2.0;
        formSheet.shadowOpacity = 0.3;
        formSheet.shouldDismissOnBackgroundViewTap = YES;
        formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
        
        [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
            
        }];
        */
    }else{
//        MyQuestionAndAnswerViewController *myQuestionAndAnswerController = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
        if (indexPath.section==0) {
            NSDictionary *d=[self.questionList objectAtIndex:indexPath.row];
            if([d valueForKey:@"Objects"]) {
                NSArray *ar=[d valueForKey:@"Objects"];
                
                BOOL isAlreadyInserted=NO;
                
                for(NSDictionary *dInner in ar ){
                    NSInteger index=[self.questionList indexOfObjectIdenticalTo:dInner];
                    isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                    if(isAlreadyInserted) break;
                }
                
                if(isAlreadyInserted) {
                    [self miniMizeThisRows:ar];
                } else {
                    NSUInteger count=indexPath.row+1;
                    NSMutableArray *arCells=[NSMutableArray array];
                    for(NSDictionary *dInner in ar ) {
                        [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                        [self.questionList insertObject:dInner atIndex:count++];
                    }
                    [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
                }
            }
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.questionList indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"Objects"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.questionList indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.questionList removeObjectIdenticalTo:dInner];
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
		}
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
    NSDictionary *dTmp=[[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"data" ofType:@"plist"]];
    self.questionList = [NSMutableArray arrayWithArray:[dTmp valueForKey:@"Objects"]];
    dispatch_async ( dispatch_get_main_queue (), ^{
        [self.tableView reloadData];
    });
}

- (IBAction)SearchBrClicked:(id)sender {
    if (self.searchText.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
    }else {
        [self.searchText resignFirstResponder];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            self.isSearching = YES;
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
            self.searchLessonInterface = searchLessonInter;
            self.searchLessonInterface.delegate = self;
            [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text];
        }
    }
}
/*
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isSearch = NO;
    if (self.searchText.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
        isSearch = NO;
    }else {
        isSearch = YES;
        [self.searchText resignFirstResponder];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            self.isSearching = YES;
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
            self.searchLessonInterface = searchLessonInter;
            self.searchLessonInterface.delegate = self;
            [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text];
        }
    }
    return isSearch;
}
 */
-(IBAction)setBtnPressed:(id)sender {
    self.editBtn.alpha = 1.0;
    self.lessonListBt.alpha = 0.3;
    self.questionListBt.alpha = 0.3;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    UIViewController *vc = [story instantiateViewControllerWithIdentifier:@"modal"];

    [CaiJinTongManager shared].defaultLeftInset = 184;
    [CaiJinTongManager shared].defaultPortraitTopInset = 250;
    [CaiJinTongManager shared].defaultWidth = 400;
    [CaiJinTongManager shared].defaultHeight = 500;
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromRight;
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVerticallyWhenKeyboardAppears = NO;//lhl修改,取消界面在键盘出现时移动
    formSheet.shouldMoveToTopWhenKeyboardAppears = NO;
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
    
}
#pragma mark property
-(NSMutableArray *)questionArrSelSection{
    if (!_questionArrSelSection) {
        _questionArrSelSection = [NSMutableArray array];
    }
    return _questionArrSelSection;
}

//-(NSMutableArray *)questionList{
//    if (!_questionList) {
//        _questionList = [NSMutableArray array];
//    }
//    return _questionList;
//}

-(void)setListType:(TableListType)listType{
    if (listType == LESSON_LIST) {
        self.lessonListTitleLabel.text = @"我的课程";
        self.lessonListBt.alpha = 1;
        self.questionListBt.alpha = 0.3;
        self.editBtn.alpha = 0.3;
    }else{
    self.lessonListTitleLabel.text = @"我的问答";
        self.lessonListBt.alpha = 0.3;
        self.questionListBt.alpha = 1;
        self.editBtn.alpha = 0.3;
    }
    _listType = listType;
}
#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];

        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            [CaiJinTongManager shared].defaultLeftInset = 200;
            [CaiJinTongManager shared].defaultPortraitTopInset = 20;
            [CaiJinTongManager shared].defaultWidth = 568;
            [CaiJinTongManager shared].defaultHeight = 984;
            
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
            if(self.isSearching)chapterView.isSearch = YES;
            chapterView.searchBar.searchTextField.text = self.searchText.text;
            
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                if (titleName) {
                    chapterView.title = titleName;
                }else{
                    chapterView.title = @"搜索";
                }
                if(self.isSearching){
                    if(self.searchText.text != nil && ![self.searchText.text isEqualToString:@""] && tempArray.count > 0){
                        NSString *keyword = self.searchText.text;
                        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:5];
                        for(int i = 0 ; i < tempArray.count ; i++){
                            SectionModel *section = [tempArray objectAtIndex:i];
                            NSRange range = [section.sectionName rangeOfString:[NSString stringWithFormat:@"(%@)+",keyword] options:NSRegularExpressionSearch];
                            if(range.location != NSNotFound){
                                [ary addObject:section];
                            }
                        }
                        tempArray = [NSMutableArray arrayWithArray:ary];
                    }
                }
                [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
                self.isSearching = NO;
                UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:chapterView];
                
                
                MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:navControl];
                formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromRight;
                formSheet.shadowRadius = 2.0;
                formSheet.shadowOpacity = 0.3;
                formSheet.shouldDismissOnBackgroundViewTap = YES;
                formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
                
                [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                   
                }];
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

#pragma mark--SearchLessonInterfaceDelegate
-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            [CaiJinTongManager shared].defaultLeftInset = 200;
            [CaiJinTongManager shared].defaultPortraitTopInset = 20;
            [CaiJinTongManager shared].defaultWidth = 568;
            [CaiJinTongManager shared].defaultHeight = 984;
            
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
            if(self.isSearching)chapterView.isSearch = YES;
            chapterView.searchBar.searchTextField.text = self.searchText.text;
            
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                DLog(@"count = %d",tempArray.count);
                if (titleName) {
                    chapterView.title = titleName;
                }else{
                    chapterView.title = @"搜索";
                }
                if(self.isSearching){
                    if(self.searchText.text != nil && ![self.searchText.text isEqualToString:@""] && tempArray.count > 0){
                        NSString *keyword = self.searchText.text;
                        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:5];
                        for(int i = 0 ; i < tempArray.count ; i++){
                            SectionModel *section = [tempArray objectAtIndex:i];
                            NSRange range = [section.sectionName rangeOfString:[NSString stringWithFormat:@"(%@)+",keyword] options:NSRegularExpressionSearch];
                            if(range.location != NSNotFound){
                                [ary addObject:section];
                            }
                        }
                        tempArray = [NSMutableArray arrayWithArray:ary];
                    }
                }
                [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
                self.isSearching = NO;
                UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:chapterView];
                
                MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:navControl];
                formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromRight;
                formSheet.shadowRadius = 2.0;
                formSheet.shadowOpacity = 0.3;
                formSheet.shouldDismissOnBackgroundViewTap = YES;
                formSheet.shouldCenterVerticallyWhenKeyboardAppears = YES;
                
                [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                    
                }];
            }
        });
    });
}
-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
@end
