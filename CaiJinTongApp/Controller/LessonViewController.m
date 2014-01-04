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
@property (nonatomic, strong) DRTreeTableView *drTreeTableView;
@property (nonatomic, strong) MyQuestionAndAnswerViewController *myQAVC ;
@property (nonatomic, strong) ChapterViewController *chapterView;
@property (nonatomic, strong) NSArray *allQuestionCategoryArr;//所有问答分类信息
@property (nonatomic, strong) NSArray *myQuestionCategoryArr;//我的提问分类信息
@property (nonatomic, strong) NSArray *myAnswerCategoryArr;//我的回答分类信息
@property (nonatomic, strong) DRNavigationController *lessonNavigationController;
@property (nonatomic, strong) DRNavigationController *questionNavigationController;
//组合所有问答分类，我的提问问答分类，我的回答分类
-(NSMutableArray*)togetherAllQuestionCategorys;
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

//获取课程分类信息
-(void)downloadLessonCategoryInfo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.lessonCategoryInterface downloadLessonCategoryDataWithUserId:[[[CaiJinTongManager shared] user] userId]];
}

-(void)downloadLessonListForCatogory{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.chapterView.sortType];
}

//获取我的问答分类信息
-(void)getMyQuestionCategoryList{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.myQuestionCategatoryInterface downloadMyQuestionCategoryDataWithUserId:user.userId];
    }
}

//获取所有问答分类信息
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

-(void)hiddleSearchKeyboard{
    [self.searchText resignFirstResponder];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddleSearchKeyboard) name:@"hiddleSearchKeyboardNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingViewControllerDismis) name:@"SettingViewControllerDismiss" object:nil];
    self.listType = LESSON_LIST;
    [Utility setBackgroungWithView:self.LogoImageView.superview andImage6:@"login_bg_7" andImage7:@"login_bg_7"];
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
    
    self.drTreeTableView.backgroundColor = [UIColor colorWithRed:12/255.0 green:43/255.0 blue:75/255.0 alpha:1];
    [self.lessonListBackgroundView addSubview:self.drTreeTableView];
    
    if (self.lessonNavigationController) {
        [self addChildViewController:_lessonNavigationController];
        _lessonNavigationController.view.frame = (CGRect){305,0,768-305,1024};
        [self.view addSubview:_lessonNavigationController.view];
        [_lessonNavigationController didMoveToParentViewController:self];
    }
    
    [self downloadLessonCategoryInfo];
    //按默认顺序加载
    [self downloadLessonListForCatogory];
    
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


#pragma mark SettingViewController dismiss notification
-(void)settingViewControllerDismis{
    self.listType = self.listType;
}
#pragma mark --


- (IBAction)lessonListBtClicked:(id)sender {
    self.listType = LESSON_LIST;
    self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:[TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]]];
    if (_questionNavigationController) {
        [_questionNavigationController willMoveToParentViewController:nil];
        [_questionNavigationController.view removeFromSuperview];
        [_questionNavigationController removeFromParentViewController];
    }
    if (self.lessonNavigationController) {
        [self addChildViewController:_lessonNavigationController];
        _lessonNavigationController.view.frame = (CGRect){305,0,768,1024-250};
        [self.view addSubview:_lessonNavigationController.view];
        [_lessonNavigationController didMoveToParentViewController:self];
    }
    
//    [self.navigationController pushViewController:self.chapterView animated:YES];
//    self.navigationController.view.frame = (CGRect){305,0,719,779};;
//    self.chapterView.view.frame = (CGRect){305,0,719,779};;
    [self downloadLessonCategoryInfo];
}

- (IBAction)questionListBtClicked:(id)sender {
    [self.searchText resignFirstResponder];
    self.listType = QUEATION_LIST;
    if (_lessonNavigationController) {
        [_lessonNavigationController willMoveToParentViewController:nil];
        [_lessonNavigationController.view removeFromSuperview];
        [_lessonNavigationController removeFromParentViewController];
    }
    if (self.questionNavigationController) {
        [self addChildViewController:_questionNavigationController];
        _questionNavigationController.view.frame = (CGRect){305,0,768,1024-250};
        [self.view addSubview:_questionNavigationController.view];
        [_questionNavigationController didMoveToParentViewController:self];
    }
     [self getQuestionInfo];
     [self getMyQuestionCategoryList];
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
                [self.lessonNavigationController popToRootViewControllerAnimated:YES];
                SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
                self.searchLessonInterface = searchLessonInter;
                self.searchLessonInterface.delegate = self;
                [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text withPageIndex:0 withSortType:LESSONSORTTYPE_CurrentStudy];
            }else{
                [self.questionNavigationController popToRootViewControllerAnimated:YES];
                 [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                [self.searchQuestionInterface getSearchQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text withLastQuestionId:@"0"];
            }
        }
    }
}

//设置界面
-(IBAction)setBtnPressed:(id)sender {
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
    [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:YES dismissed:^{
    }];
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}

-(BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
#pragma mark --

-(void)reLoadQuestionWithQuestionScope:(QuestionAndAnswerScope)scope withTreeNode:(DRTreeNode*)node{
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
//             [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.questionAndSwerRequestID = node.noteContentID;
            switch (scope) {
                case QuestionAndAnswerALL:
                {
                    ChapterQuestionInterface *chapterInter = [[ChapterQuestionInterface alloc]init];
                    self.chapterQuestionInterface = chapterInter;
                    self.chapterQuestionInterface.delegate = self;
                    self.questionAndSwerRequestID = node.noteContentID;
                    self.questionScope = QuestionAndAnswerALL;
//                    NSMutableArray *array = [TestModelData getQuestion];
//                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.chapterQuestionInterface getChapterQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterQuestionId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYQUESTION:
                {
                    //请求我的提问
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    self.questionScope = QuestionAndAnswerMYQUESTION;
//                    NSMutableArray *array = [TestModelData getQuestion];
//                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYANSWER:
                {
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
//                    NSMutableArray *array = [TestModelData getQuestion];
//                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
                    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                default:
                    break;
            }
    }
}

//组合所有问答分类，我的提问问答分类，我的回答分类
-(NSMutableArray*)togetherAllQuestionCategorys{
    //我的提问列表
    DRTreeNode *myQuestion = [[DRTreeNode alloc] init];
    myQuestion.noteContentID = @"-1";
    myQuestion.noteContentName = @"我的提问";
    myQuestion.childnotes = self.myQuestionCategoryArr;
    //所有问答列表
    DRTreeNode *question = [[DRTreeNode alloc] init];
    question.noteContentID = @"-2";
    question.noteContentName = @"所有问答";
    question.childnotes = self.allQuestionCategoryArr;
    
    //我的回答列表
    DRTreeNode *myAnswer = [[DRTreeNode alloc] init];
    myAnswer.noteContentID = @"-3";
    myAnswer.noteContentName = @"我的回答";
    myAnswer.childnotes = self.myAnswerCategoryArr;
    //我的问答
    DRTreeNode *my = [[DRTreeNode alloc] init];
    my.noteContentID = @"-4";
    my.noteContentName = @"我的问答";
    my.childnotes = @[myQuestion,myAnswer];
    
    return [NSMutableArray arrayWithArray:@[question,my]];
}

#pragma mark DRTreeTableViewDelegate //选择一个分类
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    if (self.listType == LESSON_LIST) {
        [self.lessonNavigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.lessonListForCategory downloadLessonListForCategoryId:selectedNote.noteContentID withUserId:user.userId withPageIndex:0 withSortType:self.chapterView.sortType];
    }else{
        [self.questionNavigationController popToRootViewControllerAnimated:YES];
        switch ([selectedNote.noteRootContentID integerValue]) {
            case -2://所有问答
            {
                self.questionScope = QuestionAndAnswerALL;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -1://我的提问
            {
                self.questionScope = QuestionAndAnswerMYQUESTION;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -3://我的回答
            {
                self.questionScope = QuestionAndAnswerMYANSWER;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -4://我的问答
            {
            }
                break;
            default:{
            
            }
                break;
        }
    }
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}
#pragma mark --

#pragma mark property
-(ChapterViewController *)chapterView{
    if (!_chapterView) {
        _chapterView= [self.storyboard instantiateViewControllerWithIdentifier:@"ChapterViewController"];
    }
    return _chapterView;
}
-(MyQuestionAndAnswerViewController *)myQAVC{
    if (!_myQAVC) {
        _myQAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
    }
    return _myQAVC;
}


-(DRNavigationController *)lessonNavigationController{
    if (!_lessonNavigationController) {
        _lessonNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.chapterView];
        [_lessonNavigationController setNavigationBarHidden:YES];
    }
    return _lessonNavigationController;
}

-(DRNavigationController *)questionNavigationController{
    if (!_questionNavigationController) {
        _questionNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.myQAVC];
        [_questionNavigationController setNavigationBarHidden:YES];
    }
    return _questionNavigationController;
}

-(MyQuestionCategatoryInterface *)myAnswerCategatoryInterface{
    if (!_myAnswerCategatoryInterface) {
        _myAnswerCategatoryInterface = [[MyQuestionCategatoryInterface alloc] init];
        _myAnswerCategatoryInterface.delegate = self;
    }
    return _myAnswerCategatoryInterface;
}

-(MyQuestionCategatoryInterface *)myQuestionCategatoryInterface{
    if (!_myQuestionCategatoryInterface) {
        _myQuestionCategatoryInterface = [[MyQuestionCategatoryInterface alloc] init];
        _myQuestionCategatoryInterface.delegate = self;
    }
    return _myQuestionCategatoryInterface;
}
-(LessonListForCategory *)lessonListForCategory{
    if (!_lessonListForCategory) {
        _lessonListForCategory = [[LessonListForCategory alloc] init];
        _lessonListForCategory.delegate = self;
    }
    return _lessonListForCategory;
}

-(DRTreeTableView *)drTreeTableView{
    if (!_drTreeTableView) {
//        _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){0,90,222,670} withTreeNodeArr:[TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]]];
         _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){0,90,222,670} withTreeNodeArr:nil];
//        _drTreeTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        _drTreeTableView.delegate = self;
    }
    return _drTreeTableView;
}

-(LessonCategoryInterface *)lessonCategoryInterface{
    if (!_lessonCategoryInterface) {
        _lessonCategoryInterface = [[LessonCategoryInterface alloc] init];
        _lessonCategoryInterface.delegate = self;
    }
    return _lessonCategoryInterface;
}

-(SearchQuestionInterface *)searchQuestionInterface{
    if (!_searchQuestionInterface) {
        _searchQuestionInterface = [[SearchQuestionInterface alloc] init];
        _searchQuestionInterface.delegate = self;
    }
    return _searchQuestionInterface;
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
    self.lessonListTitleLabel.text = @"问答中心";
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

#pragma mark MyQuestionCategatoryInterfaceDelegate 获取我的问答分类接口
-(void)getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:(NSArray *)myAnswerCategoryNotes withMyQuestionCategorynodes:(NSArray *)myQuestionCategoryNotes{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.myAnswerCategoryArr = myAnswerCategoryNotes;
        self.myQuestionCategoryArr = myQuestionCategoryNotes;
        self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
    });
}

-(void)getMyQuestionCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark LessonListForCategoryDelegate 根据分类获取课程信息
-(void)getLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.chapterView.lessonListForCategory.currentPageIndex = 0;
        self.chapterView.isSearch = NO;
        [self.chapterView reloadDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId];
    });
}

-(void)getLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
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
            [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
        });
    });
}
#pragma mark --

#pragma mark SearchQuestionInterfaceDelegate搜索问答回调
-(void)getSearchQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

-(void)getSearchQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            self.myQAVC.searchQuestionText = self.searchText.text;
 [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:QuestionAndAnswerSearchQuestion];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
        });
    });
}
#pragma mark --

#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
//                [self.chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
            }else{
                [Utility errorAlert:@"没有加载到数据"];
            }
        });
    });
}

-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark--QuestionInfoInterfaceDelegate 获取所有问答分类信息
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        self.allQuestionCategoryArr = questionCategoryArr;
        [[CaiJinTongManager shared] setQuestionCategoryArr:questionCategoryArr] ;
        self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    self.listType = LESSON_LIST;
    [Utility errorAlert:errorMsg];
}
#pragma mark--ChapterQuestionInterfaceDelegate所有问答数据
-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
 [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
        });
    });
}
-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


#pragma mark--SearchLessonInterfaceDelegate

-(void)getSearchLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chapterView.isSearch = YES;
        self.chapterView.oldSearchText = self.searchText.text;
        [self.chapterView reloadDataWithDataArray:lessonList withCategoryId:nil];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

-(void)getSearchLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --

#pragma mark LessonCategoryInterfaceDelegate获取课程分类信息
-(void)getLessonCategoryDataDidFinished:(NSArray *)categoryNotes{
dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:categoryNotes];
});
}

-(void)getLessonCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self SearchBrClicked:nil];//点击键盘return键搜索
    return YES;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.searchText resignFirstResponder];
}

#pragma mark touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.searchText resignFirstResponder];
}
#pragma mark --
@end
