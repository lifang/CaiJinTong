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
#import "UploadImageDataInterface.h"
#import "UIView+Rotate.h"
#define MOVIE_CURRENT_PLAY_TIME_OBSERVE @"movieCurrentPlayTimeObserve"
@interface DRMoviePlayViewController ()<DRTakingMovieNoteViewControllerDelegate,DRCommitQuestionViewControllerDelegate>
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) NSTimer *studyTimer;
@property (nonatomic,strong) Section_ChapterViewController *section_chapterController;
@property (nonatomic,assign) BOOL isHiddlePlayerControlView;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPopupChapter;
@property (nonatomic,assign) BOOL isForgoundForPlayerView;//判断当前播放界面是否能和用户交互
@property (nonatomic,assign) BOOL isBack;//是否退出播放
@property (nonatomic,assign) __block float currentMoviePlaterVolume;
@property (nonatomic, assign) __block long long studyTime;//学习时间
@property (nonatomic, strong) NSString *startPlayDate;//开始播放学习时间
@property (assign,nonatomic) MPMovieSourceType drMovieSourceType;//播放文件类型，本地还是在线视频
@property (nonatomic,strong) DRCommitQuestionViewController *commitQuestionController;
@property (nonatomic,strong) MBProgressHUD *loadMovieDataProgressView;
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
    self.isForgoundForPlayerView = YES;
    self.myQuestionItem.isSelected = NO;
    self.myNotesItem.isSelected = NO;
    if (self.isPlaying) {
        if (self.commitQuestionController) {
            if (!self.commitQuestionController.isCut) {
                [self changePlayButtonStatus:YES];
                self.commitQuestionController = nil;
            }
        }else{
            [self changePlayButtonStatus:YES];
        }
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

- (void)appDidEnterBackground:(UIApplication *)application
{
    if (self.isPlaying && self.isForgoundForPlayerView) {
        [self.moviePlayer pause];
        [self pauseStudyTime];
    }
}

- (void)appWillEnterForeground:(UIApplication *)application
{
    if (self.isPlaying && self.isForgoundForPlayerView) {
        [self.moviePlayer play];
        [self startStudyTime];
    }
}

- (void)appWillResignActive:(UIApplication *)application
{
    if (self.isPlaying && self.isForgoundForPlayerView) {
        [self.moviePlayer pause];
         [self pauseStudyTime];
    }
}

- (void)appDidBecomeActive:(UIApplication *)application
{
    if (self.isPlaying && self.isForgoundForPlayerView) {
        [self.moviePlayer play];
        [self startStudyTime];
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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
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
    
    [self.volumeBackView setHidden:YES];
    self.myNotesItem.delegate = self;
    self.myQuestionItem.delegate = self;
    
    self.isPopupChapter = NO;
    self.isForgoundForPlayerView = YES;
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
    self.seekSlider.value = 0;
    [self.volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"play-courselist_0d3.png"] forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"play-courselist_0df3.png"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"play-courselist_03.png"] forState:UIControlStateNormal];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,1024-50};
}

#pragma mark --
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MovieControllerItemDelegate选择笔记，章节和提问问题
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
//            LessonModel *lessonModel = [self.delegate lessonModelForDrMoviePlayerViewController];
            LessonModel *lessonModel = [CaiJinTongManager shared].lesson;
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
            self.isForgoundForPlayerView = NO;
            if (self.isPlaying) {
                [self changePlayButtonStatus:NO];
            }
        }else {
            self.isPopupChapter = NO;
            self.isForgoundForPlayerView = YES;
            if (self.isPlaying) {
                [self changePlayButtonStatus:YES];
            }
        }
    }else
    if (item == self.myQuestionItem) {
        self.isForgoundForPlayerView = NO;
        [self changePlayButtonStatus:NO];
        DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRCommitQuestionViewController"];
        commitController.view.frame = (CGRect){0,0,804,426};
        commitController.delegate = self;
        self.commitQuestionController = commitController;
        [self presentPopupViewController:commitController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            self.myQuestionItem.isSelected = NO;
        }];
        self.isPopupChapter = NO;
    }else
    if (item == self.myNotesItem) {
        self.isForgoundForPlayerView = NO;
        [self changePlayButtonStatus:NO];
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
    [self changePlayButtonStatus:self.isPlaying];
}

/**
  改变播放状态
 */
-(void)changePlayButtonStatus:(BOOL)isPlay{
    if (isPlay) {
        if (self.moviePlayer && self.moviePlayer.isPreparedToPlay) {
            [self.moviePlayer play];
            [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_paused.png"] forState:UIControlStateNormal];
            [self startStudyTime];
        }
    }else{
        if (self.moviePlayer && self.moviePlayer.playbackState== MPMoviePlaybackStatePlaying) {
            [self.moviePlayer pause];
            [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateNormal];
            [self pauseStudyTime];
        }
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
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:playBack]];
    self.timeTotalLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:self.moviePlayer.duration]];
    UIImageView *thubImageView = [self.seekSlider.subviews lastObject];
    float x = CGRectGetMinX([self.seekSlider convertRect:thubImageView.frame toView:self.volumeAndTrackProgressBackView])+10;
    CGSize totoalSize = [self.timeTotalLabel.text sizeWithFont:self.timeTotalLabel.font];
    CGSize size = [self.timeLabel.text sizeWithFont:self.timeLabel.font];
    float left = CGRectGetMaxX(self.timeTotalLabel.frame) - totoalSize.width;
    float right = CGRectGetMinX(self.seekSlider.frame)+x +size.width;
    if (right > left) {
        x =CGRectGetMaxX(self.timeTotalLabel.frame) - totoalSize.width - size.width;
    }else{
        x = CGRectGetMinX(self.seekSlider.frame)+x - size.width/2;
    }
    self.timeLabel.frame = (CGRect){x,self.timeLabel.frame.origin.y,self.timeLabel.frame.size};

}

- (IBAction)volumeSliderTouchChangeValue:(id)sender {
    MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
    mpc.volume = [(UISlider*)sender value];
}

- (IBAction)volumeBtClicked:(id)sender {
    if (self.volumeBackView.isHidden) {
        [self.volumeBackView setHidden:NO];
        self.volumeBackView.alpha = 0;
        CGRect rect =[self.volumeAndTrackProgressBackView convertRect:((UIButton*)sender).frame toView:self.view];
        [self.volumeBackView rotate90DegreeTopRect:CGRectOffset(rect, 0, 20) withFinished:^{
            
        }];
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.volumeBackView.alpha = 0;
        } completion:^(BOOL finished) {
            [self.volumeBackView setHidden:YES];
        }];
    }

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

#pragma mark notification//切换视频通知
-(void)changePlayVideoOnLine:(NSNotification*)notification{
    self.isBack = NO;
    self.isPopupChapter = NO;
     [self changePlayButtonStatus:YES];
    if (self.moviePlayerView) {
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:NO];
            self.loadMovieDataProgressView = nil;
        }
        self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
    }
    [self saveCurrentStatus];
    SectionModel *section = [notification.userInfo objectForKey:@"sectionModel"];
    self.drMovieSourceType = MPMovieSourceTypeStreaming;
    NSURL *url = [NSURL URLWithString:section.sectionMoviePlayURL];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
//        [self playMovieWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
        [self changeMovieContentURLWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
    }else{
        [Utility errorAlert:@"当前文件正在播放"];
        [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
    }
}

-(void)playVideo:(NSNotification*)notification{
     self.isPopupChapter = NO;
    [self changePlayButtonStatus:YES];
    if (self.moviePlayerView) {
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:NO];
            self.loadMovieDataProgressView = nil;
        }
        self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
    }
    self.isBack = NO;
    [self saveCurrentStatus];
    SectionModel *ssm = [notification.userInfo objectForKey:@"sectionSaveModel"];
    self.drMovieSourceType = MPMovieSourceTypeFile;
    [DRFMDBDatabaseTool selectSectionListWithUserId:[CaiJinTongManager shared].user.userId withSectionId:ssm.sectionId withLessonId:nil withFinished:^(SectionModel *section) {
        ssm.sectionMovieLocalURL = section.sectionMovieLocalURL;
        NSURL *url = [NSURL fileURLWithPath:[CaiJinTongManager getMovieLocalPathWithSectionID:ssm.sectionId]];
        if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
            [self changeMovieContentURLWithSectionModel:ssm withFileType:MPMovieSourceTypeFile];
        }else{
            [Utility errorAlert:@"当前文件正在播放"];
            [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
        }
    }];
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
            [self startObservePlayBackProgressBar];
            break;
        }
            
        case MPMoviePlaybackStatePaused:
        {
            break;
        }
            
        case MPMoviePlaybackStateInterrupted:
        {

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
    if ([[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue] == MPMovieFinishReasonPlaybackEnded) {
        self.seekSlider.value = 1;
        if ( self.sectionModel.sectionLastPlayTime && [self.sectionModel.sectionLastPlayTime floatValue] >= self.moviePlayer.duration && self.moviePlayer.duration > 0) {
            self.sectionModel.sectionLastPlayTime = @"0";
            self.moviePlayer.currentPlaybackTime = 0;
            [self.moviePlayer play];
            self.isPlaying = YES;
            [self startStudyTime];
        }
    }else
    if ([[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue] == MPMovieFinishReasonPlaybackError) {
        self.seekSlider.value = 0;
        [self removeMoviePlayBackNotification];
        
        NSError *error = [notification.userInfo objectForKey:@"error"];
        if (![Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
            [Utility errorAlert:tipMsg];
        }]) {
           
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self endObservePlayBackProgressBar];
            [self updateMoviePlayBackProgressBar];
            [self endStudyTime];
            if (self.loadMovieDataProgressView) {
                [self.loadMovieDataProgressView removeFromSuperview];
                [self.loadMovieDataProgressView hide:NO];
                self.loadMovieDataProgressView = nil;
            }
        });
        
    }
}

-(void)didChangeMoviePlayerURLNotification{//播放的视频url改变时触发
    DLog(@"didChangeMoviePlayerURLNotification:%@",self.moviePlayer.contentURL);

    if (self.moviePlayerView) {
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:NO];
            self.loadMovieDataProgressView = nil;
        }
        self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
    }
    
}

-(void)didChangeMoviePlayerLoadStateNotification{//加载状态改变时触发：
    DLog(@"didChangeMoviePlayerLoadStateNotification:%d",self.moviePlayer.loadState);
    MPMovieLoadState state = self.moviePlayer.loadState;
    if ((state & MPMovieLoadStatePlaythroughOK) || (state & MPMovieLoadStatePlayable)) {
        for (UIView *subView in self.moviePlayerView.subviews) {
            if ([subView isKindOfClass:[MBProgressHUD class]]) {
                [subView removeFromSuperview];
            }
        }
    }else{
        if (self.moviePlayerView) {
            if (self.loadMovieDataProgressView) {
                [self.loadMovieDataProgressView removeFromSuperview];
                [self.loadMovieDataProgressView hide:NO];
                self.loadMovieDataProgressView = nil;
            }
            self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
        }
    }
}

#pragma mark --


#pragma mark -- 提交问题
-(UIImage *)commitQuestionControllerDidStartCutScreenButtonClicked:(DRCommitQuestionViewController *)controller{
 UIImage *cutImage = [self.moviePlayer thumbnailImageAtTime:self.moviePlayer.currentPlaybackTime timeOption:MPMovieTimeOptionNearestKeyFrame];
    return cutImage;
}

-(void)commitQuestionController:(DRCommitQuestionViewController *)controller didCommitQuestionWithTitle:(NSString *)title andText:(NSString *)text andQuestionId:(NSString *)questionId{
    self.myQuestionItem.isSelected = NO;
    if (self.isPlaying) {
        [self changePlayButtonStatus:YES];
    }

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            UserModel *user = [[CaiJinTongManager shared] user];
            __weak DRMoviePlayViewController *weakSelf = self;
            [UploadImageDataInterface uploadImageWithUserId:user.userId withQuestionCategoryId:questionId withQuestionTitle:title withQuestionContent:text withUploadedData:UIImageJPEGRepresentation(controller.cutImage, 0) withSuccess:^(NSString *success) {
                DRMoviePlayViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                    [Utility errorAlert:@"提交问题成功"];
                }
                
            } withFailure:^(NSString *failureMsg) {
                DRMoviePlayViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                    [Utility errorAlert:@"提交问题失败"];
                }
            }];
        }
    }];
}

-(void)commitQuestionControllerCancel{
    self.myQuestionItem.isSelected = NO;
    if (self.isPlaying) {
        [self changePlayButtonStatus:YES];
    }
}

#pragma mark --

#pragma mark -- 提交笔记
-(void)takingMovieNoteController:(DRTakingMovieNoteViewController *)controller commitNote:(NSString *)text andTime:(NSString *)noteTime{
    self.commitNoteText = text;
    self.commitNoteTime = noteTime;
    self.myNotesItem.isSelected = NO;
    if (self.isPlaying) {
        [self changePlayButtonStatus:YES];
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            SumitNoteInterface *sumitNoteInter = [[SumitNoteInterface alloc]init];
            self.sumitNoteInterface = sumitNoteInter;
            self.sumitNoteInterface.delegate = self;
            [self.sumitNoteInterface
             getSumitNoteInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId
             andSectionId:self.sectionModel.sectionId
             andNoteTime:noteTime
             andNoteText:text];
        }
    }];
}

-(void)takingMovieNoteControllerCancel{
    self.myNotesItem.isSelected = NO;
    if (self.isPlaying) {
        
        [self changePlayButtonStatus:YES];
    }
}
#pragma mark --

#pragma mark DRMoviePlayerTopBarDelegate播放完成退出界面

-(void)exitPlayMovie{
    [self.section_chapterController willMoveToParentViewController:nil];
    [self.section_chapterController removeFromParentViewController];
    [self.section_chapterController.view removeFromSuperview];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)drMoviePlayerTopBarbackItemClicked:(DRMoviePlayerTopBar *)topBar{
    self.isBack = YES;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
     [self saveCurrentStatus];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
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
    if (self.moviePlayerView) {
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:NO];
            self.loadMovieDataProgressView = nil;
        }
        self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
    }
    if (self.moviePlayer.isPreparedToPlay) {
        [self.moviePlayer stop];
        self.moviePlayer = nil;
    }
//    self.moviePlayer.initialPlaybackTime = [self.sectionModel.sectionLastPlayTime floatValue];
    self.moviePlayer.initialPlaybackTime = [Utility getStartPlayerTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId];
    self.moviePlayer.movieSourceType = self.drMovieSourceType;
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
    self.startPlayDate = [Utility getNowDateFromatAnDate];
    self.studyTime = 0;
    [self startStudyTime];
}

-(void)saveCurrentStatus{
    [self  endStudyTime];
    __block NSString *timespan = [NSString stringWithFormat:@"%.2f",self.moviePlayer.currentPlaybackTime];
    self.sectionModel.sectionFinishedDate = [Utility getNowDateFromatAnDate];
    self.sectionModel.sectionLastPlayTime = timespan;
    [Utility setStartPlayerTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withPlayerTime:self.moviePlayer.currentPlaybackTime withLastPlayDate:self.sectionModel.sectionFinishedDate];
    [DRFMDBDatabaseTool updateSectionPlayDateWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withPlayTime:self.sectionModel.sectionLastPlayTime withLastFinishedDate:self.sectionModel.sectionFinishedDate withFinished:^(BOOL flag) {
        
    }];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (![CaiJinTongManager shared].isShowLocalData) {
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                if (self.isBack) {
                    [self exitPlayMovie];
                }
                [DRFMDBDatabaseTool updateSectionOfflinePlayTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withPlayTimeOffLine:[NSString stringWithFormat:@"%llu",self.studyTime] withFinished:^(BOOL flag) {
                    
                }];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if (self.loadMovieDataProgressView) {
                    [self.loadMovieDataProgressView removeFromSuperview];
                    [self.loadMovieDataProgressView hide:YES];
                    self.loadMovieDataProgressView = nil;
                }
            }else {
                //判断是否播放完毕
                PlayBackInterface *playBackInter = [[PlayBackInterface alloc]init];
                self.playBackInterface = playBackInter;
                self.playBackInterface.delegate = self;
                [DRFMDBDatabaseTool selectSectionOfflinePlayTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withFinished:^(NSString *offlinePlayTime) {
                    if (offlinePlayTime && ![offlinePlayTime isEqualToString:@"0"]) {
                        //            timespan = [[Section defaultSection] selectTotalPlayDateOffLineWithSectionId:self.sectionModel.sectionId];
                        timespan = [NSString stringWithFormat:@"%llu",offlinePlayTime.intValue+self.studyTime];
                    }else{
                        //            timespan = [Utility getNowDateFromatAnDate];
                        timespan = [NSString stringWithFormat:@"%llu",self.studyTime];
                    }
                    NSString *status = self.seekSlider.value >= 1?@"completed": @"incomplete";
                    [self.playBackInterface getPlayBackInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionModel.sectionId andTimeEnd:timespan andStatus:status andStartPlayDate:self.startPlayDate];
                }];
            }
        }];
    }else{
        if (self.isBack) {
            [self exitPlayMovie];
        }
        [DRFMDBDatabaseTool updateSectionOfflinePlayTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withPlayTimeOffLine:[NSString stringWithFormat:@"%llu",self.studyTime] withFinished:^(BOOL flag) {
            
        }];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:YES];
            self.loadMovieDataProgressView = nil;
        }
    }
}

//告诉后台将要开始播放
-(void)notificateBackwillBeginPlayMovie{
    __weak SectionModel *weakSection = self.sectionModel;
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
    UserModel *user = [[CaiJinTongManager shared] user];
    SectionModel *tempSection = weakSection;
    if (tempSection) {
        [[PlayVideoInterface defaultPlayVideoInterface] getPlayVideoInterfaceDelegateWithUserId:user.userId andSectionId:tempSection.sectionId andTimeStart:[Utility getNowDateFromatAnDate]];
    }
    
});
}

#pragma mark 播放路径改变
-(void)changeMovieContentURLWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType{
    if (!sectionModel) {
        [Utility errorAlert:@"没有发现要播放的文件"];
        return;
    }
    [self.moviePlayer stop];
//    self.moviePlayer = nil;
    self.sectionModel = sectionModel;
    [self removeMoviePlayBackNotification];
    [self addMoviePlayBackNotification];
    self.drMovieSourceType = fileType;
    self.drMovieTopBar.titleLabel.text = sectionModel.sectionName;
    //////////////
    [DRFMDBDatabaseTool selectSectionListWithUserId:[CaiJinTongManager shared].user.userId withSectionId:sectionModel.sectionId withLessonId:sectionModel.lessonId withFinished:^(SectionModel *section) {
        if (section && section.sectionLastPlayTime) {
            self.sectionModel.sectionLastPlayTime = section.sectionLastPlayTime;
        }
        self.sectionModel.sectionMovieLocalURL = section.sectionMovieLocalURL;
        self.sectionModel.sectionMovieFileDownloadStatus = section.sectionMovieFileDownloadStatus;
        self.sectionModel.sectionFinishedDate = section.sectionFinishedDate;
        if (fileType == MPMovieSourceTypeFile) {
        self.movieUrl = [NSURL fileURLWithPath:[CaiJinTongManager getMovieLocalPathWithSectionID:sectionModel.sectionId]];
//            self.movieUrl = [NSURL fileURLWithPath:section.sectionMovieLocalURL];
        }else
            if (fileType == MPMovieSourceTypeStreaming) {
                self.movieUrl = [NSURL URLWithString:sectionModel.sectionMoviePlayURL];
            }
        
        if (self.moviePlayerView) {
            if (self.loadMovieDataProgressView) {
                [self.loadMovieDataProgressView removeFromSuperview];
                [self.loadMovieDataProgressView hide:NO];
                self.loadMovieDataProgressView = nil;
            }
            self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
        }
        self.moviePlayer.movieSourceType = self.drMovieSourceType;
        [self.moviePlayer setContentURL:self.movieUrl];
//        self.moviePlayer.initialPlaybackTime = [self.sectionModel.sectionLastPlayTime floatValue];
        self.moviePlayer.initialPlaybackTime = [Utility getStartPlayerTimeWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId];
        if (self.moviePlayer.playbackState != MPMoviePlaybackStatePlaying) {
            [self.moviePlayer play];
        }
        self.isPlaying = YES;
        self.startPlayDate = [Utility getNowDateFromatAnDate];
        [self startStudyTime];
    }];
    //////////////
    
    
}

#pragma mark --

#pragma mark 开始播放
-(void)playMovieWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType{
    if (!sectionModel) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utility errorAlert:@"没有发现要播放的文件"];
        return;
    }
    self.sectionModel = sectionModel;
    [self removeMoviePlayBackNotification];
    [self addMoviePlayBackNotification];
    self.drMovieSourceType = fileType;
    self.drMovieTopBar.titleLabel.text = sectionModel.sectionName;
    [DRFMDBDatabaseTool selectSectionListWithUserId:[CaiJinTongManager shared].user.userId withSectionId:sectionModel.sectionId withLessonId:sectionModel.lessonId withFinished:^(SectionModel *section) {
        if (section && section.sectionLastPlayTime) {
            self.sectionModel.sectionLastPlayTime = section.sectionLastPlayTime;
        }
        self.sectionModel.sectionMovieLocalURL = section.sectionMovieLocalURL;
        self.sectionModel.sectionMovieFileDownloadStatus = section.sectionMovieFileDownloadStatus;
        self.sectionModel.sectionFinishedDate = section.sectionFinishedDate;
        if (fileType == MPMovieSourceTypeFile) {
            self.movieUrl = [NSURL fileURLWithPath:[CaiJinTongManager getMovieLocalPathWithSectionID:sectionModel.sectionId]];
//            self.movieUrl = [NSURL fileURLWithPath:section.sectionMovieLocalURL];
        }else
            if (fileType == MPMovieSourceTypeStreaming) {
                self.movieUrl = [NSURL URLWithString:sectionModel.sectionMoviePlayURL];
            }
        if (self.isViewLoaded) {
            [self playMovie];
        }
    }];
    
}
#pragma mark --


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
    
    [self performSelectorOnMainThread:@selector(updateStudyTimeValueMain) withObject:nil waitUntilDone:NO];
}

-(void)updateStudyTimeValueMain{
    self.studyTime +=1;
}

//开始学习记时
-(void)startStudyTime{
    if (self.studyTimer && self.studyTimer.isValid) {
        return;
    }
    self.studyTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(updateStudyTimeValue) userInfo:nil repeats:YES];
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
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:self.moviePlayer.currentPlaybackTime]];
    self.timeTotalLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:self.moviePlayer.duration]];
    
    UIImageView *thubImageView = [self.seekSlider.subviews lastObject];
    float x = CGRectGetMinX([self.seekSlider convertRect:thubImageView.frame toView:self.volumeAndTrackProgressBackView])+10;
    CGSize totoalSize = [self.timeTotalLabel.text sizeWithFont:self.timeTotalLabel.font];
    CGSize size = [self.timeLabel.text sizeWithFont:self.timeLabel.font];
    float left = CGRectGetMaxX(self.timeTotalLabel.frame) - totoalSize.width;
    float right = CGRectGetMinX(self.seekSlider.frame)+x +size.width;
    if (right > left) {
        x =CGRectGetMaxX(self.timeTotalLabel.frame) - totoalSize.width - size.width;
    }else{
        x = CGRectGetMinX(self.seekSlider.frame)+x - size.width/2;
    }
    self.timeLabel.frame = (CGRect){x,self.timeLabel.frame.origin.y,self.timeLabel.frame.size};
    
}
-(void)endObservePlayBackProgressBar{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }

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

-(void)setMovieUrl:(NSURL *)movieUrl{
    if (movieUrl && [[NSString stringWithFormat:@"flv"] isEqualToString:[[movieUrl absoluteString] pathExtension]] ) {
        NSString *path = movieUrl.absoluteString;
        _movieUrl = [NSURL URLWithString:[path stringByReplacingCharactersInRange:NSMakeRange(path.length - 3, 3) withString:@"mp4"]];
    }else{
        _movieUrl = movieUrl;
    }
}

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
            [self.volumeBackView setHidden:YES];
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,768+40};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-20};
        }else{
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = YES;
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,768-37};
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
        for (UIView *subView in self.moviePlayerView.subviews) {
            [subView removeFromSuperview];
        }
        [self.moviePlayerView addSubview:_moviePlayer.view];
        [self.moviePlayerView sendSubviewToBack:_moviePlayer.view];
        
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
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
           if (self.loadMovieDataProgressView) {
                [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:YES];
                self.loadMovieDataProgressView = nil;
            }
            if (self.isBack) {
                [self exitPlayMovie];
            }
            [DRFMDBDatabaseTool updateSectionReCalculatePlayDateWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withFinished:^(BOOL flag) {
                
            }];
        });
    });
}
-(void)getPlayBackDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
       if (self.loadMovieDataProgressView) {
                [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:YES];
                self.loadMovieDataProgressView = nil;
            }
        if (self.isBack) {
            [self exitPlayMovie];
        }else
            if (![errorMsg isEqualToString:@""]) {
                [Utility errorAlert:errorMsg];
            }else{
                [Utility errorAlert:@"获取视频回放信息失败!"];
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
        if (![errorMsg isEqualToString:@""]) {
            [Utility errorAlert:errorMsg];
        }else{
            [Utility errorAlert:@"笔记提交失败!"];
        }
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
        if (![errorMsg isEqualToString:@""]) {
            [Utility errorAlert:errorMsg];
        }else{
            [Utility errorAlert:@"提问提交失败!"];
        }
    });
}
@end
