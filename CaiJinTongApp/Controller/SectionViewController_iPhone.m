//
//  SectionViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionViewController_iPhone.h"

@interface SectionViewController_iPhone()
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,strong) LessonInfoInterface *lessonInterface;
@end

@implementation SectionViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//调用本View时要先指定要显示的self.lessonModel
- (void)viewDidLoad
{
    [super viewDidLoad];
    //打分之后提交
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refeshScore:)
                                                 name: @"refeshScore"
                                               object: nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoMoviePlayMovieOnLineWithSectionSavemodel:)
                                                 name:@"startPlaySectionMovieOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoMoviePlayWithSid:)
                                                 name:@"gotoMoviePlay" object:nil];
    [self initAppear];
    [self initAppear_slide];
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
-(void)reloadLessonData:(LessonModel *)lesson{
    //封面
    [self.sectionView refreshDataWithLesson:lesson];
    
    //显示分数
    int grade = self.lessonModel.lessonIsScored.intValue;
    if(grade > 0){
        self.scoreLab.text = [NSString stringWithFormat:@"%.1f",[lesson.lessonScore floatValue]];
    }else{
        self.scoreLab.text = [NSString stringWithFormat:@"%.1f",0.0];
    }
    //标题
    self.nameLab.text =[NSString stringWithFormat:@"名称:%@",lesson.lessonName];
    //    self.nameLab.frame = (CGRect){275, labelTop, width, 30};
    
    //简介
//    self.detailInfoTextView.text = [NSString stringWithFormat:@"简介:%@",lesson.lessonDetailInfo?:@""];
//    self.detailInfoTextView.frame = (CGRect){270, labelTop - 10, width, 100};
//    CGSize size = [Utility getTextSizeWithString:self.lessonModel.lessonDetailInfo withFont:[UIFont boldSystemFontOfSize:16] withWidth:width];
//    if (size.height > 100) {
//        labelTop += 100 +labelSpace;
//    }else{
//        labelTop += size.height +labelSpace;
//    }
    
    //讲师
    self.teacherlab.text =[NSString stringWithFormat:@"讲师:%@",lesson.lessonTeacherName];
    
    //时长
    self.lastLab.text =[NSString stringWithFormat:@"时长:%@",lesson.lessonDuration];
    
    //已学习
    self.studyLab.text =[NSString stringWithFormat:@"已学习:%@",lesson.lessonStudyTime];
    
    //播放按钮
    if (!lesson.lessonStudyTime || [lesson.lessonStudyTime isEqualToString:@"0"]) {
        [self.playBtn setTitle:NSLocalizedString(@"开始学习", @"button") forState:UIControlStateNormal];
    }else{
        [self.playBtn setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isPlaying) {
        //根据sectionID获取单个视频的详细信息
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            UserModel *user = [[CaiJinTongManager shared] user];
            [self.lessonInterface downloadLessonInfoWithLessonId:self.lessonModel.lessonId withUserId:user.userId];
        }
    }
    self.isPlaying = NO;
}

/////////////
//播放接口

- (void)playVideo:(id) sender{
    CGRect f = self.section_NoteView.tableViewList.frame;
    NSLog(@"%f,%f,%f,%f",f.origin.x,f.origin.y,f.size.width,f.size.height);
//    self.isPlaying = YES;
//    self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
//    chapterModel *chapter = [self.lessonModel.chapterList firstObject];
//    SectionModel *section = [chapter.sectionList firstObject];
//    section.lessonId = self.lessonModel.lessonId;
//    SectionModel *lastplaySection = [[Section defaultSection] searchLastPlaySectionModelWithLessonId:self.lessonModel.lessonId];
//    if (lastplaySection) {
//        lastplaySection.lessonId = self.lessonModel.lessonId;
//    }
//    [self.playerController playMovieWithSectionModel:lastplaySection?lastplaySection:section withFileType:MPMovieSourceTypeStreaming];
//    self.playerController.delegate = self;
//    AppDelegate *app = [AppDelegate sharedInstance];
//    [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
//        
//    }];
}

#pragma mark - 滑动tab视图代理方法

- (NSUInteger)numberOfTab:(SUNSlideSwitchView_iPhone *)view
{
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        return 2;
    }
    return 3;
}

- (UIViewController *)slideSwitchView:(SUNSlideSwitchView_iPhone *)view viewOfTab:(NSUInteger)number
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

- (void)slideSwitchView:(SUNSlideSwitchView_iPhone *)view panLeftEdge:(UIPanGestureRecognizer *)panParam
{
}

- (void)slideSwitchView:(SUNSlideSwitchView_iPhone *)view didselectTab:(NSUInteger)number
{
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == YES) {
        Section_ChapterViewController_iPhone *section_ChapterView = nil;
        Section_NoteViewController_iPhone *section_NoteView = nil;
        if (number == 0) {
            section_ChapterView = self.section_ChapterView;
            [section_ChapterView viewDidCurrentView];
        } else if (number == 1) {
            section_NoteView = self.section_NoteView;
            [section_NoteView viewDidCurrentView];
        }
    }else {
        Section_ChapterViewController_iPhone *section_ChapterView = nil;
        Section_GradeViewController_iPhone *section_GradeView = nil;
        Section_NoteViewController_iPhone *section_NoteView = nil;
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

#pragma mark -- init

//界面上半部分
- (void)initAppear {
    if (self.lessonModel) {
        //访问view属性,激活view
        NSLog(@"%f",self.view.frame.origin.x);
        
        //bar标题
        self.lhlNavigationBar.title.text = self.lessonModel.lessonName;
        
        //封面
        SectionCustomView_iPhone *sv = [[SectionCustomView_iPhone alloc]initWithFrame:CGRectMake(18, IP5(75, 60), 125, 125) andLesson:self.lessonModel andItemLabel:0];
        self.sectionView = sv;
        
        [self.view addSubview:self.sectionView];
        //显示分数
        CustomLabel_iPhone *scoreLabel = [[CustomLabel_iPhone alloc]initWithFrame:CGRectMake(245, IP5(80, 65), 55, 55)];
        scoreLabel.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
        scoreLabel.text =[NSString stringWithFormat:@"%.1f",[self.lessonModel.lessonScore floatValue]];
        scoreLabel.layer.cornerRadius = 12;
        [scoreLabel setColor:[UIColor whiteColor] fromIndex:0 length:scoreLabel.text.length];
        [scoreLabel setFont:[UIFont systemFontOfSize:38] fromIndex:0 length:1];
        [scoreLabel setFont:[UIFont systemFontOfSize:20] fromIndex:1 length:2];
        self.scoreLab = scoreLabel;
        [self.view addSubview:self.scoreLab];
        scoreLabel = nil;
        
        //显示参数
        CGFloat labelTop = IP5(145, 125);
        CGFloat labelSpace = IP5(3, 2);
        //标题
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(152, labelTop, 165, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.text =[NSString stringWithFormat:@"名称：%@",self.lessonModel.lessonName];
        self.nameLab = nameLabel;
        [self.view addSubview:self.nameLab];
        nameLabel = nil;
        labelTop +=self.nameLab.frame.size.height+labelSpace;
        //讲师
        UILabel *teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(152, labelTop, 165, 30)];
        teacherLabel.backgroundColor = [UIColor clearColor];
        teacherLabel.textColor = [UIColor darkGrayColor];
        teacherLabel.font = [UIFont systemFontOfSize:15];
        teacherLabel.text =[NSString stringWithFormat:@"讲师：%@",self.lessonModel.lessonTeacherName];
        self.teacherlab = teacherLabel;
        [self.view addSubview:self.teacherlab];
        teacherLabel = nil;
        labelTop +=self.teacherlab.frame.size.height+labelSpace;
        //简介
//        if (self.lessonModel.lessonDetailInfo.length >0) {
            UIFont *aFont = [UIFont systemFontOfSize:15];
            CGSize size = [self.lessonModel.lessonDetailInfo sizeWithFont:aFont constrainedToSize:CGSizeMake(285, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
            CGFloat hh = 0;  //infoLabel的height
            if (size.height-60>0){
                hh = 60;
                self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(20, labelTop, 285, hh)];
                self.scrollView.delegate = self;
                UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 285, size.height)];
                infoLabel.backgroundColor = [UIColor clearColor];
                infoLabel.textColor = [UIColor darkGrayColor];
                infoLabel.numberOfLines = 0;
                infoLabel.font = aFont;
                infoLabel.text =[NSString stringWithFormat:@"简介：%@",self.lessonModel.lessonDetailInfo];
                self.infoLab = infoLabel;
                [self.scrollView addSubview:self.infoLab];
                self.scrollView.contentSize = CGSizeMake(280,self.infoLab.frame.size.height);
                [self.view addSubview:self.scrollView];
                infoLabel = nil;
                labelTop +=self.scrollView.frame.size.height+labelSpace;
            }else {
                if (size.height-60<0 && size.height-30>0) {
                    hh = size.height;
                }else if (size.height-30<0) {
                    hh = 30;
                }
                UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, labelTop, 285, hh)];
                infoLabel.backgroundColor = [UIColor clearColor];
                infoLabel.textColor = [UIColor darkGrayColor];
                infoLabel.numberOfLines = 0;
                infoLabel.font = aFont;
                infoLabel.text =[NSString stringWithFormat:@"简介：%@",self.lessonModel.lessonDetailInfo];
                self.infoLab = infoLabel;
                [self.view addSubview:self.infoLab];
                infoLabel = nil;
                labelTop +=self.infoLab.frame.size.height+labelSpace;
            }
//        }
        
        //时长
        UILabel *lastLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, labelTop, 150, 30)];
        lastLabel.backgroundColor = [UIColor clearColor];
        lastLabel.textColor = [UIColor darkGrayColor];
        lastLabel.font = [UIFont systemFontOfSize:15];
        lastLabel.text =[NSString stringWithFormat:@"时长：%@",self.lessonModel.lessonDuration];
        self.lastLab = lastLabel;
        [self.view addSubview:self.lastLab];
        lastLabel = nil;
//        labelTop +=self.lastLab.frame.size.height+labelSpace;
        //已学习
        DLog(@"labtop = %f",labelTop);
        UILabel *studyLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, labelTop, 150, 30)];
        studyLabel.backgroundColor = [UIColor clearColor];
        studyLabel.textColor = [UIColor darkGrayColor];
        studyLabel.font = [UIFont systemFontOfSize:15];
        NSString *studyProgress = [self.lessonModel.lessonStudyTime stringByReplacingOccurrencesOfString:@"分" withString:@"´"];
        studyProgress = [studyProgress stringByReplacingOccurrencesOfString:@"秒" withString:@"〞"];
        studyLabel.text =[NSString stringWithFormat:@"已学习：%@",studyProgress];
        self.studyLab = studyLabel;
        [self.view addSubview:self.studyLab];
        studyLabel = nil;
        labelTop += self.studyLab.frame.size.height + labelSpace;
        
        //播放按钮
        DLog(@"labtop = %f",labelTop);
        if (labelTop <150) {
            labelTop = 200;
        }
        UIButton *palyButton = [UIButton buttonWithType:UIButtonTypeCustom];
        palyButton.frame = CGRectMake(18, labelTop + IP5(8, -2), 283, IP5(33, 30));
//        [palyButton setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
        if (!self.lessonModel.lessonStudyTime || [self.lessonModel.lessonStudyTime isEqualToString:@"0"]) {
            [palyButton setTitle:NSLocalizedString(@"开始学习", @"button") forState:UIControlStateNormal];
        }else{
            [palyButton setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
        }
        [palyButton setBackgroundColor:[UIColor clearColor]];
		[palyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [palyButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [palyButton addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
        [palyButton setBackgroundImage:[[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)] forState:UIControlStateNormal];
        self.playBtn = palyButton;
        [self.view addSubview:self.playBtn];
        palyButton = nil;
    }
}

//界面下半部分
- (void)initAppear_slide{
    if(!(IS_4_INCH)){
        //43为上半部分减少的高度 , 88 - 43 = 5 + 40
        self.slideSwitchView.frame = CGRectMake(0, 362 - 43 -5, 320, 206 - 40);
    }
    self.slideSwitchView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    //3个选项卡
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView_iPhone colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor darkGrayColor];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"play-courselist_0df3"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
//    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    //章节页面
//    self.section_ChapterView = [story instantiateViewControllerWithIdentifier:@"Section_ChapterViewController_iPhone"];
    [self.section_ChapterView.view frame];
    [self.section_ChapterView.tableViewList setFrame:CGRectMake(22, 0, 276, self.slideSwitchView.frame.size.height - IP5(63, 53))];
    self.section_ChapterView.title = @"章节目录";
    self.section_ChapterView.lessonId = self.lessonModel.lessonId;
    self.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:self.lessonModel.chapterList];
    self.section_ChapterView.isMovieView = NO;
    
    //评价页面
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == NO) {
        self.section_GradeView.title = @"打分";
        self.section_GradeView.dataArray = [NSMutableArray arrayWithArray:self.lessonModel.lessonCommentList];
        self.section_GradeView.isGrade = [self.lessonModel.lessonIsScored intValue];
        self.section_GradeView.lessonId = self.lessonModel.lessonId;
        if(self.section_GradeView.dataArray.count > 0){
            self.section_GradeView.nowPage = 1;
        }
    }
    
    //笔记页面
    [self.section_NoteView.view setFrame:CGRectMake(0, 0, 320, IP5(568, 480))];
    self.section_NoteView.title = @"笔记";
    self.section_NoteView.delegate = self;
    [self.section_NoteView.tableViewList setFrame:CGRectMake(22, 0, 276, self.slideSwitchView.frame.size.height - IP5(63, 53))];
    self.section_NoteView.dataArray = [NSMutableArray arrayWithArray:self.lessonModel.chapterList];
    
    [self.slideSwitchView buildUI];
}

#pragma mark -- PlayVideoInterfaceDelegate
-(void)getPlayVideoInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //播放接口
            self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
            chapterModel *chapter = [self.lessonModel.chapterList firstObject];
            SectionModel *section = [chapter.sectionList firstObject];
            [self.playerController playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
//            self.playerController.sectionId = self.lessonModel.lessonId;
//            self.playerController.sectionModel = self.section;
            
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

- (void)gotoMoviePlayMovieOnLineWithSectionSavemodel:(NSNotification *)info {
    self.isPlaying = YES;
    SectionModel *section = [info.userInfo objectForKey:@"sectionModel"];
    if (section.sectionMoviePlayURL) {
        //播放接口
        section.lessonId = self.lessonModel.lessonId;
        if(!self.playerController){
            self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
            self.playerController.delegate = self;
        }
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
        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
        self.playerController.delegate = self;
        [self.playerController playMovieWithSectionModel:ssm withFileType:MPMovieSourceTypeFile];
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
        
    }
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

#pragma mark DRMoviePlayViewControllerDelegate 提交笔记成功
-(void)lhlMoviePlayerViewController:(LHLMoviePlayViewController *)playerController commitNotesSuccess:(NSString *)noteText andTime:(NSString *)noteTime{
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

#pragma mark Section_NoteViewControllerDelegate选中一条笔记
-(void)section_NoteViewController:(Section_NoteViewController_iPhone *)controller didClickedNoteCellWithObj:(NoteModel *)noteModel{
    [self playVideo:Nil];
}

#pragma mark property
//setter自动转换LessonModel参数为Section
-(void)setSection:(SectionModel *)section{
    if([section isKindOfClass:[LessonModel class]]){
        _section = ((LessonModel *)section).toSection;
    }else{
        _section = section;
    }
}

-(Section_NoteViewController_iPhone *)section_NoteView{
    if (!_section_NoteView) {
        _section_NoteView = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_NoteViewController_iPhone"];
        [self addChildViewController:_section_NoteView];
    }
    return _section_NoteView;
}

-(Section_GradeViewController_iPhone *)section_GradeView{
    if (!_section_GradeView) {
        _section_GradeView = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_GradeViewController_iPhone"];
        [self addChildViewController:_section_GradeView];
    }
    return _section_GradeView;
}

-(Section_ChapterViewController_iPhone *)section_ChapterView{
    if (!_section_ChapterView) {
        _section_ChapterView =  [self.storyboard instantiateViewControllerWithIdentifier:@"Section_ChapterViewController_iPhone"];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
