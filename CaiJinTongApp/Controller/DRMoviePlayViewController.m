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
#import "Section_ChapterViewController.h"
#import "DRTakingMovieNoteViewController.h"
#import "MBProgressHUD.h"
#import "DRCommitQuestionViewController.h"
#import "Section.h"
#define MOVIE_CURRENT_PLAY_TIME_OBSERVE @"movieCurrentPlayTimeObserve"
@interface DRMoviePlayViewController ()
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) Section_ChapterViewController *section_chapterController;
@property (nonatomic,assign) BOOL isHiddlePlayerControlView;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPopupChapter;
@property (nonatomic,assign) __block float currentMoviePlaterVolume;
@end

@implementation DRMoviePlayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myNotesItem.delegate = self;
    self.myQuestionItem.delegate = self;
    
    self.isPopupChapter = NO;
    [self addMoviePlayBackNotification];

//    [self.moviePlayer play];
    self.moviePlayer.view.frame = (CGRect){0,0,1024,768};
    [self.moviePlayer setFullscreen:YES];
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
    [self hiddleMovieHolderView];
    [self updateVolumeSlider];
    self.moviePlayerHolderView.layer.cornerRadius = 10;
    
    //视频加载提示框
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
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
                 [self.view addSubview:self.section_chapterController.view];
                [self addChildViewController:self.section_chapterController];
                
            }
            
            Section *sectionDB = [[Section alloc] init];
            if (self.sectionModel) {
                self.section_chapterController.dataArray =  [NSMutableArray arrayWithArray:[sectionDB getChapterInfoWithSid:self.sectionId]];
            } else if (self.sectionSaveModel) {
                self.section_chapterController.dataArray = [NSMutableArray arrayWithArray:[sectionDB getChapterInfoWithSid:self.sectionId]];
            }
            
            self.section_chapterController.view.frame = (CGRect){1024,0,1024-500,685};
            self.isPopupChapter = YES;
        }else {
            self.isPopupChapter = NO;
        }
    }else
    if (item == self.myQuestionItem) {
        DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRCommitQuestionViewController"];
        commitController.view.frame = (CGRect){0,0,804,426};
        [self presentPopupViewController:commitController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            self.myQuestionItem.isSelected = NO;
        }];
        self.isPopupChapter = NO;
    }else
    if (item == self.myNotesItem) {
        DRTakingMovieNoteViewController *takingController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRTakingMovieNoteViewController"];
        takingController.view.frame = (CGRect){0,0,804,426};
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
        
    }else{
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
    if (self.chapterListItem.isSelected) {
        self.isPopupChapter = !self.isPopupChapter;
    }
    
}

-(void)TouchVolumeUP{
    [self updateVolumeSlider];
}
-(void)TouchVolumeDOWN{
    [self updateVolumeSlider];
}
#pragma mark --

#pragma mark notification
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


#pragma mark DRCommitQuestionViewControllerDelegate
-(void)commitQuestionController:(DRCommitQuestionViewController *)controller didCommitQuestionWithTitle:(NSString *)title andText:(NSString *)text{
    self.myQuestionItem.isSelected = NO;
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
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
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
[self dismissViewControllerAnimated:YES completion:^{
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        //判断是否播放完毕
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
        PlayBackInterface *playBackInter = [[PlayBackInterface alloc]init];
        self.playBackInterface = playBackInter;
        self.playBackInterface.delegate = self;
        NSString *timespan = [Utility getNowDateFromatAnDate];
        NSString *status = self.seekSlider.value >= 1?@"completed": @"incomplete";
        [self.playBackInterface getPlayBackInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andTimeEnd:timespan andStatus:status];
    }
}];
    
}
#pragma mark --

#pragma mark DRMoviePlayerPlaybackProgressBarDelegate
-(void)playBackProgressBarTouchBegin:(DRMoviePlayerPlaybackProgressBar *)progressBar{
//    DLog(@"playBackProgressBarTouchBegin");
    [self.moviePlayer pause];
    [self endObservePlayBackProgressBar];
}

-(void)playBackProgressBarTouchEnd:(DRMoviePlayerPlaybackProgressBar *)progressBar{
//    DLog(@"playBackProgressBarTouchEnd");
    [self.moviePlayer play];
    [self startObservePlayBackProgressBar];
}

#pragma mark --
#pragma mark action

-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType{
    self.movieUrl = url;
    self.drMovieSourceType = fileType;
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
        if (!isPopupChapter) {
            
            [UIView animateWithDuration:0.5 animations:^{
                self.section_chapterController.view.frame = (CGRect){1024,0,1024-500,685};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
        }else{
            [UIView animateWithDuration:0.5 animations:^{
                self.section_chapterController.view.frame = (CGRect){450,0,1024-450,685};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
        }
    }
}

-(void)setIsHiddlePlayerControlView:(BOOL)isHiddlePlayerControlView{
    _isHiddlePlayerControlView = isHiddlePlayerControlView;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHiddlePlayerControlView) {
//            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,CGRectGetWidth(self.view.frame) + CGRectGetHeight(self.movieplayerControlBackView.bounds)/2};
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,768+50};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-20};
        }else{
//            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,CGRectGetWidth(self.view.frame) -CGRectGetHeight(self.movieplayerControlBackView.bounds)/2+2};
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
//        [_moviePlayer setContentURL:[NSURL URLWithString:self.movieUrlString]];
//        [self.view sendSubviewToBack:_moviePlayer.view];
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

-(void)getPlayBackInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] removeObserver:self];
        });
    });
}
-(void)getPlayBackDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
#pragma mark -- SumitNoteInterfaceDelegate
-(void)getSumitNoteInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //前一个view笔记里面加上刚提交的笔记
            if (self.delegate && [self.delegate respondsToSelector:@selector(drMoviePlayerViewController:commitNotesSuccess:andTime:)]) {
                [self.delegate drMoviePlayerViewController:self commitNotesSuccess:self.commitNoteText andTime:self.commitNoteTime];
            }
        });
    });
}
-(void)getSumitNoteDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
@end
