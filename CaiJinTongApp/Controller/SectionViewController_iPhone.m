//
//  SectionViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-28.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionViewController_iPhone.h"

@interface SectionViewController_iPhone ()

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

//调用本View时要先指定要显示的section
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self initData];
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
//装载数据,目标 :self.section
-(void) initData{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        if(!self.sectionInterface){
            self.sectionInterface = [[SectionInfoInterface alloc] init];
            self.sectionInterface.delegate = self;
        }
        [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andSectionId:@"2928"];
    }
}

- (void)playVideo:(id) sender{
    DLog(@"play");
    self.path = nil;//视频路径
    //先匹配本地,在数据库中查找纪录
    Section *sectionDb = [[Section alloc]init];
    SectionSaveModel *sectionSave = [sectionDb getDataWithSid:self.section.sectionId];
    if (sectionSave != nil && sectionSave.downloadState == 1) {
        NSString *documentDir;
        if (platform>5.0) {
            documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        }else{
            documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        }
        self.path = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/Application/%@.mp4",self.section.sectionId]];
        
        self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
        
        [self.playerController playMovieWithURL:[NSURL fileURLWithPath:self.path] withFileType:MPMovieSourceTypeFile];
        self.playerController.sectionId = self.section.sectionId;
        self.playerController.sectionModel = self.section;
        
        self.playerController.delegate = self;
        AppDelegate *app = [AppDelegate sharedInstance];
        [app.lessonViewCtrol presentViewController:self.playerController animated:YES completion:^{
            
        }];
    }else {
        //在线播放
        self.path = self.section.sectionSD;
        if (self.path) {
            if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
                [Utility errorAlert:@"暂无网络!"];
            }else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                PlayVideoInterface *playVideoInter = [[PlayVideoInterface alloc]init];
                self.playVideoInterface = playVideoInter;
                self.playVideoInterface.delegate = self;
                NSString *timespan = [Utility getNowDateFromatAnDate];
                [self.playVideoInterface getPlayVideoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.section.sectionId andTimeStart:timespan];
            }
        }
    }
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
    if (self.section) {
        //封面
        SectionCustomView_iPhone *sv = [[SectionCustomView_iPhone alloc]initWithFrame:CGRectMake(18, 75, 125, 125) andSection:self.section andItemLabel:0];
        self.sectionView = sv;
        
        [self.view addSubview:self.sectionView];
        //显示分数
        CustomLabel_iPhone *scoreLabel = [[CustomLabel_iPhone alloc]initWithFrame:CGRectMake(245, 80, 55, 55)];
        scoreLabel.backgroundColor = [UIColor colorWithRed:12.0/255.0 green:58.0/255.0 blue:94.0/255.0 alpha:1.0f];
        scoreLabel.text =[NSString stringWithFormat:@"%.1f",[self.section.sectionScore floatValue]];
        scoreLabel.layer.cornerRadius = 12;
        [scoreLabel setColor:[UIColor whiteColor] fromIndex:0 length:scoreLabel.text.length];
        [scoreLabel setFont:[UIFont systemFontOfSize:38] fromIndex:0 length:1];
        [scoreLabel setFont:[UIFont systemFontOfSize:20] fromIndex:1 length:2];
        self.scoreLab = scoreLabel;
        [self.view addSubview:self.scoreLab];
        scoreLabel = nil;
        
        //显示参数
        CGFloat labelTop = 145;
        CGFloat labelSpace = 3;
        //标题
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(152, labelTop, 165, 30)];
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:15];
        nameLabel.text =[NSString stringWithFormat:@"名称：%@",self.section.sectionName];
        self.nameLab = nameLabel;
        [self.view addSubview:self.nameLab];
        nameLabel = nil;
        labelTop +=self.nameLab.frame.size.height+labelSpace;
        //讲师
//        if (self.section.sectionTeacher.length >0) {
            UILabel *teacherLabel = [[UILabel alloc]initWithFrame:CGRectMake(152, labelTop, 165, 30)];
            teacherLabel.backgroundColor = [UIColor clearColor];
            teacherLabel.textColor = [UIColor darkGrayColor];
            teacherLabel.font = [UIFont systemFontOfSize:15];
            teacherLabel.text =[NSString stringWithFormat:@"讲师：%@",self.section.sectionTeacher];
            self.teacherlab = teacherLabel;
            [self.view addSubview:self.teacherlab];
            teacherLabel = nil;
            labelTop +=self.teacherlab.frame.size.height+labelSpace;
//        }
        //简介
//        if (self.section.lessonInfo.length >0) {
            UIFont *aFont = [UIFont systemFontOfSize:15];
            CGSize size = [self.section.lessonInfo sizeWithFont:aFont constrainedToSize:CGSizeMake(285, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
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
                infoLabel.text =[NSString stringWithFormat:@"简介：%@",self.section.lessonInfo];
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
                infoLabel.text =[NSString stringWithFormat:@"简介：%@",self.section.lessonInfo];
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
        lastLabel.text =[NSString stringWithFormat:@"时长：%@",self.section.sectionLastTime];
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
        NSString *studyProgress = [self.section.sectionStudy stringByReplacingOccurrencesOfString:@"分" withString:@"´"];
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
        palyButton.frame = CGRectMake(18, labelTop + 8, 283, 33);
        [palyButton setTitle:NSLocalizedString(@"继续学习", @"button") forState:UIControlStateNormal];
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
    self.slideSwitchView.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    //3个选项卡
    self.slideSwitchView.tabItemNormalColor = [SUNSlideSwitchView_iPhone colorFromHexRGB:@"868686"];
    self.slideSwitchView.tabItemSelectedColor = [UIColor darkGrayColor];
    self.slideSwitchView.shadowImage = [[UIImage imageNamed:@"play-courselist_0df3"]
                                        stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    
    //章节页面
    self.section_ChapterView = [story instantiateViewControllerWithIdentifier:@"Section_ChapterViewController_iPhone"];
    self.section_ChapterView.title = @"章节目录";
    self.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:self.section.sectionList];
    [self.section_ChapterView.tableViewList reloadData];
    
    //评价页面
    AppDelegate *app = [AppDelegate sharedInstance];
    if (app.isLocal == NO) {
        self.section_GradeView = [story instantiateViewControllerWithIdentifier:@"Section_GradeViewController_iPhone"];
        self.section_GradeView.title = @"打分";
        self.section_GradeView.dataArray = [NSMutableArray arrayWithArray:self.section.commentList];
        self.section_GradeView.isGrade = [self.section.isGrade intValue];
        self.section_GradeView.sectionId = self.section.sectionId;
        CommentModel *comment = (CommentModel *)[self.section_GradeView.dataArray objectAtIndex:self.section_GradeView.dataArray.count-1];
        self.section_GradeView.pageCount = comment.pageCount;
        self.section_GradeView.nowPage = 1;
    }
    
    //笔记页面
    self.section_NoteView = [story instantiateViewControllerWithIdentifier:@"Section_NoteViewController_iPhone"];
    self.section_NoteView.title = @"笔记";
    self.section_NoteView.dataArray = [NSMutableArray arrayWithArray:self.section.noteList];
    
    [self.slideSwitchView buildUI];
}

#pragma mark -- SectionInfoInterface
-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SectionModel *section = (SectionModel *)result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.section = section;
            self.section_ChapterView.dataArray = [NSMutableArray arrayWithArray:self.section.sectionList];
            [self.section_ChapterView.tableViewList reloadData];
            [self initAppear];          //界面上半部分
            [self initAppear_slide];    //界面下半部分(滑动视图)
        });
    });
}

-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark -- PlayVideoInterfaceDelegate
-(void)getPlayVideoInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //播放接口
            DLog(@"self.storyboard = %@",self.storyboard);
            self.playerController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLMoviePlayViewController"];
            [self.playerController playMovieWithURL:[NSURL URLWithString:self.path] withFileType:MPMovieSourceTypeStreaming];
            self.playerController.sectionId = self.section.sectionId;
            self.playerController.sectionModel = self.section;
            
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

#pragma mark

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
