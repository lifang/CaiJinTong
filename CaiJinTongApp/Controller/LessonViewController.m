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
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddleSearchKeyboard) name:@"hiddleSearchKeyboardNotification" object:nil];
    DRNavigationController *drNavi = [self.childViewControllers lastObject];
    if (drNavi) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        self.chapterView = [story instantiateViewControllerWithIdentifier:@"ChapterViewController"];
        [drNavi pushViewController:self.chapterView animated:NO];
    }
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


#pragma mark SettingViewController dismiss notification
-(void)settingViewControllerDismis{
    self.listType = self.listType;
}
#pragma mark --


- (IBAction)lessonListBtClicked:(id)sender {
    self.listType = LESSON_LIST;
//    self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:@[[TestModelData getTreeNodeFromCategoryModel:[TestModelData getCategoryTree]]]];
    self.drTreeTableView.noteArr = [NSMutableArray arrayWithArray:[TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]]];
//    [self getLessonInfo];
    DRNavigationController *navi = [self.childViewControllers lastObject];
    if (navi.childViewControllers.count > 2) {
        UIViewController *childController = [navi.childViewControllers objectAtIndex:1];
        [navi popToViewController:childController animated:YES];
    }
}

- (IBAction)questionListBtClicked:(id)sender {
    [self.searchText resignFirstResponder];
    self.listType = QUEATION_LIST;
    DRNavigationController *navi = [self.childViewControllers lastObject];
    if (!self.myQAVC) {
        self.myQAVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyQuestionAndAnswerViewController"];
        NSMutableArray *array = [TestModelData getQuestion];
        [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
         [navi pushViewController:self.myQAVC animated:YES];
    }else{
        if (navi) {
            if ([[navi.childViewControllers lastObject] isKindOfClass:[MyQuestionAndAnswerViewController class]] || ([[navi.childViewControllers lastObject] isKindOfClass:[DRAskQuestionViewController class]])) {
                
            }else{
                [navi pushViewController:self.myQAVC animated:YES];
            }
            
        }
    }

     [self getQuestionInfo];
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
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
            switch (scope) {
                case QuestionAndAnswerALL:
                {
                    ChapterQuestionInterface *chapterInter = [[ChapterQuestionInterface alloc]init];
                    self.chapterQuestionInterface = chapterInter;
                    self.chapterQuestionInterface.delegate = self;
                    self.questionAndSwerRequestID = node.noteContentID;
                    self.questionScope = QuestionAndAnswerALL;
                    NSMutableArray *array = [TestModelData getQuestion];
                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
//                    [self.chapterQuestionInterface getChapterQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterQuestionId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYQUESTION:
                {
                    //请求我的提问
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    self.questionScope = QuestionAndAnswerMYQUESTION;
                    NSMutableArray *array = [TestModelData getQuestion];
                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
//                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil];
                }
                    break;
                case QuestionAndAnswerMYANSWER:
                {
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
                    NSMutableArray *array = [TestModelData getQuestion];
                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil];
                }
                    break;
                default:
                    break;
            }
    }
}
#pragma mark DRTreeTableViewDelegate
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    if (self.listType == LESSON_LIST) {
        
    }else{
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
-(DRTreeTableView *)drTreeTableView{
    if (!_drTreeTableView) {
        _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){0,90,222,670} withTreeNodeArr:[TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]]];
//        _drTreeTableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleHeight;
        _drTreeTableView.delegate = self;
    }
    return _drTreeTableView;
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

-(void)getSearchQuestionInfoDidFinished:(NSDictionary *)result{
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

#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self.chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
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

#pragma mark-- LessonInfoInterfaceDelegate
-(void)getLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.lessonList = [NSMutableArray arrayWithArray:[result objectForKey:@"lessonList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
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
        
        //我的提问列表
        NSMutableDictionary *myQuestion = [NSMutableDictionary dictionary];
        [myQuestion setValue:self.questionList forKey:@"questionNode"];
        [myQuestion setValue:@"-1" forKey:@"questionID"];
        [myQuestion setValue:@"我的提问" forKey:@"questionName"];
        [myQuestion setValue:@"1" forKey:@"level"];
        
        //所有问答列表
        NSMutableDictionary *question = [NSMutableDictionary dictionary];
        [question setValue:self.questionList forKey:@"questionNode"];
        [question setValue:@"-2" forKey:@"questionID"];
        [question setValue:@"所有问答" forKey:@"questionName"];
        [question setValue:@"1" forKey:@"level"];
        
        //我的回答列表
        NSMutableDictionary *myAnswer = [NSMutableDictionary dictionary];
        [myAnswer setValue:self.questionList forKey:@"questionNode"];
        [myAnswer setValue:@"-3" forKey:@"questionID"];
        [myAnswer setValue:@"我的回答" forKey:@"questionName"];
        [myAnswer setValue:@"-1" forKey:@"level"];
        
        //我的问答
        NSMutableDictionary *my = [NSMutableDictionary dictionary];
        [my setValue:@[myQuestion,myAnswer] forKey:@"questionNode"];
        [my setValue:@"-4" forKey:@"questionID"];
        [my setValue:@"我的问答" forKey:@"questionName"];
        [my setValue:@"1" forKey:@"level"];
        
        
        self.myQuestionList = [NSMutableArray arrayWithObjects:myQuestion,myAnswer, nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.drTreeTableView.noteArr = [TestModelData getTreeNodeArrayFromArray:@[question,my]];
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
-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
             [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (![[result objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [result objectForKey:@"sectionList"]!=nil) {
                NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:[result objectForKey:@"sectionList"]];
                [self.chapterView reloadDataWithDataArray:[[NSMutableArray alloc]initWithArray:tempArray]];
            }else{
                [Utility errorAlert:@"没有加载到数据"];
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

#pragma mark touch
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.searchText resignFirstResponder];
}
#pragma mark --
@end
