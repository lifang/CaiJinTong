//
//  DRMoviePlayViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRMoviePlayViewController.h"
#import <MediaPlayer/MPMoviePlayerController.h>
#import <QuartzCore/QuartzCore.h>
#import "DRTakingMovieNoteViewController.h"
#import "MBProgressHUD.h"
#import "DRCommitQuestionViewController.h"
#import "Section.h"
#import "LessonModel.h"
#define MOVIE_CURRENT_PLAY_TIME_OBSERVE @"movieCurrentPlayTimeObserve"
@interface DRMoviePlayViewController ()<DRTakingMovieNoteViewControllerDelegate,DRCommitQuestionViewControllerDelegate>
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *studyTimer;
@property (nonatomic,strong) Section_ChapterViewController *section_chapterController;
@property (nonatomic,assign) BOOL isHiddlePlayerControlView;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPopupChapter;
@property (nonatomic,assign) BOOL isBack;//是否退出播放
@property (nonatomic,assign) __block float currentMoviePlaterVolume;
@property (nonatomic, strong) SectionModel *sectionModel;
@property (nonatomic, assign) long  long studyTime;//学习时间
@property (assign,nonatomic) MPMovieSourceType drMovieSourceType;//播放文件类型，本地还是在线视频
@end

@implementation DRMoviePlayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if (self.sectionModel) {
        self.drMovieTopBar.titleLabel.text = self.sectionModel.sectionName;
    }
}

-(void)willDismissPopoupController{
    self.myQuestionItem.isSelected = NO;
    self.myNotesItem.isSelected = NO;
    if (self.isPlaying) {
        
        [self.moviePlayer play];
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
     [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark app notification
- (void)appWillResignActive:(UIApplication *)application
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
}

- (void)appDidEnterBackground:(UIApplication *)application
{
    if (self.isPlaying) {
        [self.moviePlayer pause];
    }
}

- (void)appWillEnterForeground:(UIApplication *)application
{
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}

- (void)appDidBecomeActive:(UIApplication *)application
{
    if (self.isPlaying) {
        [self.moviePlayer play];
    }
}
//程序退出
- (void)appWillTerminate:(UIApplication *)application
{
    self.isBack = NO;
    [self saveCurrentStatus];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
}
#pragma mark --

-(void)addApplicationNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changePlayVideoOnLine:) name:@"changePlaySectionMovieOnLine" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playVideo:) name:@"gotoMoviePlayMovie" object:nil];
    [self addApplicationNotification];
    [super viewDidLoad];
    self.myNotesItem.delegate = self;
    self.myQuestionItem.delegate = self;
    
    self.isPopupChapter = NO;
//    [self addMoviePlayBackNotification];

//    [self.moviePlayer play];
    self.moviePlayer.view.frame = (CGRect){0,0,1024,768};
    [self.moviePlayer setFullscreen:YES];
    [self playMovie];
    [self hiddleMovieHolderView];
    [self updateVolumeSlider];
    self.moviePlayerHolderView.layer.cornerRadius = 10;
    
    //视频加载提示框
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.moviePlayerControlBackDownView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"play_barBG.png"]]];
    [self.seekSlider setMaximumTrackImage:[UIImage imageNamed:@"play_black.png"] forState:UIControlStateNormal];
    [self.seekSlider setMinimumTrackImage:[UIImage imageNamed:@"play_bluetiao.png"] forState:UIControlStateNormal];
    [self.seekSlider setThumbImage:[UIImage imageNamed:@"play_movieSlider.png"] forState:UIControlStateNormal];
    
    [self.volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"play-courselist_0d3.png"] forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"play-courselist_0df3.png"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"play-courselist_03.png"] forState:UIControlStateNormal];
}

-(void)dealloc{
    [self removeMoviePlayBackNotification];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MovieControllerItemDelegate
-(void)moviePlayBarSelected:(MovieControllerItem *)item{
    if (item == self.chapterListItem) {
        if (!self.isPopupChapter) {
            if (!self.section_chapterController) {
                self.section_chapterController = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_ChapterViewController"];
                self.section_chapterController.view.frame = (CGRect){1024,0,1024-700,685};
                self.section_chapterController.isMovieView = YES;
                 [self.view addSubview:self.section_chapterController.view];
            }
            self.section_chapterController.lessonId = self.sectionModel.lessonId;
            LessonModel *lessonModel = [self.delegate lessonModelForDrMoviePlayerViewController];
            if (lessonModel) {
                self.section_chapterController.dataArray = lessonModel.chapterList;
            }
            
//            if (self.drMovieSourceType == MPMovieSourceTypeStreaming) {
//                self.section_chapterController.dataArray =  [NSMutableArray arrayWithArray:self.sectionModel.sectionList];
//            } else if (self.drMovieSourceType == MPMovieSourceTypeFile) {
//                Section *sectionDB = [[Section alloc] init];
//                self.section_chapterController.dataArray = [NSMutableArray arrayWithArray:[sectionDB getChapterInfoWithSid:self.sectionSaveModel.sid]];
//            }
            self.isPopupChapter = YES;
        }else {
            self.isPopupChapter = NO;
        }
    }else
    if (item == self.myQuestionItem) {
        [self.moviePlayer pause];
        DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRCommitQuestionViewController"];
        commitController.view.frame = (CGRect){0,0,804,426};
        commitController.delegate = self;
        [self presentPopupViewController:commitController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            self.myQuestionItem.isSelected = NO;
        }];
        self.isPopupChapter = NO;
    }else
    if (item == self.myNotesItem) {
        [self.moviePlayer pause];
        DRTakingMovieNoteViewController *takingController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRTakingMovieNoteViewController"];
        takingController.view.frame = (CGRect){0,0,804,300};
        takingController.delegate = self;
        [self presentPopupViewController:takingController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            self.myNotesItem.isSelected = NO;
        }];
        self.isPopupChapter = NO;
        
        
    }
}
#pragma mark --

- (IBAction)playBtClicked:(id)sender {
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying) {
        [self.moviePlayer play];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_paused.png"] forState:UIControlStateNormal];
        [self startStudyTime];
    }else{
        [self.moviePlayer pause];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateNormal];
        [self pauseStudyTime];
    }
}

- (IBAction)seekSliderTouchChangeValue:(id)sender {
    NSLog(@"seekSliderTouchChangeValue:%f",((UISlider*)sender).value);
    double playBack = self.moviePlayer.duration*((UISlider*)sender).value;
    DLog(@"%f,%f",self.moviePlayer.duration,((UISlider*)sender).value);
//    if (playBack > self.moviePlayer.currentPlaybackTime) {
//        [self.moviePlayer beginSeekingForward];
//    }else{
//        [self.moviePlayer beginSeekingBackward];
//    }
    self.moviePlayer.currentPlaybackTime = playBack;
}

- (IBAction)volumeSliderTouchChangeValue:(id)sender {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = [(UISlider*)sender value];
}

- (IBAction)volumeBtClicked:(id)sender {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    NSLog(@"%f,%f",mpc.volume,self.currentMoviePlaterVolume);
    if (mpc.volume < 0.00000001) {
        mpc.volume = self.currentMoviePlaterVolume;
        [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"play_volume.png"] forState:UIControlStateNormal];
    }else{
        [(UIButton*)sender setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        self.currentMoviePlaterVolume = mpc.volume;
        mpc.volume = 0;
    }
    [self updateVolumeSlider];
}

#pragma mark CustomPlayerViewDelegate
-(void)Touchretreat{
    self.moviePlayerHolderView.holderImageView.image = [UIImage imageNamed:@"retreat.png"];
    self.moviePlayerHolderView.holderLaber.text = @"快退30秒";
    [self.moviePlayerHolderView setHidden:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddleMovieHolderView) object:nil];
    [self performSelector:@selector(hiddleMovieHolderView) withObject:Nil afterDelay:1];
    if (self.moviePlayer.currentPlaybackTime > 30) {
        self.moviePlayer.currentPlaybackTime -= 30;
    }
}

-(void)Touchspeed{
    self.moviePlayerHolderView.holderImageView.image = [UIImage imageNamed:@"speed.png"];
    self.moviePlayerHolderView.holderLaber.text = @"快进30秒";
    [self.moviePlayerHolderView setHidden:NO];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddleMovieHolderView) object:nil];
    [self performSelector:@selector(hiddleMovieHolderView) withObject:Nil afterDelay:1];
    if (self.moviePlayer.duration -  self.moviePlayer.currentPlaybackTime > 30) {
        self.moviePlayer.currentPlaybackTime += 30;
    }
}

-(void)TouchSingleTap{
    self.isHiddlePlayerControlView = !self.isHiddlePlayerControlView;
}

-(void)TouchVolumeUP{
    [self updateVolumeSlider];
}
-(void)TouchVolumeDOWN{
    [self updateVolumeSlider];
}
#pragma mark --

#pragma mark notification//切换视频
-(void)changePlayVideoOnLine:(NSNotification*)notification{
    self.isBack = NO;
    [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    [self saveCurrentStatus];
     SectionModel *section = [notification.userInfo objectForKey:@"sectionModel"];
    self.drMovieSourceType = MPMovieSourceTypeStreaming;
    NSURL *url = [NSURL URLWithString:section.sectionMoviePlayURL];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
        [self playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
    }else{
        [Utility errorAlert:@"当前文件正在播放"];
        [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
    }
}

-(void)playVideo:(NSNotification*)notification{
    [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    self.isBack = NO;
    [self saveCurrentStatus];
    NSString *sectionID = [notification.userInfo objectForKey:@"sectionID"];
    NSString *path = [CaiJinTongManager getMovieLocalPathWithSectionID:sectionID];
    Section *s = [[Section alloc] init];
    SectionModel *ssm = [s getSectionModelWithSid:sectionID];
    self.drMovieSourceType = MPMovieSourceTypeFile;
    NSURL *url = [NSURL fileURLWithPath:path];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
        [self playMovieWithSectionModel:ssm withFileType:MPMovieSourceTypeFile];
    }else{
        [Utility errorAlert:@"当前文件正在播放"];
        [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
    }
}


-(void)didChangeMoviePlayerStateNotification{//当播放，暂停时触发
    DLog(@"didChangeMoviePlayerStateNotification:%d",self.moviePlayer.playbackState);
    switch (self.moviePlayer.playbackState) {
        case MPMoviePlaybackStateStopped:
        {
            break;
        }
        
        case MPMoviePlaybackStatePlaying:
        {
            [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
            [self startObservePlayBackProgressBar];
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {
            [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
            break;
        }
        
        case MPMoviePlaybackStateSeekingForward:
        {
            break;
        }
            
        case MPMoviePlaybackStateSeekingBackward:
        {
            break;
        }
        default:
            break;
    }
}

-(void)didFinishedMoviePlayerNotification:(NSNotification*)notification{//播放完成，或者错误时触发
    DLog(@"didFinishedMoviePlayerNotification:%@",[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey]);
    [self endObservePlayBackProgressBar];
    [self updateMoviePlayBackProgressBar];
    
    if ([[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue] == MPMovieFinishReasonPlaybackEnded) {
        self.seekSlider.value = 1;
    }else
    if ([[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue] == MPMovieFinishReasonPlaybackError) {
        self.seekSlider.value = 0;
        [self removeMoviePlayBackNotification];
        [Utility errorAlert:@"播放文件已经损坏或是格式不支持"];
    }
}

-(void)didChangeMoviePlayerURLNotification{//播放的视频url改变时触发
    DLog(@"didChangeMoviePlayerURLNotification:%@",self.moviePlayer.contentURL);
}

-(void)didChangeMoviePlayerLoadStateNotification{//加载状态改变时触发：
    DLog(@"didChangeMoviePlayerLoadStateNotification:%d",self.moviePlayer.loadState);
    if (self.moviePlayer.loadState == MPMovieLoadStatePlayable) {
        [MBProgressHUD hideHUDForView:self.moviePlayerView animated:YES];
    } else if (self.moviePlayer.loadState == MPMovieLoadStateStalled) {
        [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    }else if (self.moviePlayer.loadState == MPMovieLoadStatePlaythroughOK) {
        [MBProgressHUD hideHUDForView:self.moviePlayerView animated:YES];
    }
    
}

#pragma mark --


#pragma mark -- 提交问题
-(void)commitQuestionController:(DRCommitQuestionViewController *)controller didCommitQuestionWithTitle:(NSString *)title andText:(NSString *)text andQuestionId:(NSString *)questionId{
    self.myQuestionItem.isSelected = NO;
    [self.moviePlayer play];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AskQuestionInterface *askQuestionInter = [[AskQuestionInterface alloc]init];
        self.askQuestionInterface = askQuestionInter;
        self.askQuestionInterface.delegate = self;
        [self.askQuestionInterface getAskQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:questionId andQuestionName:title andQuestionContent:text];
    }
}

-(void)commitQuestionControllerCancel{
}
#pragma mark --

#pragma mark -- 提交笔记
-(void)takingMovieNoteController:(DRTakingMovieNoteViewController *)controller commitNote:(NSString *)text andTime:(NSString *)noteTime{
    self.commitNoteText = text;
    self.commitNoteTime = noteTime;
    self.myNotesItem.isSelected = NO;
    [self.moviePlayer play];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SumitNoteInterface *sumitNoteInter = [[SumitNoteInterface alloc]init];
        self.sumitNoteInterface = sumitNoteInter;
        self.sumitNoteInterface.delegate = self;
        [self.sumitNoteInterface
         getSumitNoteInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId
         andSectionId:self.sectionModel.sectionId
         andNoteTime:noteTime
         andNoteText:text];
    }
}

-(void)takingMovieNoteControllerCancel{
}
#pragma mark --

#pragma mark DRMoviePlayerTopBarDelegate播放完成退出界面

-(void)exitPlayMovie{
    [self.section_chapterController willMoveToParentViewController:nil];
    [self.section_chapterController removeFromParentViewController];
    [self.section_chapterController.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.moviePlayer stop];
        self.moviePlayer = nil;
    }];
}

-(void)drMoviePlayerTopBarbackItemClicked:(DRMoviePlayerTopBar *)topBar{
    self.isBack = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     [self saveCurrentStatus];
}
#pragma mark --

#pragma mark DRMoviePlayerPlaybackProgressBarDelegate
-(void)playBackProgressBarTouchBegin:(DRMoviePlayerPlaybackProgressBar *)progressBar{
    [self.moviePlayer pause];
    [self endObservePlayBackProgressBar];
}

-(void)playBackProgressBarTouchEnd:(DRMoviePlayerPlaybackProgressBar *)progressBar{
    [self.moviePlayer play];
//    [self.moviePlayer endSeeking];
    [self startObservePlayBackProgressBar];
}

#pragma mark --
#pragma mark action

-(void)playMovie{
    if (!self.movieUrl) {
        return;
    }
    [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    self.moviePlayer.initialPlaybackTime = [self.sectionModel.sectionLastPlayTime floatValue];
    if (self.drMovieSourceType == MPMovieSourceTypeFile) {
        [self.moviePlayer setContentURL:self.movieUrl];
        [self.moviePlayer play];
    }else
        if (self.drMovieSourceType == MPMovieSourceTypeStreaming) {
            [self.moviePlayer setContentURL:self.movieUrl];
            [self.moviePlayer prepareToPlay];
            [self.moviePlayer play];
        }
//    [self.moviePlayer beginSeekingForward];
    
//    [self.moviePlayer endSeeking];
    self.isPlaying = YES;
    [self startStudyTime];
}

-(void)saveCurrentStatus{
    [self  endStudyTime];
    NSString *timespan = [NSString stringWithFormat:@"%.2f",self.moviePlayer.currentPlaybackTime];
    self.sectionModel.sectionFinishedDate = [Utility getNowDateFromatAnDate];
    self.sectionModel.sectionLastPlayTime = timespan;
    [[Section defaultSection] saveSectionModelFinishedDateWithSectionModel:self.sectionModel withLessonId:self.sectionModel.lessonId];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        if (self.isBack) {
            [self exitPlayMovie];
        }
        [[Section defaultSection] addPlayTimeOffLineWithSectionId:self.sectionModel.sectionId withTimeForSecond:[NSString stringWithFormat:@"%llu",self.studyTime]];
    }else {
        //判断是否播放完毕
        //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
        PlayBackInterface *playBackInter = [[PlayBackInterface alloc]init];
        self.playBackInterface = playBackInter;
        self.playBackInterface.delegate = self;
        NSString *totalTime = [[Section defaultSection] selectTotalPlayTimeOffLineWithSectionId:self.sectionModel.sectionId];
        if (totalTime && ![totalTime isEqualToString:@"0"]) {
            timespan = [[Section defaultSection] selectTotalPlayDateOffLineWithSectionId:self.sectionModel.sectionId];
        }else{
            timespan = [Utility getNowDateFromatAnDate];
        }
        NSString *status = self.seekSlider.value >= 1?@"completed": @"incomplete";
        [self.playBackInterface getPlayBackInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionModel.sectionId andTimeEnd:timespan andStatus:status];
    }
}


-(void)playMovieWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType{
        if (!sectionModel) {
            [Utility errorAlert:@"没有发现要播放的文件"];
            return;
        }
    self.sectionModel = sectionModel;
    [self addMoviePlayBackNotification];
    self.drMovieSourceType = fileType;
    self.drMovieTopBar.titleLabel.text = sectionModel.sectionName;
    if (fileType == MPMovieSourceTypeFile) {
        self.movieUrl = [NSURL fileURLWithPath:[CaiJinTongManager getMovieLocalPathWithSectionID:sectionModel.sectionId]];
    }else
        if (fileType == MPMovieSourceTypeStreaming) {
            self.movieUrl = [NSURL URLWithString:sectionModel.sectionMoviePlayURL];
        }
    if (self.isViewLoaded) {
        [self playMovie];
    }
}

-(void)addMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerLoadStateNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerStateNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedMoviePlayerNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerURLNotification) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
}

-(void)removeMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
}

-(void)updateStudyTimeValue{
    self.studyTime +=30;
}

//开始学习记时
-(void)startStudyTime{
    if (self.studyTimer) {
        [self.studyTimer invalidate];
        self.studyTimer = nil;
    }
    self.studyTimer = [NSTimer timerWithTimeInterval:30 target:self selector:@selector(updateStudyTimeValue) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.studyTimer forMode:NSDefaultRunLoopMode];
    [self.studyTimer fire];
}
//暂停学习记时
-(void)pauseStudyTime{
    if (self.studyTimer) {
        [self.studyTimer invalidate];
        self.studyTimer = nil;
    }
}
//结束记时
-(void)endStudyTime{
    self.studyTime = 0;
    if (self.studyTimer) {
        [self.studyTimer invalidate];
        self.studyTimer = nil;
    }
}
//实时更新进度条
-(void)startObservePlayBackProgressBar{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateMoviePlayBackProgressBar) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    [self.timer fire];
}

-(void)updateMoviePlayBackProgressBar{
    self.seekSlider.value = (double)self.moviePlayer.currentPlaybackTime/self.moviePlayer.duration;
}
-(void)endObservePlayBackProgressBar{
    [self.timer invalidate];
    self.timer = nil;
}

-(void)updateVolumeSlider{
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    self.volumeSlider.value = mpc.volume;
}

-(void)hiddleMovieHolderView{
    [self.moviePlayerHolderView setHidden:YES];
}

#pragma mark --

#pragma mark property

-(void)setIsPopupChapter:(BOOL)isPopupChapter{
    _isPopupChapter = isPopupChapter;
    if (self.section_chapterController) {
        [self.movieplayerControlBackView setUserInteractionEnabled:NO];
        self.chapterListItem.isSelected = isPopupChapter;
        if (!isPopupChapter) {
            [self.section_chapterController willMoveToParentViewController:nil];
            [UIView animateWithDuration:0.5 animations:^{
                self.section_chapterController.view.frame = (CGRect){1024,0,1024-700,685};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
            [self.section_chapterController removeFromParentViewController];
        }else{
            [self.section_chapterController willMoveToParentViewController:self];
            [UIView animateWithDuration:0.5 animations:^{
                self.section_chapterController.view.frame = (CGRect){324,0,1024-324,685};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
            [self addChildViewController:self.section_chapterController];
        }
    }
}

-(void)setIsHiddlePlayerControlView:(BOOL)isHiddlePlayerControlView{
    _isHiddlePlayerControlView = isHiddlePlayerControlView;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHiddlePlayerControlView) {
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = NO;
                self.chapterListItem.isSelected = YES;
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,768+50};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-20};
        }else{
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = YES;
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,768-50};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,20};
            NSLog(@"%@",NSStringFromCGRect(self.movieplayerControlBackView.frame));
        }
    }];
}

-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        [_moviePlayer setShouldAutoplay:YES];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        [self.moviePlayerView addSubview:_moviePlayer.view];
        [self.moviePlayerView sendSubviewToBack:_moviePlayer.view];
        
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
    }
    return _moviePlayer;
}

#pragma mark --

- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark TOUCH
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
////    [super touchesBegan:touches withEvent:event];
//    if (self.isPopupChapter) {
//        self.isPopupChapter = NO;
//    }
//}
#pragma mark -- PlayBackInterfaceDelegate

-(void)getPlayBackInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (self.isBack) {
                [self exitPlayMovie];
            }
            [[Section defaultSection] updatePlayDateOffLineWithSectionId:self.sectionModel.sectionId];
        });
    });
}
-(void)getPlayBackDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.isBack) {
            [self exitPlayMovie];
        }else
            if (![errorMsg isEqualToString:@""]) {
                [Utility errorAlert:errorMsg];
            }
        
    });
}
#pragma mark -- SumitNoteInterfaceDelegate
-(void)getSumitNoteInfoDidFinished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"笔记提交成功"];
            //前一个view笔记里面加上刚提交的笔记
            if (self.delegate && [self.delegate respondsToSelector:@selector(drMoviePlayerViewController:commitNotesSuccess:andTime:)]) {
                [self.delegate drMoviePlayerViewController:self commitNotesSuccess:self.commitNoteText andTime:self.commitNoteTime];
            }
        });
    });
}
-(void)getSumitNoteDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"问题提交成功"];
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}
@end
