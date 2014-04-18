//
//  StudySummaryViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-3-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "StudySummaryViewController_iphone.h"
#import "DSGraphicsKit.h"
#import "LHLTabBarController.h"
#import "InfoViewController_iPhone.h"
@interface StudySummaryViewController_iphone ()
@property (weak, nonatomic) IBOutlet UILabel *allLessonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginningLessonCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginningNotesLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNicknameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userHeaderImage;
@property (weak, nonatomic) IBOutlet UILabel *beginningQuestionLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginningLearningMatarilLabel;
@property (weak, nonatomic) IBOutlet UIImageView *lessonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *noteImageView;
@property (weak, nonatomic) IBOutlet UIImageView *materialImageView;
@property (weak, nonatomic) IBOutlet UILabel *versionnumberLabel;

@property (nonatomic,strong) LHLTabBarController *lhltabBarController;
- (IBAction)lessonBtClicked:(UIButton *)sender;
- (IBAction)noteBtClicked:(id)sender;
- (IBAction)userHeaderBtClicked:(id)sender;
- (IBAction)questionBtClicked:(id)sender;
- (IBAction)settingBtClicked:(id)sender;
- (IBAction)learningMaterialBtClicked:(id)sender;
///显示已经下载
- (IBAction)loadDownloadedDataBtClicked:(id)sender;

@end

@implementation StudySummaryViewController_iphone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    
    self.view.backgroundColor = [UIColor underPageBackgroundColor];
    [self addReflectionView:self.noteImageView];
    [self addReflectionView:self.lessonImageView];
    [self addReflectionView:self.materialImageView];
    CaiJinTongManager *app = [CaiJinTongManager shared];
    
    self.userNicknameLabel.text = app.user.nickName;
    
    __weak StudySummaryViewController_iphone *weakSelf = self;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [UserStudySummaryInfo downloadStudySummaryInfoWithUserId:app.user.userId withSuccess:^(StudySummaryModel *studySummaryModel) {
        StudySummaryViewController_iphone *tempSelf = weakSelf;
        if (tempSelf) {
            [tempSelf updateViewcontentWithModel:studySummaryModel];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } withError:^(NSError *error) {
        StudySummaryViewController_iphone *tempSelf = weakSelf;
        if (tempSelf) {
            [tempSelf updateViewcontentWithModel:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    }];
    
    self.lhltabBarController = [[LHLTabBarController alloc] init];
	// Do any additional setup after loading the view.
}

-(void)updateViewcontentWithModel:(StudySummaryModel*)model{
    if (model) {
        self.allLessonCountLabel.text = [NSString stringWithFormat:@"课程(%d)",model.studyAllCourseCount];
        self.beginningLessonCountLabel.text = [NSString stringWithFormat:@"已学课程(%d)",model.studyBeginningCourseCount];
        self.beginningNotesLabel.text = [NSString stringWithFormat:@"我的笔记(%d)",model.studyAllNotesCount];
        self.beginningQuestionLabel.text = [NSString stringWithFormat:@"我的问答(%d)",model.studyAllQuestionCount];
        self.beginningLearningMatarilLabel.text = [NSString stringWithFormat:@"授权资料(%d)",model.studyAllLearningMatarilCount];
    }else{
        self.allLessonCountLabel.text = @"课程(0)";
        self.beginningLessonCountLabel.text = @"已学课程(0)";
        self.beginningNotesLabel.text = @"我的笔记(0)";
        self.beginningQuestionLabel.text = @"我的问答(0)";
        self.beginningLearningMatarilLabel.text = @"授权资料(0)";
    }
}

-(void)addReflectionView:(UIImageView*)view{
    DSReflectionLayer *layer = [view addReflectionToSuperLayer];
    layer.verticalOffset = -9.0f;
    layer.reflectionHeight = 0.3;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)lessonBtClicked:(UIButton *)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([[NSString stringWithFormat:@"NotReachable"] isEqualToString:networkStatus]) {
            [Utility errorAlert:@"处于离线状态，请检查网络"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        [CaiJinTongManager shared].isShowLocalData = NO;
        [self.lhltabBarController loadLocalItem:NO];
        [self.lhltabBarController selectedAtIndexItem:0];
        
        [self.navigationController pushViewController:self.lhltabBarController animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

///笔记
- (IBAction)noteBtClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([[NSString stringWithFormat:@"NotReachable"] isEqualToString:networkStatus]) {
            [Utility errorAlert:@"处于离线状态，请检查网络"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        [CaiJinTongManager shared].isShowLocalData = NO;
        [self.lhltabBarController loadLocalItem:NO];
        [self.lhltabBarController selectedAtIndexItem:1];
        [self.navigationController pushViewController:self.lhltabBarController animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)userHeaderBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    [self.lhltabBarController loadLocalItem:NO];
    InfoViewController_iPhone *userInfoController = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoViewController_iPhone"];
    [self.navigationController pushViewController:userInfoController animated:YES];
}

- (IBAction)questionBtClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([[NSString stringWithFormat:@"NotReachable"] isEqualToString:networkStatus]) {
            [Utility errorAlert:@"处于离线状态，请检查网络"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        [CaiJinTongManager shared].isShowLocalData = NO;
        [self.lhltabBarController loadLocalItem:NO];
        [self.lhltabBarController selectedAtIndexItem:3];
        [self.navigationController pushViewController:self.lhltabBarController animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];


}

- (IBAction)settingBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = NO;
    [self.lhltabBarController loadLocalItem:NO];
    [self.lhltabBarController selectedAtIndexItem:4];
    [self.navigationController pushViewController:self.lhltabBarController animated:YES];
}

- (IBAction)learningMaterialBtClicked:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([[NSString stringWithFormat:@"NotReachable"] isEqualToString:networkStatus]) {
            [Utility errorAlert:@"处于离线状态，请检查网络"];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            return ;
        }
        [CaiJinTongManager shared].isShowLocalData = NO;
        [self.lhltabBarController loadLocalItem:NO];
        [self.lhltabBarController selectedAtIndexItem:2];
        [self.navigationController pushViewController:self.lhltabBarController animated:YES];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

- (IBAction)loadDownloadedDataBtClicked:(id)sender {
    [CaiJinTongManager shared].isShowLocalData = YES;
    [self.lhltabBarController loadLocalItem:YES];
    [CaiJinTongManager shared].isShowLocalLessonData = YES;
    [self.lhltabBarController selectedAtIndexItem:0];
    [self.navigationController pushViewController:self.lhltabBarController animated:YES];
}
@end
