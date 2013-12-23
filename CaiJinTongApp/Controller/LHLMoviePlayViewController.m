//
//  LHLMoviePlayViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLMoviePlayViewController.h"
#define MOVIE_CURRENT_PLAY_TIME_OBSERVE @"movieCurrentPlayTimeObserve"
@interface LHLMoviePlayViewController ()<DRTakingMovieNoteViewControllerDelegate,DRCommitQuestionViewControllerDelegate>
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) Section_ChapterViewController_iPhone *section_chapterController;
@property (nonatomic,assign) BOOL isHiddlePlayerControlView;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPopupChapter;
@property (nonatomic,assign) __block float currentMoviePlaterVolume;
@end

@implementation LHLMoviePlayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if (self.sectionModel) {
        self.drMovieTopBar.titleLabel.text = self.sectionModel.sectionName;
    }
    else if(self.sectionSaveModel){
        self.drMovieTopBar.titleLabel.text = self.sectionSaveModel.name;
    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

//重写此方法以获得子VC
//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    if ([segue.identifier isEqualToString:@"Section_ChapterViewController_iPhone_embed"])
//    {
//        self.section_chapterController = segue.destinationViewController;
//    }
//}

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
                                             selector:@selector(playVideo:) name:@"gotoMoviePlay" object:nil];
    [self addApplicationNotification];
    [super viewDidLoad];
    self.myNotesItem.delegate = self;
    self.myQuestionItem.delegate = self;
    
    self.isPopupChapter = NO;
    [self addMoviePlayBackNotification];
    
    //    [self.moviePlayer play];
    self.moviePlayer.view.frame = (CGRect){0,0,IP5(568, 480),320};
    [self.moviePlayer setFullscreen:YES];
    [self playMovie];
    [self hiddleMovieHolderView];
    [self updateVolumeSlider];
    self.moviePlayerHolderView.layer.cornerRadius = 10;
    
    //视频加载提示框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.moviePlayerControlBackDownView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"play_barBG.png"]]];
    UIImage *maximukmTrackImage = [[UIImage imageNamed:@"play_black.png"] scaleToSize:CGSizeMake(572, 8)];
    UIImage *minimukmTrackImage = [[UIImage imageNamed:@"play_bluetiao.png"] scaleToSize:CGSizeMake(572, 8)];
    UIImage *thumbImage = [[UIImage imageNamed:@"play_movieSlider.png"] scaleToSize:CGSizeMake(26, 7)];
    [self.seekSlider setMaximumTrackImage:maximukmTrackImage forState:UIControlStateNormal];
    [self.seekSlider setMinimumTrackImage:minimukmTrackImage forState:UIControlStateNormal];
    [self.seekSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    maximukmTrackImage = [[UIImage imageNamed:@"play-courselist_0d3.png"] scaleToSize:CGSizeMake(228, 6)];
    minimukmTrackImage = [[UIImage imageNamed:@"play-courselist_0df3.png"] scaleToSize:CGSizeMake(228,6)];
    thumbImage = [[UIImage imageNamed:@"play-courselist_03.png"] scaleToSize:CGSizeMake(10, 10)];
    [self.volumeSlider setMaximumTrackImage:maximukmTrackImage forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:minimukmTrackImage forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:thumbImage forState:UIControlStateNormal];
    
    [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_paused.png"] forState:UIControlStateNormal];
    self.section_ChapterView.alpha = 0.8;
    
    //测试数据
    self.sectionId = @"2928";
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
//        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            self.sectionInterface = [[SectionInfoInterface alloc] init];
            self.sectionInterface.delegate = self;
        [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andSectionId:@"2928"];
    }
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
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-15};
            if (!self.section_chapterController) {
                for(UIViewController *vc in self.childViewControllers){
                    if([vc isKindOfClass:[Section_ChapterViewController_iPhone class]]){
                        self.section_chapterController = (Section_ChapterViewController_iPhone *)vc;
                        break;
                    }
                }
            }
            Section *sectionDB = [[Section alloc] init];
            if (self.sectionModel) {
                self.section_chapterController.dataArray = [NSMutableArray arrayWithArray:[sectionDB getChapterInfoWithSid:self.sectionId]];
            } else if (self.sectionSaveModel) {
                self.section_chapterController.dataArray = [NSMutableArray arrayWithArray:[sectionDB getChapterInfoWithSid:self.sectionId]];
            }
            
            //测试数据,可删除
            self.section_chapterController.dataArray = [NSMutableArray arrayWithArray:self.sectionModel.sectionList];
            [self.section_chapterController.tableViewList reloadData];
            self.isPopupChapter = YES;
        }else {
            self.isPopupChapter = NO;
        }
    }else
        if (item == self.myQuestionItem) {
            DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLCommitQuestionViewController"];
            commitController.view.frame = (CGRect){0,0,IP5(516, 435),255};
            commitController.delegate = self;
            [self presentPopupViewController:commitController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
                self.myQuestionItem.isSelected = NO;
            }];
            self.isPopupChapter = NO;
        }else
            if (item == self.myNotesItem) {
                DRTakingMovieNoteViewController *takingController = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLTakingMovieNoteViewController"];
                takingController.view.frame = (CGRect){0,0,IP5(516, 435),255};
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
    }else{
        [self.moviePlayer pause];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)seekSliderTouchChangeValue:(id)sender {
    NSLog(@"seekSliderTouchChangeValue:%f",((UISlider*)sender).value);
    double playBack = self.moviePlayer.duration*((UISlider*)sender).value;
    DLog(@"%f,%f",self.moviePlayer.duration,((UISlider*)sender).value);
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

#pragma mark notification
-(void)playVideo:(NSNotification*)notification{
    [self saveCurrentStatus];
    NSString *sectionID = [notification.userInfo objectForKey:@"sectionID"];
    NSString *path = nil;
    NSString *documentDir;
    if (platform>5.0) {
        documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    path = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/Application/%@.mp4",sectionID]];
    Section *s = [[Section alloc] init];
    SectionSaveModel *ssm = [s getDataWithSid:sectionID];
    self.sectionSaveModel = ssm;
    NSURL *url = [NSURL fileURLWithPath:path];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
        [self playMovieWithURL:url withFileType:MPMovieSourceTypeFile withLessonName:[notification.userInfo objectForKey:@"sectionName"]];
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self startObservePlayBackProgressBar];
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    }
}

-(void)didChangeMoviePlayerURLNotification{//播放的视频url改变时触发
    DLog(@"didChangeMoviePlayerURLNotification:%@",self.moviePlayer.contentURL);
}

-(void)didChangeMoviePlayerLoadStateNotification{//加载状态改变时触发：
    DLog(@"didChangeMoviePlayerLoadStateNotification:%d",self.moviePlayer.loadState);
    if (self.moviePlayer.loadState == MPMovieLoadStatePlayable) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } else if (self.moviePlayer.loadState == MPMovieLoadStateStalled) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

#pragma mark --


#pragma mark -- 提交问题
-(void)commitQuestionController:(DRCommitQuestionViewController *)controller didCommitQuestionWithTitle:(NSString *)title andText:(NSString *)text andQuestionId:(NSString *)questionId{
    self.myQuestionItem.isSelected = NO;
    
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
    self.myQuestionItem.isSelected = NO;
}
#pragma mark --

#pragma mark -- 提交笔记
-(void)takingMovieNoteController:(DRTakingMovieNoteViewController *)controller commitNote:(NSString *)text andTime:(NSString *)noteTime{
    self.commitNoteText = text;
    self.commitNoteTime = noteTime;
    self.myNotesItem.isSelected = NO;
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        SumitNoteInterface *sumitNoteInter = [[SumitNoteInterface alloc]init];
        self.sumitNoteInterface = sumitNoteInter;
        self.sumitNoteInterface.delegate = self;
        [self.sumitNoteInterface getSumitNoteInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andNoteTime:noteTime andNoteText:text];
    }
}

-(void)takingMovieNoteControllerCancel{
    self.myNotesItem.isSelected = NO;
}
#pragma mark --

#pragma mark DRMoviePlayerTopBarDelegate
-(void)drMoviePlayerTopBarbackItemClicked:(DRMoviePlayerTopBar *)topBar{
    [self.section_chapterController willMoveToParentViewController:nil];
    [self.section_chapterController removeFromParentViewController];
    [self.section_chapterController.view removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:^{
        [self saveCurrentStatus];
        [self.moviePlayer stop];
        self.moviePlayer = nil;
    }];
    
}
#pragma mark --

#pragma mark DRMoviePlayerPlaybackProgressBarDelegate
-(void)playBackProgressBarTouchBegin:(DRMoviePlayerPlaybackProgressBar *)progressBar{
    [self.moviePlayer pause];
    [self endObservePlayBackProgressBar];
}

-(void)playBackProgressBarTouchEnd:(DRMoviePlayerPlaybackProgressBar *)progressBar{
    [self.moviePlayer play];
    [self startObservePlayBackProgressBar];
}

#pragma mark --
#pragma mark action

-(void)playMovie{
    //  ----删
    self.drMovieSourceType = MPMovieSourceTypeFile;
    //  ----删
    
    if (!self.movieUrl) {
        return;
    }
    
    if (self.drMovieSourceType == MPMovieSourceTypeFile) {
        [self.moviePlayer setContentURL:self.movieUrl];
        [self.moviePlayer play];
    }else
        if (self.drMovieSourceType == MPMovieSourceTypeStreaming) {
            [self.moviePlayer setContentURL:self.movieUrl];
            [self.moviePlayer prepareToPlay];
            [self.moviePlayer play];
        }
    self.isPlaying = YES;
}

-(void)saveCurrentStatus{
    //保存之前的状态
    if (self.drMovieSourceType == MPMovieSourceTypeFile) {
        [[Section defaultSection] updateStudyTime:[NSString stringWithFormat:@"%0.2f",self.moviePlayer.currentPlaybackTime] BySid:self.sectionSaveModel.sid];
    }else{
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            //判断是否播放完毕
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            PlayBackInterface *playBackInter = [[PlayBackInterface alloc]init];
            self.playBackInterface = playBackInter;
            self.playBackInterface.delegate = self;
            NSString *timespan = [Utility getNowDateFromatAnDate];
            NSString *status = self.seekSlider.value >= 1?@"completed": @"incomplete";
            [self.playBackInterface getPlayBackInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andTimeEnd:timespan andStatus:status];
        }
    }
}

-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType{
    //----本地url 待删除
    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = pathes[0];
    NSString *urlString = [path stringByAppendingPathComponent:@"/Application/123.mp4"];
    url = [NSURL fileURLWithPath:urlString];
    //----待删除
    self.movieUrl = url;
    self.drMovieSourceType = fileType;
    if (self.isViewLoaded) {
        [self playMovie];
    }
}

-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType withLessonName:(NSString*)lessonName{
    [self playMovieWithURL:url withFileType:fileType];
    self.drMovieTopBar.titleLabel.text = lessonName;
}

-(void)addMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerLoadStateNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerStateNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedMoviePlayerNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerURLNotification) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
}

-(void)removeMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
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
                self.section_ChapterView.frame = (CGRect){IP5(568, 480),0,247,274};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
            [self.section_chapterController removeFromParentViewController];
        }else{
            [self.section_chapterController willMoveToParentViewController:self];
            [UIView animateWithDuration:0.5 animations:^{
                self.section_ChapterView.frame = (CGRect){IP5(321, 233),0,247,274};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
//            [self addChildViewController:self.section_chapterController];
        }
    }
}

-(void)setIsHiddlePlayerControlView:(BOOL)isHiddlePlayerControlView{
    NSLog(@"%fplayer宽度:%f",self.moviePlayerView.frame.size.width,self.moviePlayer.view.frame.size.width);
    _isHiddlePlayerControlView = isHiddlePlayerControlView;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHiddlePlayerControlView) {
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = NO;
                self.chapterListItem.isSelected = YES;
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,320+22.5};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-15};
        }else{
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = YES;
            }else{
                self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,15};
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,320-22.5};
            
            NSLog(@"%@",NSStringFromCGRect(self.movieplayerControlBackView.frame));
        }
    }];
}

-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        [_moviePlayer setShouldAutoplay:YES];
        _moviePlayer.controlStyle = MPMovieControlStyleNone;
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [self.moviePlayerView addSubview:_moviePlayer.view];
        [self.moviePlayerView sendSubviewToBack:_moviePlayer.view];
        
        
    }
    return _moviePlayer;
}

#pragma mark --

- (BOOL)shouldAutorotate {
    UIInterfaceOrientation interface = [[UIApplication sharedApplication] statusBarOrientation];
    if (!UIInterfaceOrientationIsLandscape(interface)) {
        return YES;
    }
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeLeft;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationMaskLandscapeLeft);
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
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        });
    });
}
-(void)getPlayBackDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark -- SumitNoteInterfaceDelegate
-(void)getSumitNoteInfoDidFinished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //前一个view笔记里面加上刚提交的笔记
            if (self.delegate && [self.delegate respondsToSelector:@selector(lhlMoviePlayerViewController:commitNotesSuccess:andTime:)]) {
                [self.delegate lhlMoviePlayerViewController:self commitNotesSuccess:self.commitNoteText andTime:self.commitNoteTime];
            }
        });
    });
}
-(void)getSumitNoteDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark -- SectionInfoInterface  测试数据用,可删除
-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        SectionModel *section = (SectionModel *)result;
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.sectionModel = section;
        });
    });
}

-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


@end