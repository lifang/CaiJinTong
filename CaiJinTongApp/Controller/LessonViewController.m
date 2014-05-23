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
#import "LearningMaterialsViewController.h"
#import "NoteListViewController.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"
static NSString *chapterName;
typedef enum {
    LESSON_LIST,
    QUEATION_LIST,
    NOTELIST_LIST,
    LEARNINGMATERIALS_LIST,
    SETTING,
    DOWNLOADLIST
}TableListType;

@interface LessonViewController ()
@property(nonatomic,assign) TableListType listType;
@property (nonatomic,strong) NSString *questionAndSwerRequestID;//请求问题列表ID
@property (nonatomic,assign) QuestionAndAnswerScope questionScope;
@property (nonatomic,strong) GetUserQuestionInterface *getUserQuestionInterface;
@property (nonatomic,strong) SearchQuestionInterface *searchQuestionInterface;//搜索问答接口
@property (nonatomic,strong) LearningMatarilasCategoryInterface *learningMatarilasCategoryInterface;//加载资料分类
@property (nonatomic,strong) LearningMatarilasListInterface *learningMatarilasListInterface;//获取指定分类的资料数据
@property (nonatomic, strong) DRTreeTableView *drTreeTableView;
@property (nonatomic, strong) MyQuestionAndAnswerViewController *myQAVC ;//问答
@property (nonatomic, strong) ChapterViewController *chapterView;//课程
@property (nonatomic, strong) LearningMaterialsViewController *learningMaterialsController;//资料中心
@property (nonatomic, strong) NoteListViewController *noteListController;//笔记中心
@property (nonatomic, strong) NSArray *allQuestionCategoryArr;//所有问答分类信息
@property (nonatomic, strong) NSArray *myQuestionCategoryArr;//我的提问分类信息
@property (nonatomic, strong) NSArray *myAnswerCategoryArr;//我的回答分类信息
@property (nonatomic, strong) DRNavigationController *lessonNavigationController;
@property (nonatomic, strong) DRNavigationController *questionNavigationController;
@property (nonatomic, strong) DRNavigationController *noteListNavigationController;
@property (nonatomic, strong) DRNavigationController *learningMaterialNavigationController;
@property (nonatomic, strong) DRNavigationController *didAppearController;//已经在右边显示的controller
//组合所有问答分类，我的提问问答分类，我的回答分类

@property (nonatomic, strong) DRNavigationController *showDownloadDataNavigationController;
///显示历史记录
@property (nonatomic, strong) ShowDownloadDataViewController *showDownloadDataController;
///新版本提示
@property (weak, nonatomic) IBOutlet UILabel *versionnumberLabel;

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
    
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [self.lessonCategoryInterface downloadLessonCategoryDataWithUserId:[[[CaiJinTongManager shared] user] userId]];
}

-(void)downloadLessonListForCatogory{
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.lessonListForCategory downloadLessonListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:self.chapterView.sortType];
}

//获取我的问答分类信息
-(void)getMyQuestionCategoryList{
     [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.myQuestionCategatoryInterface downloadMyQuestionCategoryDataWithUserId:user.userId];
        }
    }];
}

//获取所有问答分类信息
-(void)getQuestionInfo  {

    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
            self.questionInfoInterface = questionInfoInter;
            self.questionInfoInterface.delegate = self;
            [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
        }
    }];
}

-(void)hiddleSearchKeyboard{
    [self.searchText resignFirstResponder];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//TODO:新版本通知
-(void)appNewVersionNotification{
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (![appVersion isEqualToString:[CaiJinTongManager shared].appstoreNewVersion]) {
        [self.versionnumberLabel setHidden:NO];
    }else{
        [self.versionnumberLabel setHidden:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.versionnumberLabel.layer.cornerRadius = 5;
    [self appNewVersionNotification];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appNewVersionNotification) name:APPNEWVERSION_Notification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddleSearchKeyboard) name:@"hiddleSearchKeyboardNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingViewControllerDismis) name:@"SettingViewControllerDismiss" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadLessonDataFromDatabaseNotification:) name:@"LoadLocalLessonCategory" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLoadLearningMaterialDataFromDatabaseNotification:) name:@"LoadLocalLearningMaterialCategory" object:nil];
    self.listType = LESSON_LIST;
//    [Utility setBackgroungWithView:self.LogoImageView.superview andImage6:@"login_bg_7" andImage7:@"login_bg_7"];
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
    
//    self.drTreeTableView.backgroundColor = [UIColor colorWithRed:12/255.0 green:43/255.0 blue:75/255.0 alpha:1];
    [self.lessonListBackgroundView addSubview:self.drTreeTableView];
    
    self.didAppearController = self.lessonNavigationController;
    [self.lessonNavigationController willMoveToParentViewController:self];
    self.lessonNavigationController.view.frame = (CGRect){305,0,470,1024};
    [self.view addSubview:self.lessonNavigationController.view];
    [self addChildViewController:self.lessonNavigationController];
    [self.lessonNavigationController didMoveToParentViewController:self];
    
    [self downloadLessonCategoryInfo];
    //按默认顺序加载
    [self downloadLessonListForCatogory];
}

#pragma mark 加载本地存储的分类
///从数据库中加载课程分类

///从数据库中加载的信息改变通知
-(void)changeLoadLessonDataFromDatabaseNotification:(NSNotification*)notification{
    NSArray *lessonArray = [notification.userInfo objectForKey:LoadLocalNotificationData];
     [DRFMDBDatabaseTool selectDownloadedMovieFileLessonCategoryListWithUserId:[CaiJinTongManager shared].user.userId withDownloadLessonArray:lessonArray withFinished:^(NSArray *treeNoteArray, NSString *errorMsg) {
         self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:treeNoteArray];
     }];
}

///从数据库中加载的信息改变通知
-(void)changeLoadLearningMaterialDataFromDatabaseNotification:(NSNotification*)notification{
    NSArray *materialArray = [notification.userInfo objectForKey:LoadLocalNotificationData];
    [DRFMDBDatabaseTool selectDownloadedFileMaterialCategoryListWithUserId:[CaiJinTongManager shared].user.userId withDownloadMaterialArray:materialArray withFinished:^(NSArray *treeNoteArray, NSString *errorMsg) {
        self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:treeNoteArray];
    }];
}
#pragma mark --


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
/**
 return:获取右边界面的frame
 */
-(CGRect)getRightContainerFrame{
    return (CGRect){305,0,1024-305,768};
}
/**
 笔记中心
 */
- (IBAction)noteListBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    self.listType = NOTELIST_LIST;
    if (self.didAppearController == self.noteListNavigationController) {
        return;
    }
    [self.didAppearController popToRootViewControllerAnimated:YES];
    [self removeFromRootController:self.didAppearController];
    self.didAppearController = self.noteListNavigationController;
    [self addToRootController:self.noteListNavigationController];
    self.noteListController.drnavigationBar.frame = (CGRect){0,0,1024-70,55};
}

/**
 资料中心
 */
- (IBAction)learningMaterailsBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    self.listType = LEARNINGMATERIALS_LIST;
    if (self.didAppearController == self.learningMaterialNavigationController) {
        return;
    }
    [self.didAppearController popToRootViewControllerAnimated:YES];
    [self removeFromRootController:self.didAppearController];
    self.didAppearController = self.learningMaterialNavigationController;
    [self addToRootController:self.learningMaterialNavigationController];
    //加载资料分类
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.learningMatarilasCategoryInterface downloadLearningMatarilasCategoryDataWithUserId:user.userId];
    
    if (self.learningMaterialsController.dataArray.count <= 0) {
        [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
        [self.learningMatarilasListInterface downloadlearningMaterilasListForCategoryId:nil withUserId:user.userId withPageIndex:0 withSortType:LearningMaterialsSortType_Default];
    }

    self.learningMaterialsController.drnavigationBar.titleLabel.text = @"";
}

-(void)removeFromRootController:(UIViewController*)controller{
    [controller willMoveToParentViewController:nil];
    [controller.view removeFromSuperview];
    [controller removeFromParentViewController];
    [controller didMoveToParentViewController:nil];
}

-(void)addToRootController:(UIViewController*)controller{
//    [controller willMoveToParentViewController:self];
    if (controller == self.noteListNavigationController) {
        controller.view.frame = (CGRect){75,0,1024-70,768};
    }else
    controller.view.frame = [self getRightContainerFrame];
    [self.view addSubview:controller.view];
    [self addChildViewController:controller];
    [controller didMoveToParentViewController:self];
}
//TODO:已经下载
- (IBAction)scanDownloadBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = YES;
    self.listType = DOWNLOADLIST;
    if (self.didAppearController == self.showDownloadDataNavigationController) {
        return;
    }
    [self.didAppearController popToRootViewControllerAnimated:YES];
    [self removeFromRootController:self.didAppearController];
    self.didAppearController = self.showDownloadDataNavigationController;
    [self addToRootController:self.showDownloadDataNavigationController];
    
    self.showDownloadDataController.isShowLesson = YES;
    [self.showDownloadDataController reloadLessonDataFromDatabase];
}
/**
 课程中心
 */
- (IBAction)lessonListBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    self.listType = LESSON_LIST;
//    self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:[TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]]];
    if (self.didAppearController == self.lessonNavigationController) {
        return;
    }
    [self.didAppearController popToRootViewControllerAnimated:YES];
    [self removeFromRootController:self.didAppearController];
    self.didAppearController = self.lessonNavigationController;
    [self addToRootController:self.lessonNavigationController];
    [self downloadLessonCategoryInfo];
    self.chapterView.drnavigationBar.titleLabel.text = @"";
}

/**
 问答中心
 */
- (IBAction)questionListBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    [self.searchText resignFirstResponder];
    self.listType = QUEATION_LIST;
    if (self.didAppearController == self.questionNavigationController) {
        return;
    }
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [self.didAppearController popToRootViewControllerAnimated:YES];
    [self removeFromRootController:self.didAppearController];
    self.didAppearController = self.questionNavigationController;
    [self addToRootController:self.questionNavigationController];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
            self.questionInfoInterface = questionInfoInter;
            self.questionInfoInterface.delegate = self;
            [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
            
            [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.myQuestionCategatoryInterface downloadMyQuestionCategoryDataWithUserId:user.userId];
            
            if (self.myQAVC.myQuestionArr.count <= 0) {
                [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
                self.questionScope = QuestionAndAnswerMYQUESTION;
                [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:@"0"];
            }
            
        }
    }];
    self.myQAVC.drnavigationBar.titleLabel.text = self.myQAVCTitle ? : @"我的提问";
}

- (IBAction)SearchBrClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    if (self.searchText.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
    }else {
        [self.searchText resignFirstResponder];        
        [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
                [Utility errorAlert:@"暂无网络"];
            }else{
                self.isSearching = YES;
                if (self.listType == LESSON_LIST) {
                    [self.lessonNavigationController popToRootViewControllerAnimated:YES];
                    SearchLessonInterface *searchLessonInter = [[SearchLessonInterface alloc]init];
                    self.searchLessonInterface = searchLessonInter;
                    self.searchLessonInterface.delegate = self;
                    [self.searchLessonInterface getSearchLessonInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text withPageIndex:0 withSortType:LESSONSORTTYPE_CurrentStudy];
                }else{
                    [self.questionNavigationController popToRootViewControllerAnimated:YES];
                    [self.searchQuestionInterface getSearchQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchText.text withLastQuestionId:@"0"];
                }
            }
        }];
        
    }
}

/**
 设置界面
 */
-(IBAction)setBtnPressed:(id)sender {
    
    [self disSelectedButtons];
    self.editBtn.alpha = 1.0;
    SettingViewController *settingView = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
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
    
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            self.questionAndSwerRequestID = node.noteContentID;
            switch (scope) {
                case QuestionAndAnswerALL:
                {
                    ChapterQuestionInterface *chapterInter = [[ChapterQuestionInterface alloc]init];
                    self.chapterQuestionInterface = chapterInter;
                    self.chapterQuestionInterface.delegate = self;
                    self.questionAndSwerRequestID = node.noteContentID;
                    self.questionScope = QuestionAndAnswerALL;
                    [self.chapterQuestionInterface getChapterQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterQuestionId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYQUESTION:
                {
                    //请求我的提问
                    self.questionScope = QuestionAndAnswerMYQUESTION;
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYANSWER:
                {
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

//TODO:组合所有问答分类，我的提问问答分类，我的回答分类
-(NSMutableArray*)togetherAllQuestionCategorys{
    //我的提问列表
    DRTreeNode *myQuestion = [[DRTreeNode alloc] init];
    myQuestion.noteContentID =[NSString stringWithFormat:@"%d",CategoryType_MyQuestion];
    myQuestion.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyQuestion];
    myQuestion.noteContentName = @"我的提问";
    myQuestion.childnotes = self.myQuestionCategoryArr;
    myQuestion.noteLevel = 1;
    //所有问答列表
    DRTreeNode *question = [[DRTreeNode alloc] init];
    question.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_AllQuestion];
    question.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_AllQuestion];
    question.noteContentName = @"所有问答";
    question.childnotes = self.allQuestionCategoryArr;
    question.noteLevel = 0;
    //我的回答列表
    DRTreeNode *myAnswer = [[DRTreeNode alloc] init];
    myAnswer.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswer];
    myAnswer.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswer];
    myAnswer.noteContentName = @"我的回答";
    myAnswer.childnotes = self.myAnswerCategoryArr;
    myAnswer.noteLevel = 1;
    //我的问答
    DRTreeNode *my = [[DRTreeNode alloc] init];
    my.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswerAndQuestion];
    my.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswerAndQuestion];
    my.noteContentName = @"我的问答";
    my.childnotes = @[myQuestion,myAnswer];
    my.noteLevel = 0;
    return [NSMutableArray arrayWithArray:@[my,question]];
}


#pragma mark MyQuestionAndAnswerViewControllerDelegate提问问题成功时调用
-(void)myQuestionAndAnswerControllerAskQuestionFinished{
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.myQuestionCategatoryInterface downloadMyQuestionCategoryDataWithUserId:user.userId];
}
#pragma mark --

#pragma mark DRTreeTableViewDelegate //选择一个分类

-(void)drTreeTableView:(DRTreeTableView *)treeView didCloseChildTreeNode:(DRTreeNode *)extendNote{
    if (_chapterView) {
        self.chapterView.isSearch =  NO;
    }
    if (_learningMaterialsController) {
        self.learningMaterialsController.isSearch =  NO;
    }
    if (_myQAVC) {
        self.myQAVC.isSearch = NO;
    }
}

-(void)drTreeTableView:(DRTreeTableView *)treeView didExtendChildTreeNode:(DRTreeNode *)extendNote{
    [self drTreeTableViewDidSelectedRowWithNote:extendNote];
}

-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    [self drTreeTableViewDidSelectedRowWithNote:selectedNote];
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}

-(void)drTreeTableViewDidSelectedRowWithNote:(DRTreeNode*)selectedNote{
    if ([CaiJinTongManager shared].isShowLocalData) {
        [self.showDownloadDataController filterDataFromCategory:selectedNote];
        return;
    }
    
    if (_chapterView) {
        self.chapterView.isSearch =  NO;
    }
    if (_learningMaterialsController) {
        self.learningMaterialsController.isSearch =  NO;
        self.learningMaterialsController.drnavigationBar.titleLabel.text = selectedNote.noteContentName;
    }
    if (_myQAVC) {
        self.myQAVC.isSearch = NO;
        self.myQAVC.drnavigationBar.titleLabel.text = selectedNote.noteContentName;
    }
    [self.didAppearController popToRootViewControllerAnimated:YES];
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.listType == LESSON_LIST) {
        [self.lessonNavigationController popToRootViewControllerAnimated:YES];
        [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
        [self.lessonListForCategory downloadLessonListForCategoryId:selectedNote.noteContentID withUserId:user.userId withPageIndex:0 withSortType:self.chapterView.sortType];
    }else
        if (self.listType == QUEATION_LIST) {
            {
                [self.questionNavigationController popToRootViewControllerAnimated:YES];
                switch ([selectedNote.noteRootContentID integerValue]) {
                    case CategoryType_AllQuestion://所有问答
                    {
                        self.questionScope = QuestionAndAnswerALL;
                        [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
                    }
                        break;
                    case CategoryType_MyQuestion://我的提问
                    {
                        self.questionScope = QuestionAndAnswerMYQUESTION;
                        [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
                    }
                        break;
                    case CategoryType_MyAnswer://我的回答
                    {
                        self.questionScope = QuestionAndAnswerMYANSWER;
                        [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
                    }
                        break;
                    case CategoryType_MyAnswerAndQuestion://我的问答
                    {
                        self.questionScope = QuestionAndAnswerMYQUESTION;
                        [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
                    }
                        break;
                    default:{
                        
                    }
                        break;
                }
            }
        }else
            if (self.listType == LEARNINGMATERIALS_LIST) {
                [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
                [self.learningMatarilasListInterface downloadlearningMaterilasListForCategoryId:selectedNote.noteContentID withUserId:user.userId withPageIndex:0 withSortType:LearningMaterialsSortType_Default];
            }
    self.chapterView.drnavigationBar.titleLabel.text = selectedNote.noteContentName;
}
#pragma mark --

#pragma mark property

-(LearningMatarilasListInterface *)learningMatarilasListInterface{
    if (!_learningMatarilasListInterface) {
        _learningMatarilasListInterface = [[LearningMatarilasListInterface alloc] init];
        _learningMatarilasListInterface.delegate = self;
    }
    return _learningMatarilasListInterface;
}

-(LearningMatarilasCategoryInterface *)learningMatarilasCategoryInterface{
    if (!_learningMatarilasCategoryInterface) {
        _learningMatarilasCategoryInterface = [[LearningMatarilasCategoryInterface alloc] init];
        _learningMatarilasCategoryInterface.delegate = self;
    }
    return _learningMatarilasCategoryInterface;
}

-(ChapterViewController *)chapterView{
    if (!_chapterView) {
        _chapterView= [self.storyboard instantiateViewControllerWithIdentifier:@"ChapterViewController"];
    }
    return _chapterView;
}

-(ShowDownloadDataViewController *)showDownloadDataController{
    if (!_showDownloadDataController) {
        _showDownloadDataController = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowDownloadDataViewController"];
    }
    return _showDownloadDataController;
}

-(MyQuestionAndAnswerViewController *)myQAVC{
    if (!_myQAVC) {
        _myQAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
        _myQAVC.delegate = self;
        _myQAVC.lessonViewController = self;
    }
    return _myQAVC;
}

-(LearningMaterialsViewController *)learningMaterialsController{
    if (!_learningMaterialsController) {
        _learningMaterialsController = [self.storyboard instantiateViewControllerWithIdentifier:@"LearningMaterialsViewController"];
    }
    return _learningMaterialsController;
}

-(NoteListViewController *)noteListController{
    if (!_noteListController) {
        _noteListController = [self.storyboard instantiateViewControllerWithIdentifier:@"NoteListViewController"];
    }
    return _noteListController;
}

-(DRNavigationController *)learningMaterialNavigationController{
    if (!_learningMaterialNavigationController) {
        _learningMaterialNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.learningMaterialsController];
        [_learningMaterialNavigationController setNavigationBarHidden:YES];
    }
    return _learningMaterialNavigationController;
}

-(DRNavigationController *)noteListNavigationController{
    if (!_noteListNavigationController) {
        _noteListNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.noteListController];
        [_noteListNavigationController setNavigationBarHidden:YES];
    }
    return _noteListNavigationController;
}

-(DRNavigationController *)lessonNavigationController{
    if (!_lessonNavigationController) {
        _lessonNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.chapterView];
        [_lessonNavigationController setNavigationBarHidden:YES];
    }
    return _lessonNavigationController;
}

-(DRNavigationController *)showDownloadDataNavigationController{
    if (!_showDownloadDataNavigationController) {
        _showDownloadDataNavigationController = [[DRNavigationController alloc] initWithRootViewController:self.showDownloadDataController];
        [_showDownloadDataNavigationController setNavigationBarHidden:YES];
    }
    return _showDownloadDataNavigationController;
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
         _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){0,40,222,720} withTreeNodeArr:nil];
        _drTreeTableView.autoresizingMask = UIViewAutoresizingNone;
        _drTreeTableView.backgroundColor = [UIColor clearColor];
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

//隐藏所有按钮
-(void)disSelectedButtons{
    self.lessonListBt.alpha = 0.3;
    self.questionListBt.alpha = 0.3;
    self.noteListBt.alpha = 0.3;
    self.learningMaterailBt.alpha = 0.3;
    self.scanDownloadBt.alpha = 0.3;
    self.editBtn.alpha = 0.3;
}

-(void)setListType:(TableListType)listType{
    [self disSelectedButtons];
    if ([CaiJinTongManager shared].isShowLocalData) {
        self.lessonListTitleLabel.text = @"已经下载";
        self.scanDownloadBt.alpha = 1.0;
    }else{
        switch (listType) {
            case LESSON_LIST:
            {
                self.lessonListTitleLabel.text = @"我的课程";
                self.lessonListBt.alpha = 1.0;
                break;
            }
            case QUEATION_LIST:
            {
                self.lessonListTitleLabel.text = @"问答中心";
                self.questionListBt.alpha = 1.0;
                break;
            }
            case NOTELIST_LIST:
            {
                self.noteListBt.alpha = 1.0;
                break;
            }
            case LEARNINGMATERIALS_LIST:
            {
                self.learningMaterailBt.alpha = 1.0;
                self.lessonListTitleLabel.text = @"资料中心";
                break;
            }
            case SETTING:
            {
                self.editBtn.alpha = 1.0;
                break;
            }
            default:
                break;
        }
        _listType = listType;
    }
}

-(GetUserQuestionInterface *)getUserQuestionInterface{
    if (!_getUserQuestionInterface) {
        _getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
        _getUserQuestionInterface.delegate = self;
    }
    return _getUserQuestionInterface;
}
#pragma mark --

#pragma mark LearningMatarilasListInterfaceDelegate获取资料数据
-(void)getlearningMaterilasListDataForCategoryDidFinished:(NSArray *)learningMaterialsList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.learningMaterialsController changeLearningMaterialsDate:learningMaterialsList withSortType:LearningMaterialsSortType_Default withCategoryId:self.learningMatarilasListInterface.lessonCategoryId widthAllDataCount:allDataCount isSearch:NO];
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}

-(void)getlearningMaterilasListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark LearningMatarilasCategoryInterfaceDelegate加载资料分类列表
-(void)getLearningMatarilasCategoryDataDidFinished:(NSArray *)categoryLearningMatarilas{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.listType == LEARNINGMATERIALS_LIST) {
            self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:categoryLearningMatarilas];
        }
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}

-(void)getLearningMatarilasCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark MyQuestionCategatoryInterfaceDelegate 获取我的问答分类接口
-(void)getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:(NSArray *)myAnswerCategoryNotes withMyQuestionCategorynodes:(NSArray *)myQuestionCategoryNotes{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        self.myAnswerCategoryArr = myAnswerCategoryNotes;
        self.myQuestionCategoryArr = myQuestionCategoryNotes;
        if (self.listType == QUEATION_LIST) {
            self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
        }
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}

-(void)getMyQuestionCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark --

#pragma mark LessonListForCategoryDelegate 根据分类获取课程信息
-(void)getLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chapterView.lessonListForCategory.currentPageIndex = 0;
        [self.chapterView reloadDataWithDataArray:lessonList withCategoryId:self.lessonListForCategory.lessonCategoryId isSearch:NO];
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}

-(void)getLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --

#pragma mark GetUserQuestionInterfaceDelegate 获取我的回答和我的提问列表
-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope isSearch:NO];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        });
    });
}
#pragma mark --

#pragma mark SearchQuestionInterfaceDelegate搜索问答回调
-(void)getSearchQuestionInfoDidFailed:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

-(void)getSearchQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
           
 [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:QuestionAndAnswerSearchQuestion isSearch:NO];
             [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
        });
    });
}
#pragma mark --


#pragma mark--QuestionInfoInterfaceDelegate 获取所有问答分类信息
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_main_queue(), ^{
       
        self.allQuestionCategoryArr = questionCategoryArr;
        [[CaiJinTongManager shared] setQuestionCategoryArr:questionCategoryArr] ;
        if (self.listType == QUEATION_LIST) {
            self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
        }
         [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
//        self.listType = LESSON_LIST;
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark--ChapterQuestionInterfaceDelegate所有问答数据
-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
 [self.myQAVC reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope isSearch:NO];
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
//            [self presentPopupViewController:navControl animationType:MJPopupViewAnimationSlideRightLeft isAlignmentCenter:NO dismissed:^{
//                
//            }];
        });
    });
}
-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}


#pragma mark--SearchLessonInterfaceDelegate

-(void)getSearchLessonListDataForCategoryDidFinished:(NSArray *)lessonList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chapterView reloadDataWithDataArray:lessonList withCategoryId:nil isSearch:NO];
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    });
}

-(void)getSearchLessonListDataForCategoryFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --

#pragma mark LessonCategoryInterfaceDelegate获取课程分类信息
-(void)getLessonCategoryDataDidFinished:(NSArray *)categoryNotes{
dispatch_async(dispatch_get_main_queue(), ^{
    [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
    if (self.listType == LESSON_LIST) {
        self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:categoryNotes];
    }
});
}

-(void)getLessonCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
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
