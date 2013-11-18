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
#import "DRCommitQuestionViewController.h"
#import "DRTakingMovieNoteViewController.h"
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
     [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
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
    self.isPopupChapter = NO;
    [self addMoviePlayBackNotification];
//    self.movieUrlString =  @"http://www.jxvdy.com/file/upload/201309/18/18-10-03-19-3.mp4";
    self.movieUrlString = @"http://archive.org/download/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto/WaltDisneyCartoons-MickeyMouseMinnieMouseDonaldDuckGoofyAndPluto-HawaiianHoliday1937-Video.mp4";
    [self.moviePlayer play];
    self.isPlaying = YES;
    [self hiddleMovieHolderView];
    [self updateVolumeSlider];
    self.moviePlayerHolderView.layer.cornerRadius = 10;
    
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
            Section_ChapterViewController *chapter = [self.storyboard instantiateViewControllerWithIdentifier:@"Section_ChapterViewController"];
            chapter.view.frame = (CGRect){1024,0,1024-500,685};
            [UIView animateWithDuration:0.5 animations:^{
                chapter.view.frame = (CGRect){500,0,1024-500,685};
            } completion:^(BOOL finished) {
                
            }];
            self.section_chapterController = chapter;
            [self.view addSubview:chapter.view];
            self.isPopupChapter = YES;
        }else {
            self.isPopupChapter = NO;
        }

    }else
    if (item == self.myQuestionItem) {
        DRTakingMovieNoteViewController *takingController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRTakingMovieNoteViewController"];
        takingController.view.frame = (CGRect){0,0,804,426};
        [self presentPopupViewController:takingController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            
        }];
        self.isPopupChapter = NO;
    }else
    if (item == self.myNotesItem) {
        DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRCommitQuestionViewController"];
        commitController.view.frame = (CGRect){0,0,804,426};
        [self presentPopupViewController:commitController animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
            
        }];
        self.isPopupChapter = NO;
    }
}
#pragma mark --

- (IBAction)playBtClicked:(id)sender {
    self.isPlaying = !self.isPlaying;
    if (self.isPlaying) {
        [self.moviePlayer play];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_play.png"] forState:UIControlStateNormal];
    }else{
        [self.moviePlayer pause];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_paused.png"] forState:UIControlStateNormal];
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
}

-(void)didChangeMoviePlayerURLNotification{//播放的视频url改变时触发
    DLog(@"didChangeMoviePlayerURLNotification:%@",self.moviePlayer.contentURL);
}

-(void)didChangeMoviePlayerLoadStateNotification{//加载状态改变时触发：
    DLog(@"didChangeMoviePlayerLoadStateNotification:%d",self.moviePlayer.loadState);
}

#pragma mark --

#pragma mark DRMoviePlayerPlaybackProgressBarDelegate
-(void)playBackProgressBarTouchBegin:(DRMoviePlayerPlaybackProgressBar *)progressBar{
//    DLog(@"playBackProgressBarTouchBegin");
    [self endObservePlayBackProgressBar];
}

-(void)playBackProgressBarTouchEnd:(DRMoviePlayerPlaybackProgressBar *)progressBar{
//    DLog(@"playBackProgressBarTouchEnd");
    [self startObservePlayBackProgressBar];
}

#pragma mark --
#pragma mark action
-(void)addMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerLoadStateNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerStateNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishedMoviePlayerNotification:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didChangeMoviePlayerURLNotification) name:MPMoviePlayerNowPlayingMovieDidChangeNotification object:nil];
}

-(void)removeMoviePlayBackNotification{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)startObservePlayBackProgressBar{
    if (self.timer && [self.timer isValid]) {
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
    if (!isPopupChapter && self.section_chapterController) {
        [UIView animateWithDuration:0.5 animations:^{
            self.section_chapterController.view.frame = (CGRect){1024,0,1024-500,685};
        } completion:^(BOOL finished) {
            self.section_chapterController = nil;
        }];
    }
}

-(void)setIsHiddlePlayerControlView:(BOOL)isHiddlePlayerControlView{
    _isHiddlePlayerControlView = isHiddlePlayerControlView;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHiddlePlayerControlView) {
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,CGRectGetWidth(self.view.frame) + CGRectGetHeight(self.movieplayerControlBackView.bounds)/2};
        }else{
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,CGRectGetWidth(self.view.frame) -CGRectGetHeight(self.movieplayerControlBackView.bounds)/2};
            NSLog(@"%@",NSStringFromCGRect(self.movieplayerControlBackView.frame));
        }
    }];
}

-(MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        [_moviePlayer setShouldAutoplay:YES];
        [self.moviePlayerView addSubview:_moviePlayer.view];
        [self.moviePlayerView sendSubviewToBack:_moviePlayer.view];
        [_moviePlayer setMovieSourceType:MPMovieSourceTypeStreaming];
        _moviePlayer.view.frame = (CGRect){0,0,self.moviePlayerView.frame.size};
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFill];
        [_moviePlayer setContentURL:[NSURL URLWithString:self.movieUrlString]];
//        [self.view sendSubviewToBack:_moviePlayer.view];
        [_moviePlayer setFullscreen:YES];
        [_moviePlayer prepareToPlay];
    }
    return _moviePlayer;
}

#pragma mark --

- (BOOL)shouldAutorotate {
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationMaskLandscapeLeft);
}

#pragma mark TOUCH
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
    if (self.isPopupChapter) {
        self.isPopupChapter = NO;
    }
}
#pragma mark --

@end