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
static NSString *chapterName;
typedef enum {LESSON_LIST,QUEATION_LIST}TableListType;

@interface LessonViewController ()
@property(nonatomic,assign) TableListType listType;
@property (nonatomic,strong) NSString *questionAndSwerRequestID;//请求问题列表ID
@property (nonatomic,assign) QuestionAndAnswerScope questionScope;
@property (nonatomic,strong) GetUserQuestionInterface *getUserQuestionInterface;
@property (nonatomic,strong) SearchQuestionInterface *searchQuestionInterface;//搜索问答接口
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        LessonInfoInterface *lessonInter = [[LessonInfoInterface alloc]init];
        self.lessonInterface = lessonInter;
        self.lessonInterface.delegate = self;
        [self.lessonInterface getLessonInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
    }
}
-(void)getQuestionInfo  {
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
        self.questionInfoInterface = questionInfoInter;
        self.questionInfoInterface.delegate = self;
        [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [CaiJinTongManager shared].isSettingView = NO;
    [self.tableView registerClass:[LessonListHeaderView class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    self.listType = LESSON_LIST;
    [Utility setBackgroungWithView:self.LogoImageView.superview andImage6:@"login_bg_7" andImage7:@"login_bg_7"];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    self.searchBarView.backgroundColor = [UIColor clearColor];
    self.searchText.backgroundColor = [UIColor clearColor];
    [self.searchText setBorderStyle:UITextBorderStyleNone];
    NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"搜索课程"];
    [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, placeholder.length)];
    self.searchText.attributedPlaceholder = placeholder;
    self.searchText.returnKeyType = UIReturnKeySearch;
    self.isSearching = NO;
    self.searchText.delegate = self;
    self.editBtn.backgroundColor = [UIColor clearColor];
    self.editBtn.alpha = 0.3;
    
//    NSLog(@"----user: %@----",[CaiJinTongManager shared].user);
//    self.rightNameLabel.text = [NSString stringWithFormat:@"欢迎您：%@",[CaiJinTongManager shared].user.userId];

    [self getLessonInfo];
}

#pragma mark UISearchBarDelegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    DLog(@"警告:lessionviewcontroller searchbarSearchButtonClicked");
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark LessonListHeaderViewDelegate
-(void)lessonHeaderView:(LessonListHeaderView *)header selectedAtIndex:(NSIndexPath *)path{
    [self.searchText resignFirstResponder];
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
            AppDelegate *app = [AppDelegate sharedInstance];
            app.isLocal = YES;
            Section *sectionDb = [[Section alloc]init];
            NSArray *local_array = [sectionDb getAllInfo];

            if (local_array.count>0) {
                UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
                ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
                if(self.isSearching)chapterView.isSearch = YES;
                chapterView.searchBar.searchTextField.text = self.searchText.text;
                
                [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:local_array]];
                self.isSearching = NO;
                UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:chapterView];
                navControl.view.frame = (CGRect){0,0,568,1024};
                [navControl setNavigationBarHidden:YES];
                [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                }];
            }else {
                [Utility errorAlert:@"暂无数据!"];
            }
        }
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
#pragma mark --

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    if (self.listType == LESSON_LIST) {
       return 50;
    }else{
        return 50;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.listType == LESSON_LIST) {
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
//        if (section != self.lessonList.count-1) {
//            LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
//            LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
//            header.lessonTextLabel.font = [UIFont systemFontOfSize:18];
//            header.lessonTextLabel.text = lesson.lessonName;
//            header.lessonDetailLabel.text = [NSString stringWithFormat:@"%d",[lesson.chapterList count]];
//            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
//            header.delegate = self;
//            BOOL isSelSection = NO;
//            for (int i = 0; i < self.arrSelSection.count; i++) {
//                NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
//                NSInteger selSection = strSection.integerValue;
//                if (section == selSection) {
//                    isSelSection = YES;
//                    break;
//                }
//            }
//            header.isSelected = isSelSection;
//            return header;
//        }else {
//            LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
//            header.flagImageView.image = Image(@"backgroundStar.png");
//            header.lessonTextLabel.text = @"本地下载";
//            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
//            header.delegate = self;
//            return header;
//        }
    }else{
        LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
        header.delegate = self;
        header.path = [NSIndexPath indexPathForRow:0 inSection:section];
        if (section == 0) {
            header.lessonTextLabel.text = @"所有问答";
        }else {
            header.lessonTextLabel.text = @"我的问答";
        }
        BOOL isSelSection = NO;
        for (int i = 0; i < self.questionArrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                isSelSection = YES;
                break;
            }
        }
        header.isSelected = isSelSection;
        return header;
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
        for (int i = 0; i < self.questionArrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                return 0;
            }
        }
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
        chapterName = [NSString stringWithFormat:@"%@",chapter.chapterName];
        [cell setIndentationLevel:2];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
        if (indexPath.section == 0) {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"questionName"]];
            [cell setIndentationLevel:[[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"level"]intValue]];
        }else{
            if (indexPath.row == 0) {
                cell.textLabel.text = @" 我的提问";
            }else{
                cell.textLabel.text = @" 我的回答";
            }
             [cell setIndentationLevel:2];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [CaiJinTongManager shared].isSettingView = NO;
    [self.searchText resignFirstResponder];
    if (self.listType == LESSON_LIST) {
        AppDelegate *app = [AppDelegate sharedInstance];
        app.isLocal = NO;
        self.isSearching = NO;
        //根据chapterId获取章下面视频信息
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
            self.chapterInterface = chapterInter;
            self.chapterInterface.delegate = self;
            [self.chapterInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:chapter.chapterId];
        }
    }else{
        if (indexPath.section==0) {
            NSDictionary *d=[self.questionList objectAtIndex:indexPath.row];
            if([d valueForKey:@"questionNode"]) {
                NSArray *ar=[d valueForKey:@"questionNode"];
                if (ar.count == 0) { //判定问题分类到最底层
                    //请求问题分类下详细问题信息
                    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
                        [Utility errorAlert:@"暂无网络!"];
                    }else {
                        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                        ChapterQuestionInterface *chapterInter = [[ChapterQuestionInterface alloc]init];
                        self.chapterQuestionInterface = chapterInter;
                        self.chapterQuestionInterface.delegate = self;
                        self.questionAndSwerRequestID = [d valueForKey:@"questionID"];
                        self.questionScope = QuestionAndAnswerALL;
                        [self.chapterQuestionInterface getChapterQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterQuestionId:[d valueForKey:@"questionID"]];
                    }
                }else {
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
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
            self.getUserQuestionInterface.delegate = self;
            switch (indexPath.row) {
                case 0:
                {
                    //请求我的提问
                    self.questionScope = QuestionAndAnswerMYQUESTION;
                     [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil];
                    break;
                }
                case 1:
                {
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
                     [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil];
                    break;
                }
                default:
                    break;
            }
            

//            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
//            MyQuestionAndAnswerViewController *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
//            UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:myQAVC];
//            [navControl setNavigationBarHidden:YES];
//            navControl.view.frame = (CGRect){0,0,568,1024};
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];

        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.questionList indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"questionNode"];
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
    [CaiJinTongManager shared].isSettingView = NO;
    self.listType = LESSON_LIST;
    [self getLessonInfo];
}

- (IBAction)questionListBtClicked:(id)sender {
    [CaiJinTongManager shared].isSettingView = NO;
    self.listType = QUEATION_LIST;
     [self getQuestionInfo];
    
//    if ([CaiJinTongManager shared].question.count == 0) {
//        [self getQuestionInfo];
//    }else {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
//            dispatch_async ( dispatch_get_main_queue (), ^{
//            [self.tableView reloadData];
//            });
//        });
//    }
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
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            if (self.listType == LESSON_LIST) {
                SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
                self.searchLessonInterface = searchLessonInter;
                self.searchLessonInterface.delegate = self;
                [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text];
            }else{
                [self.searchQuestionInterface getSearchQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text];
            }
        }
    }
}

-(IBAction)setBtnPressed:(id)sender {
    [CaiJinTongManager shared].isSettingView = YES;
    self.editBtn.alpha = 1.0;
    self.lessonListBt.alpha = 0.3;
    self.questionListBt.alpha = 0.3;
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    SettingViewController *settingView = [story instantiateViewControllerWithIdentifier:@"SettingViewController"];

    [CaiJinTongManager shared].defaultLeftInset = 184;
    [CaiJinTongManager shared].defaultPortraitTopInset = 250;
    [CaiJinTongManager shared].defaultWidth = 400;
    [CaiJinTongManager shared].defaultHeight = 500;
    settingView.view.frame =  (CGRect){184,250,400,500};
    DRNavigationController *navControl = [[DRNavigationController alloc]initWithRootViewController:settingView];
    navControl.view.frame = (CGRect){184,250,400,500};
    [navControl setNavigationBarHidden:YES];
    [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
    }];
}
#pragma mark property
-(SearchQuestionInterface *)searchQuestionInterface{
    if (!_searchQuestionInterface) {
        _searchQuestionInterface = [[SearchQuestionInterface alloc] init];
        _searchQuestionInterface.delegate = self;
    }
    return _searchQuestionInterface;
}

-(NSMutableArray *)questionArrSelSection{
    if (!_questionArrSelSection) {
        _questionArrSelSection = [NSMutableArray array];
    }
    return _questionArrSelSection;
}

-(void)setListType:(TableListType)listType{
    if (listType == LESSON_LIST) {
        self.lessonListTitleLabel.text = @"我的课程";
        self.lessonListBt.alpha = 1;
        self.questionListBt.alpha = 0.3;
        self.editBtn.alpha = 0.3;
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"搜索课程"];
        [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, placeholder.length)];
        self.searchText.attributedPlaceholder = placeholder;
    }else{
    self.lessonListTitleLabel.text = @"我的问答";
        NSMutableAttributedString *placeholder = [[NSMutableAttributedString alloc] initWithString:@"搜索我的问答"];
        [placeholder addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(0, placeholder.length)];
        self.searchText.attributedPlaceholder = placeholder;
        self.lessonListBt.alpha = 0.3;
        self.questionListBt.alpha = 1;
        self.editBtn.alpha = 0.3;
    }
    _listType = listType;
}
#pragma mark --

#pragma mark GetUserQuestionInterfaceDelegate 获取我的回答和我的提问列表
-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
    if (self.questionScope == QuestionAndAnswerMYQUESTION) {
        
    }else
        if (self.questionScope == QuestionAndAnswerMYANSWER) {
            
        }
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
   
}

-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            MyQuestionAndAnswerViewController *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
            UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:myQAVC];
            [navControl setNavigationBarHidden:YES];
            navControl.view.frame = (CGRect){0,0,568,1024};
            [myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                
            }];
        });
    });
}
#pragma mark --

#pragma mark SearchQuestionInterfaceDelegate搜索问答回调
-(void)getSearchQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

-(void)getSearchQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            MyQuestionAndAnswerViewController *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
            UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:myQAVC];
            [navControl setNavigationBarHidden:YES];
            navControl.view.frame = (CGRect){0,0,568,1024};
            [myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:QuestionAndAnswerALL];
            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                
            }];
        });
    });
}
#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
//            if(self.isSearching){   已失效
//                chapterView.drnavigationBar.titleLabel.text = @"搜索";
//                chapterView.isSearch = YES;
//            }else{
//                chapterView.drnavigationBar.titleLabel.text = chapterName;
//            }
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
//                chapterView.searchBar.searchTipLabel.text = [NSString stringWithFormat:@"以下是根据内容\"%@\"搜索出的内容",self.searchText.text];已失效
//                chapterView.searchBar.searchTextField.text = self.searchText.text;
//                self.isSearching = NO;
                DRNavigationController *navControl = [[DRNavigationController alloc]initWithRootViewController:chapterView];
                navControl.view.frame = (CGRect){0,0,568,1024};
                [navControl setNavigationBarHidden:YES];
                [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                }];
            }
        });
    });
}

-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark-- LessonInfoInterfaceDelegate
-(void)getLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.lessonList = [NSMutableArray arrayWithArray:[result objectForKey:@"lessonList"]];
//        [self.lessonList  addObject:@"本地下载"];
        
        //标记是否选中了
        self.arrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.lessonList.count; i++) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

-(void)getLessonInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark--QuestionInfoInterfaceDelegate {
-(void)getQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.questionList = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
        [CaiJinTongManager shared].question = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
        //标记是否选中了
        self.questionArrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.questionList.count; i++) {
            [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.listType = LESSON_LIST;
    [Utility errorAlert:errorMsg];
}
#pragma mark--ChapterQuestionInterfaceDelegate
-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            MyQuestionAndAnswerViewController *myQAVC = [story instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
            UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:myQAVC];
            [navControl setNavigationBarHidden:YES];
            navControl.view.frame = (CGRect){0,0,568,1024};
            [myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                
            }];
        });
    });
}
-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark--SearchLessonInterfaceDelegate
-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            ChapterViewController *chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
            
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                if(self.isSearching){
                    chapterView.drnavigationBar.titleLabel.text = @"搜索";
                    chapterView.isSearch = YES;
                    [chapterView.searchBar addSearchText:self.searchText.text];
                    chapterView.oldSearchText = self.searchText.text;
                }
                [chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
                self.isSearching = NO;
                UINavigationController *navControl = [[UINavigationController alloc]initWithRootViewController:chapterView];
                navControl.view.frame = (CGRect){0,0,568,1024};
                [navControl setNavigationBarHidden:YES];
                [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
                }];
            }else{
                [Utility errorAlert:@"无搜索结果"];
            }
        });
    });
}
-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg {
     [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self SearchBrClicked:nil];//点击键盘return键搜索
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchText resignFirstResponder];
}
@end
