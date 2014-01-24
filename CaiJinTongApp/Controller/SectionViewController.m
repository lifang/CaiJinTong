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
@property (nonatomic, strong) LessonInfoInterface *lessonInterface;//获取课程详细信息
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UserModel *user = [[CaiJinTongManager shared] user];
        [self.lessonInterface downloadLessonInfoWithLessonId:self.lessonModel.lessonId withUserId:user.userId];
    }
    self.isPlaying = NO;
}

-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        if (self.section_GradeView.textView.isFirstResponder) {
//            {{0, 0}, {719, 779}}
            self.view.frame = (CGRect){0,-250,719,779};
        }
    } completion:^(BOOL finished) {
       
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.frame = (CGRect){0,0,719,779};
    } completion:^(BOOL finished) {
        
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.drnavigationBar.searchBar setHidden:YES];
    self.navigationItem.hidesBackButton = YES;
    //打分之后提交
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refeshScore:)
                                                 name: @"refeshScore"
                                               object: nil];
    self.drnavigationBar.titleLabel.text = self.lessonModel.lessonName;
    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMoviePlayMovieOnLineWithSectionSavemodel:) name:@"startPlaySectionMovieOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoMoviePlayWithSid:) name:@"gotoMoviePlay" object:nil];
    [self initAppear];
}
-(void)refeshScore:(NSNotification *)notification {
    NSDictionary *dic = notification.object;
    NSString *score = [dic objectForKey:@"sectionScore"];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.lessonModel.lessonScore = score;
        self.lessonModel.lessonIsScored = @"1";
        [self reloadLessonData:self.lessonModel];
    });

}

/////////////
//播放接口

-(void)playVideo:(id)sender{
    self.isPlaying = YES;
    self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
    chapterModel *chapter = [self.lessonModel.chapterList firstObject];
    SectionModel *section = [chapter.sectionList firstObject];
    SectionModel *lastplaySection = [[Section defaultSection] searchLastPlaySectionModelWithLessonId:self.lessonModel.lessonId];
    if (lastplaySection) {
        lastplaySection.lessonId = self.lessonModel.lessonId;
    }
    section.lessonId = self.lessonModel.lessonId;
    [self.playerController playMovieWithSectionModel:lastplaySection?:section withFileType:MPMovieSourceTypeStreaming];
    self.playerController.delegate = self;
    AppDelegate *app = [AppDelegate sharedInstance];
    [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
        
    }];
}
/////////

-(void)displayView {
    self.slideSwitchView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    //3个选项卡
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor darkGrayColor];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"play-courselist_0df3"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    self.section_ChapterView.title = @"章节目录";
    self.section_ChapterView.isMovieView = NO;
    self.section_ChapterView.dataArray = self.lessonModel.chapterList;
    self.section_ChapterView.lessonId = self.lessonModel.lessonId;
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == NO) {
        self.section_GradeView.title = @"打分";
        self.section_GradeView.dataArray = self.lessonModel.lessonCommentList;
        self.section_GradeView.isGrade = [self.lessonModel.lessonIsScored intValue];
        self.section_GradeView.lessonId = self.lessonModel.lessonId;
        if (self.section_GradeView.dataArray.count > 0) {
//            CommentModel *comment = (CommentModel *)[self.section_GradeView.dataArray objectAtIndex:self.section_GradeView.dataArray.count-1];
//            self.section_GradeView.pageCount = comment.pageCount;
            self.section_GradeView.nowPage = 1;
        }
    }
    self.section_NoteView.title = @"笔记";
    self.section_NoteView.dataArray = self.lessonModel.chapterList;
    self.section_NoteView.delegate = self;
    [self.slideSwitchView buildUI];
}

#pragma mark-- LessonInfoInterfaceDelegate加载课程详细信息 ,播放完成后回调
-(void)getLessonInfoDidFinished:(LessonModel*)lesson{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self reloadLessonData:lesson];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}
-(void)getLessonInfoDidFailed:(NSString *)errorMsg{
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

-(LessonModel *)lessonModelForDrMoviePlayerViewController{
    return self.lessonModel;
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
    [self.section_GradeView.textView resignFirstResponder];
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
            chapterModel *chapter = [self.lessonModel.chapterList firstObject];
            SectionModel *section = [chapter.sectionList firstObject];
            
            self.playerController.delegate = self;
            AppDelegate *app = [AppDelegate sharedInstance];
            [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
                
            }];
            [self.playerController playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
        });
    });
}
-(void)getPlayVideoInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

- (void)gotoMoviePlayMovieOnLineWithSectionSavemodel:(NSNotification *)info {
    self.isPlaying = YES;
    SectionModel *section = [info.userInfo objectForKey:@"sectionModel"];
    if (section.sectionMoviePlayURL) {
        //播放接口
        section.lessonId = self.lessonModel.lessonId;
        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
        self.playerController.delegate = self;
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
        [self.playerController playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
    }else{
        [Utility errorAlert:@"没有发现要播放的视频文件"];
    }
}

- (void)gotoMoviePlayWithSid:(NSNotification *)info {
    self.isPlaying = YES;
    NSString *sectionID = [info.userInfo objectForKey:@"sectionID"];
    NSString *path = [CaiJinTongManager getMovieLocalPathWithSectionID:sectionID];
    if (path) {
        //播放接口
        Section *s = [[Section alloc] init];
        SectionModel *ssm = [s getSectionModelWithSid:sectionID];
        ssm.lessonId = self.lessonModel.lessonId;
        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
        self.playerController.delegate = self;
        [self.playerController playMovieWithSectionModel:ssm withFileType:MPMovieSourceTypeFile];
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
        
    }
}

#pragma mark Section_NoteViewControllerDelegate选中一条笔记
-(void)section_NoteViewController:(Section_NoteViewController *)controller didClickedNoteCellWithObj:(NoteModel *)noteModel{
    self.isPlaying = YES;
    SectionModel *section = nil;
    for (chapterModel *chapter in self.lessonModel.chapterList) {
        if ([chapter.chapterId isEqualToString:noteModel.noteChapterId]) {
            for (SectionModel *sec in chapter.sectionList) {
                if ([sec.sectionId isEqualToString:noteModel.noteSectionId]) {
                    section = sec;
                    break;
                }
            }
            break;
        }
    }
    if (section && section.sectionMoviePlayURL) {
        //播放接口
        section.lessonId = self.lessonModel.lessonId;
        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
        self.playerController.delegate = self;
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
        [self.playerController playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
    }else{
        [Utility errorAlert:@"没有发现要播放的视频文件"];
    }
}
#pragma mark --

#pragma mark property
//-(DRMoviePlayViewController *)playerController{
//    if (!_playerController) {
//        _playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRMoviePlayViewController"];
//        _playerController.delegate = self;
//    }
//    return _playerController;
//}

-(Section_NoteViewController *)section_NoteView{
    if (!_section_NoteView) {
        _section_NoteView = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_NoteViewController"];
        [self addChildViewController:_section_NoteView];
    }
    return _section_NoteView;
}

-(Section_GradeViewController *)section_GradeView{
    if (!_section_GradeView) {
        _section_GradeView = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_GradeViewController"];
        [self addChildViewController:_section_GradeView];
    }
    return _section_GradeView;
}

-(Section_ChapterViewController *)section_ChapterView{
    if (!_section_ChapterView) {
        _section_ChapterView =  [self.storyboard instantiateViewControllerWithIdentifier:@"Section_ChapterViewController"];
        [self addChildViewController:_section_ChapterView];
    }
    return _section_ChapterView;
}

-(LessonInfoInterface *)lessonInterface{
    if (!_lessonInterface) {
        _lessonInterface = [[LessonInfoInterface alloc] init];
        _lessonInterface.delegate = self;
    }
    return _lessonInterface;
}
#pragma mark --

#pragma mark -- appear

-(void)reloadLessonData:(LessonModel*)lesson{
    //封面
    [self.sectionView changeLessonModel:lesson];
    
    //显示分数
    int grade = self.lessonModel.lessonIsScored.intValue;
    if (grade > 0) {
        self.scoreLab.backgroundColor = [UIColor colorWithRed:0.10f green:0.84f blue:0.99f alpha:1.0f];
        self.scoreLab.text = [NSString stringWithFormat:@"%.1f",[lesson.lessonScore floatValue]];
        self.scoreLab.layer.cornerRadius = 7;
        [self.scoreLab setColor:[UIColor whiteColor] fromIndex:0 length:self.scoreLab.text.length];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
    }else{
        self.scoreLab.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
        self.scoreLab.text =[NSString stringWithFormat:@"%.1f",[lesson.lessonScore floatValue]];
        self.scoreLab.layer.cornerRadius = 7;
        [self.scoreLab setColor:[UIColor whiteColor] fromIndex:0 length:self.scoreLab.text.length];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
        [self.scoreLab setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
    }
    
    CGFloat labelTop = 64;
    CGFloat labelSpace = 6;
     float width = 350.0;
     //标题
    self.nameLab.text =[NSString stringWithFormat:@"名称:%@",lesson.lessonName];
//    self.nameLab.frame = (CGRect){275, labelTop, width, 30};
    labelTop +=self.nameLab.frame.size.height+labelSpace;
    
    //简介
    self.detailInfoTextView.text = [NSString stringWithFormat:@"简介:%@",lesson.lessonDetailInfo?:@""];
    self.detailInfoTextView.frame = (CGRect){270, labelTop - 10, width, 100};
    CGSize size = [Utility getTextSizeWithString:self.lessonModel.lessonDetailInfo withFont:[UIFont boldSystemFontOfSize:16] withWidth:width];
    if (size.height > 100) {
        labelTop += 100 +labelSpace;
    }else{
        labelTop += size.height +labelSpace;
    }
    
     //讲师
     self.teacherlab.text =[NSString stringWithFormat:@"讲师:%@",lesson.lessonTeacherName];
    self.teacherlab.frame = CGRectMake(275, labelTop, width, 30);
     labelTop +=self.teacherlab.frame.size.height+labelSpace;
    
    //时长
     self.lastLab.text =[NSString stringWithFormat:@"时长:%@",lesson.lessonDuration];
    self.lastLab.frame = CGRectMake(275, labelTop, width, 30);
    labelTop +=self.lastLab.frame.size.height+labelSpace;
    
    
    //已学习
    self.studyLab.text =[NSString stringWithFormat:@"已学习:%@",lesson.lessonStudyTime];
    self.studyLab.frame = CGRectMake(275, labelTop, width-50, 30);
    
    //播放按钮
    DLog(@"labtop = %f",labelTop);
    if (labelTop <150) {
        labelTop = 200;
    }
    self.playBtn.frame = CGRectMake(585, labelTop, 100, 35);
    if (!lesson.lessonStudyTime || [lesson.lessonStudyTime isEqualToString:@"0"]|| [lesson.lessonStudyTime isEqualToString:@"-"]) {
        [self.playBtn setTitle:NSLocalizedString(@"开始学习", @"button") forState:UIControlStateNormal];
    }else{
        [self.playBtn setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
    }
}

- (void)initAppear {
    if (self.lessonModel) {
        //封面
        SectionCustomView *sv = [[SectionCustomView alloc]initWithFrame:CGRectMake(10, 54, 250, 250) andLessonModel:self.lessonModel andItemLabel:0];
        self.sectionView = sv;
        
        [self.view addSubview:self.sectionView];
        //显示分数
        CustomLabel *scoreLabel = [[CustomLabel alloc]initWithFrame:CGRectMake(630, 64, 60, 60)];
        int grade = self.lessonModel.lessonIsScored.intValue;
        if (grade > 0) {
            scoreLabel.backgroundColor = [UIColor colorWithRed:0.10f green:0.84f blue:0.99f alpha:1.0f];
            scoreLabel.text = [NSString stringWithFormat:@"%.1f",[self.lessonModel.lessonScore floatValue]];
            scoreLabel.layer.cornerRadius = 7;
            [scoreLabel setColor:[UIColor whiteColor] fromIndex:0 length:scoreLabel.text.length];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:50] fromIndex:0 length:1];
            [scoreLabel setFont:[UIFont boldSystemFontOfSize:30] fromIndex:1 length:2];
        }else{
            scoreLabel.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
            scoreLabel.text =[NSString stringWithFormat:@"%.1f",[self.lessonModel.lessonScore floatValue]];
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
        nameLabel.text =[NSString stringWithFormat:@"名称:%@",self.lessonModel.lessonName];
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
        self.detailInfoTextView.text = [NSString stringWithFormat:@"简介:%@",self.lessonModel.lessonDetailInfo?:@""];
        [self.view addSubview:self.detailInfoTextView];
         CGSize size = [Utility getTextSizeWithString:self.lessonModel.lessonDetailInfo withFont:[UIFont boldSystemFontOfSize:16] withWidth:width];
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
        teacherLabel.text =[NSString stringWithFormat:@"讲师:%@",self.lessonModel.lessonTeacherName];
        self.teacherlab = teacherLabel;
        [self.view addSubview:self.teacherlab];
        teacherLabel = nil;
        labelTop +=self.teacherlab.frame.size.height+labelSpace;

        //时长
        UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(275, labelTop, width, 30)];
        lastLabel.backgroundColor = [UIColor clearColor];
        lastLabel.textColor = [UIColor grayColor];
        lastLabel.font = [UIFont boldSystemFontOfSize:16];
        lastLabel.text =[NSString stringWithFormat:@"时长:%@",self.lessonModel.lessonDuration];
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
        studyLabel.text =[NSString stringWithFormat:@"已学习:%@",self.lessonModel.lessonStudyTime];
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
        if (!self.lessonModel.lessonStudyTime || [self.lessonModel.lessonStudyTime isEqualToString:@"0"]|| [self.lessonModel.lessonStudyTime isEqualToString:@"-"]) {
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
