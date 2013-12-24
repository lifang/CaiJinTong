//
//  SectionViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionViewController.h"


#import "Section.h"
#import "CommentModel.h"
@interface SectionViewController ()
@property (nonatomic,strong) DRMoviePlayViewController *playerController;
@property (nonatomic, strong) SectionInfoInterface *sectionInterface;
@property (nonatomic,assign) BOOL isPlaying;
@end

@implementation SectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)willDismissPopoupController{
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.isPlaying) {
        //根据sectionID获取单个视频的详细信息
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
            self.sectionInterface = sectionInter;
            self.sectionInterface.delegate = self;
            [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.section.sectionId];
        }
    }
    self.isPlaying = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //打分之后提交
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refeshScore:)
                                                 name: @"refeshScore"
                                               object: nil];
    
    self.drnavigationBar.titleLabel.text = self.section.sectionName;
    [self.drnavigationBar.navigationRightItem setTitle:@"关闭" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMoviePlayWithSid:) name:@"gotoMoviePlay" object:nil];
    [self initAppear];
}
-(void)refeshScore:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *score = [dic objectForKey:@"sectionScore"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.section.sectionScore = score;
        self.section.isGrade = @"1";
        [self reloadSectionData:self.section];
    });

}

/////////////
//播放接口

-(void)playVideo:(id)sender {
    self.isPlaying = YES;
    self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
    [self.playerController playMovieWithSectionModel:self.section orLocalSectionModel:nil withFileType:MPMovieSourceTypeStreaming];
    self.playerController.delegate = self;
    AppDelegate *app = [AppDelegate sharedInstance];
    [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
        
    }];
}
/////////



//-(void)playVideo:(id)sender {
//    self.isPlaying = YES;
//    DLog(@"play");
//    //先匹配本地,在数据库中查找纪录
//    Section *sectionDb = [[Section alloc]init];
//    SectionSaveModel *sectionSave = [sectionDb getDataWithSid:self.section.sectionId];
//    if (sectionSave != nil && sectionSave.downloadState == 1) {
//        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
//        [self.playerController playMovieWithSectionModel:nil orLocalSectionModel:sectionSave withFileType:MPMovieSourceTypeFile];
//        self.playerController.delegate = self;
//        AppDelegate *app = [AppDelegate sharedInstance];
//        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
//            
//        }];
//    }else {
//        //在线播放
//        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//            [Utility errorAlert:@"暂无网络!"];
//        }else {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            PlayVideoInterface *playVideoInter = [[PlayVideoInterface alloc]init];
//            self.playVideoInterface = playVideoInter;
//            self.playVideoInterface.delegate = self;
//            NSString *timespan = [Utility getNowDateFromatAnDate];
//            [self.playVideoInterface getPlayVideoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.section.sectionId andTimeStart:timespan];
//        }
//    }
//}
-(void)displayView {
    NSLog(@"self.section = %@",self.section);
    self.slideSwitchView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    //3个选项卡
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor darkGrayColor];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"play-courselist_0df3"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    
    self.section_ChapterView = [story instantiateViewControllerWithIdentifier:@"Section_ChapterViewController"];
    self.section_ChapterView.title = @"章节目录";
    self.section_ChapterView.isMovieView = NO;
    self.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:self.section.sectionList];

    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == NO) {
        self.section_GradeView = [story instantiateViewControllerWithIdentifier:@"Section_GradeViewController"];
        self.section_GradeView.title = @"打分";
        self.section_GradeView.dataArray = [NSMutableArray arrayWithArray:self.section.commentList];
        self.section_GradeView.isGrade = [self.section.isGrade intValue];
        self.section_GradeView.sectionId = self.section.sectionId;
        if (self.section_GradeView.dataArray.count > 0) {
            CommentModel *comment = (CommentModel *)[self.section_GradeView.dataArray objectAtIndex:self.section_GradeView.dataArray.count-1];
            self.section_GradeView.pageCount = comment.pageCount;
            self.section_GradeView.nowPage = 1;
        }
    }
    self.section_NoteView = [story instantiateViewControllerWithIdentifier:@"Section_NoteViewController"];
    self.section_NoteView.title = @"笔记";
    self.section_NoteView.dataArray = [NSMutableArray arrayWithArray:self.section.noteList];
    self.section_NoteView.delegate = self;
    [self.slideSwitchView buildUI];
}

#pragma mark SectionInfoInterfaceDelegate 播放完成后回调

-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            SectionModel *section = (SectionModel *)result;
            if (section) {
                self.section = section;
                [self reloadSectionData:section];
            }
        });
    });
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark --

#pragma mark DRMoviePlayViewControllerDelegate 提交笔记成功
-(void)drMoviePlayerViewController:(DRMoviePlayViewController *)playerController commitNotesSuccess:(NSString *)noteText andTime:(NSString *)noteTime{
    if (self.section_NoteView) {
        NoteModel *note = [[NoteModel alloc] init];
        note.noteTime = noteTime;
        note.noteText = noteText;
        [self.section_NoteView.dataArray insertObject:note atIndex:0];
        [self.section_NoteView.tableViewList reloadData];
    }
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView *)view
{
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        return 2;
    }
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        if (number == 0) {
            return self.section_ChapterView;
        }  else if (number == 1) {
            return self.section_NoteView;
        } else {
            return nil;
        }
    }else {
        if (number == 0) {
            return self.section_ChapterView;
        } else if (number == 1) {
            return self.section_GradeView;
        } else if (number == 2) {
            return self.section_NoteView;
        } else {
            return nil;
        }
    }
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
}

- (void)slideSwitchView:(SUNSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        Section_ChapterViewController *section_ChapterView = nil;
        Section_NoteViewController *section_NoteView = nil;
        if (number == 0) {
            section_ChapterView = self.section_ChapterView;
            [section_ChapterView viewDidCurrentView];
        } else if (number == 1) {
            section_NoteView = self.section_NoteView;
            [section_NoteView viewDidCurrentView];
        }
    }else {
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
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- PlayVideoInterfaceDelegate
-(void)getPlayVideoInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //播放接口
            self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
            [self.playerController playMovieWithSectionModel:self.section orLocalSectionModel:nil withFileType:MPMovieSourceTypeStreaming];
            self.playerController.delegate = self;
            AppDelegate *app = [AppDelegate sharedInstance];
            [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
                
            }];
        });
    });
}
-(void)getPlayVideoInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

- (void)gotoMoviePlayWithSid:(NSNotification *)info {
    self.isPlaying = YES;
    NSString *sectionID = [info.userInfo objectForKey:@"sectionID"];
    NSString *path = [CaiJinTongManager getMovieLocalPathWithSectionID:sectionID];
    if (path) {
        //播放接口
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        self.playerController = [story instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];        
        Section *s = [[Section alloc] init];
        SectionSaveModel *ssm = [s getDataWithSid:sectionID];
        [self.playerController playMovieWithSectionModel:nil orLocalSectionModel:ssm withFileType:MPMovieSourceTypeFile];
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
        
    }
}

#pragma mark Section_NoteViewControllerDelegate选中一条笔记
-(void)section_NoteViewController:(Section_NoteViewController *)controller didClickedNoteCellWithObj:(NoteModel *)noteModel{
    [self playVideo:Nil];
}
#pragma mark --

#pragma mark property
-(SectionInfoInterface *)sectionInterface{
    if (!_sectionInterface) {
        _sectionInterface = [[SectionInfoInterface alloc] init];
        _sectionInterface.delegate = self;
    }
    return _sectionInterface;
}
#pragma mark --

#pragma mark -- appear

-(void)reloadSectionData:(SectionModel*)section{
    //封面
    [self.sectionView changeSectionModel:section];
    
    //显示分数
    if ([self.section.isGrade isEqualToString:@"1"]) {
        self.scoreLab.backgroundColor = [UIColor colorWithRed:0.10f green:0.84f blue:0.99f alpha:1.0f];
        self.scoreLab.text = [NSString stringWithFormat:@"%.1f",[section.sectionScore floatValue]];
        self.scoreLab.layer.cornerRadius = 7;
        [self.scoreLab setColor:[UIColor whiteColor] fromIndex:0 length:self.scoreLab.text.length];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
    }else{
        self.scoreLab.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
        self.scoreLab.text =[NSString stringWithFormat:@"%.1f",[section.sectionScore floatValue]];
        self.scoreLab.layer.cornerRadius = 7;
        [self.scoreLab setColor:[UIColor whiteColor] fromIndex:0 length:self.scoreLab.text.length];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
    }
    
    CGFloat labelTop = 64;
    CGFloat labelSpace = 6;
    
     //标题
    self.nameLab.text =[NSString stringWithFormat:@"名称:%@",section.sectionName];
//    self.nameLab.frame = (CGRect){275, labelTop, 200, 30};
    labelTop +=self.nameLab.frame.size.height+labelSpace;
    
    //简介
    self.detailInfoTextView.text = [NSString stringWithFormat:@"简介:%@",section.lessonInfo?:@""];
    self.detailInfoTextView.frame = (CGRect){270, labelTop - 10, 170, 100};
    CGSize size = [Utility getTextSizeWithString:self.section.lessonInfo withFont:[UIFont boldSystemFontOfSize:16] withWidth:350];
    if (size.height > 100) {
        labelTop += 100 +labelSpace;
    }else{
        labelTop += size.height +labelSpace;
    }
    
     //讲师
     self.teacherlab.text =[NSString stringWithFormat:@"讲师:%@",section.sectionTeacher];
    self.teacherlab.frame = CGRectMake(275, labelTop, 150, 30);
     labelTop +=self.teacherlab.frame.size.height+labelSpace;
    
    //时长
     self.lastLab.text =[NSString stringWithFormat:@"时长:%@",section.sectionLastTime];
    self.lastLab.frame = CGRectMake(275, labelTop, 150, 30);
    labelTop +=self.lastLab.frame.size.height+labelSpace;
    
    
    //已学习
    self.studyLab.text =[NSString stringWithFormat:@"已学习:%@",section.sectionStudy];
    self.studyLab.frame = CGRectMake(275, labelTop, 150, 30);
    
    //播放按钮
    DLog(@"labtop = %f",labelTop);
    if (labelTop <150) {
        labelTop = 200;
    }
    self.playBtn.frame = CGRectMake(585, labelTop, 100, 35);
    if (!section.sectionStudy || [section.sectionStudy isEqualToString:@"0"]) {
        [self.playBtn setTitle:NSLocalizedString(@"开始学习", @"button") forState:UIControlStateNormal];
    }else{
        [self.playBtn setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
    }
}

- (void)initAppear {
    if (self.section) {
        //封面
        SectionCustomView *sv = [[SectionCustomView alloc]initWithFrame:CGRectMake(10, 54, 250, 250) andSection:self.section andItemLabel:0];
        self.sectionView = sv;
        
        [self.view addSubview:self.sectionView];
        //显示分数
        CustomLabel *scoreLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(630, 64, 60, 60)];
        if ([self.section.isGrade isEqualToString:@"1"]) {
            scoreLabel.backgroundColor = [UIColor colorWithRed:0.10f green:0.84f blue:0.99f alpha:1.0f];
            scoreLabel.text = [NSString stringWithFormat:@"%.1f",[self.section.sectionScore floatValue]];
            scoreLabel.layer.cornerRadius = 7;
            [scoreLabel setColor:[UIColor whiteColor] fromIndex:0 length:scoreLabel.text.length];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
        }else{
            scoreLabel.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
            scoreLabel.text =[NSString stringWithFormat:@"%.1f",[self.section.sectionScore floatValue]];
            scoreLabel.layer.cornerRadius = 7;
            [scoreLabel setColor:[UIColor whiteColor] fromIndex:0 length:scoreLabel.text.length];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
        }
        self.scoreLab = scoreLabel;
        [self.view addSubview:self.scoreLab];
        scoreLabel = nil;
        //
        CGFloat labelTop = 64;
        CGFloat labelSpace = 6;
        float width = 350.0;
        //标题
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, labelTop, width, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.font = [UIFont boldSystemFontOfSize:16];
        nameLabel.text =[NSString stringWithFormat:@"名称:%@",self.section.sectionName];
        self.nameLab = nameLabel;
        [self.view addSubview:self.nameLab];
        nameLabel = nil;
        labelTop +=self.nameLab.frame.size.height+labelSpace ;
        //简介
        self.detailInfoTextView = [[UITextView alloc] initWithFrame:(CGRect){270, labelTop - 10, width, 100}];
        [self.detailInfoTextView setEditable:NO];
        [self.detailInfoTextView setFont:[UIFont boldSystemFontOfSize:16]];
        [self.detailInfoTextView setTextColor:[UIColor grayColor]];
        self.detailInfoTextView.backgroundColor = [UIColor clearColor];
        self.detailInfoTextView.text = [NSString stringWithFormat:@"简介:%@",self.section.lessonInfo?:@""];
        [self.view addSubview:self.detailInfoTextView];
         CGSize size = [Utility getTextSizeWithString:self.section.lessonInfo withFont:[UIFont boldSystemFontOfSize:16] withWidth:width];
        if (size.height > 100) {
            labelTop += 100 +labelSpace;
        }else{
            labelTop += size.height +labelSpace;
        }
        
        //讲师
        UILabel *teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, labelTop, width, 30)];
        teacherLabel.backgroundColor = [UIColor clearColor];
        teacherLabel.textColor = [UIColor grayColor];
        teacherLabel.font = [UIFont boldSystemFontOfSize:16];
        teacherLabel.text =[NSString stringWithFormat:@"讲师:%@",self.section.sectionTeacher];
        self.teacherlab = teacherLabel;
        [self.view addSubview:self.teacherlab];
        teacherLabel = nil;
        labelTop +=self.teacherlab.frame.size.height+labelSpace;

        //时长
        UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, labelTop, width, 30)];
        lastLabel.backgroundColor = [UIColor clearColor];
        lastLabel.textColor = [UIColor grayColor];
        lastLabel.font = [UIFont boldSystemFontOfSize:16];
        lastLabel.text =[NSString stringWithFormat:@"时长:%@",self.section.sectionLastTime];
        self.lastLab = lastLabel;
        [self.view addSubview:self.lastLab];
        lastLabel = nil;
        labelTop +=self.lastLab.frame.size.height+labelSpace;
        //已学习
        DLog(@"labtop = %f",labelTop);
        UILabel *studyLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, labelTop, width-50, 30)];
        studyLabel.backgroundColor = [UIColor clearColor];
        studyLabel.textColor = [UIColor grayColor];
        studyLabel.font = [UIFont boldSystemFontOfSize:16];
        studyLabel.text =[NSString stringWithFormat:@"已学习:%@",self.section.sectionStudy];
        self.studyLab = studyLabel;
        [self.view addSubview:self.studyLab];
        studyLabel = nil;
        //播放按钮
        DLog(@"labtop = %f",labelTop);
        if (labelTop <150) {
            labelTop = 200;
        }
        UIButton *palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        palyButton.frame = CGRectMake(585, labelTop, 100, 35);
        if (!self.section.sectionStudy || [self.section.sectionStudy isEqualToString:@"0"]) {
            [palyButton setTitle:NSLocalizedString(@"开始学习", @"button") forState:UIControlStateNormal];
        }else{
            [palyButton setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
        }
        [palyButton setBackgroundColor:[UIColor clearColor]];
		[palyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [palyButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [palyButton setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
        self.playBtn = palyButton;
        [self.view addSubview:self.playBtn];
        palyButton = nil;
        [self displayView];
        
    }
}
@end
