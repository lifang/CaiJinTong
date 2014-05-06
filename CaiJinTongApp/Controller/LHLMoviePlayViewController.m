//
//  LHLMoviePlayViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLMoviePlayViewController.h"
#import "UploadImageDataInterface.h"
#import "UIView+Rotate.h"
#define MOVIE_CURRENT_PLAY_TIME_OBSERVE @"movieCurrentPlayTimeObserve"
@interface LHLMoviePlayViewController ()<LHLTakingMovieNoteViewControllerDelegate,LHLCommitQuestionViewControllerDelegate>
@property (nonatomic,strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,strong) Section_ChapterViewController_iPhone_Embed *section_chapterController;
@property (nonatomic,assign) BOOL isHiddlePlayerControlView;
@property (nonatomic,assign) BOOL isPlaying;
@property (nonatomic,assign) BOOL isPopupChapter;
@property (nonatomic,assign) BOOL isBack;//是否退出播放
@property (nonatomic,assign) __block float currentMoviePlaterVolume;
@property (nonatomic,strong) LHLCommitQuestionViewController *commitQuestionVC;
@property (nonatomic,strong) LHLTakingMovieNoteViewController *takingMovieNotesVC;
@property (nonatomic, assign) long  long studyTime;//学习时间
@property (nonatomic, strong) NSString *startPlayDate;//学习时间
@property (nonatomic,strong) NSTimer *studyTimer;
@property (nonatomic,assign) BOOL chapterDismissByItself;
@property (nonatomic, strong)  UIButton *cutScreenButton;//截屏
@property (nonatomic,assign) BOOL isForgoundForPlayerView;//判断当前播放界面是否能和用户交互
@property (nonatomic,strong) MBProgressHUD *loadMovieDataProgressView;
@end

@implementation LHLMoviePlayViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    if (self.sectionModel) {
        self.drMovieTopBar.titleLabel.text = self.sectionModel.sectionName;
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
-(void)willDismissPopoupController{
    self.isForgoundForPlayerView = YES;
    self.myQuestionItem.isSelected = NO;
    self.myNotesItem.isSelected = NO;
    if (self.isPlaying) {
        if (self.commitQuestionVC) {
            if (!self.commitQuestionVC.isCut) {
                [self changePlayButtonStatus:YES];
                self.commitQuestionVC = nil;
            }
        }else{
            [self changePlayButtonStatus:YES];
        }
    }
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
    if (self.isPlaying && self.isForgoundForPlayerView) {
        [self.moviePlayer pause];
        [self pauseStudyTime];
    }
}

- (void)appDidEnterBackground:(UIApplication *)application
{
    if (self.isPlaying&& self.isForgoundForPlayerView) {
        [self.moviePlayer pause];
        [self pauseStudyTime];
    }
}

- (void)appWillEnterForeground:(UIApplication *)application
{
    if (self.isPlaying&& self.isForgoundForPlayerView) {
        [self.moviePlayer play];
        [self startStudyTime];
    }
}

- (void)appDidBecomeActive:(UIApplication *)application
{
    if (self.isPlaying&& self.isForgoundForPlayerView) {
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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(appDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
}
- (void)viewDidLoad{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(playVideo:) name:@"gotoMoviePlayMovie" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changePlayVideoOnLine:) name:@"changePlaySectionMovieOnLine" object:nil];
    [self addApplicationNotification];
    [super viewDidLoad];
    self.myNotesItem.delegate = self;
    self.myQuestionItem.delegate = self;
    
    self.isPopupChapter = NO;
    self.isForgoundForPlayerView = YES;
    self.chapterDismissByItself = NO;
//    [self addMoviePlayBackNotification];
    
    //    [self.moviePlayer play];
    self.moviePlayer.view.frame = (CGRect){0,0,IP5(568, 480),320};
    [self.moviePlayer setFullscreen:YES];
    [self playMovie];
    [self hiddleMovieHolderView];
    [self updateVolumeSlider];
    self.moviePlayerHolderView.layer.cornerRadius = 10;
    
    //视频加载提示框
//    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [self.moviePlayerControlBackDownView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"play_barBG.png"]]];
    [self.seekSlider setMaximumTrackImage:[UIImage imageNamed:@"play_black_iphone.png"] forState:UIControlStateNormal];
    [self.seekSlider setMinimumTrackImage:[UIImage imageNamed:@"play_bluetiao_iphone.png"] forState:UIControlStateNormal];
    [self.seekSlider setThumbImage:[UIImage imageNamed:@"play_movieSlider_iphone.png"] forState:UIControlStateNormal];
    
    [self.volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"_play_24.png"] forState:UIControlStateNormal];
    [self.volumeSlider setMinimumTrackImage:[UIImage imageNamed:@"_play_18.png"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"_play_27.png"] forState:UIControlStateNormal];
    
    [self.playBt setBackgroundImage:[UIImage imageNamed:@"play_paused.png"] forState:UIControlStateNormal];
    self.section_ChapterView.alpha = 0.9;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark MovieControllerItemDelegate
//TODO::选项菜单
-(void)moviePlayBarSelected:(MovieControllerItem *)item{
    if (item == self.chapterListItem) {
        [self changePlayButtonStatus:NO];
        self.chapterDismissByItself = YES;
        if (!self.isPopupChapter) {
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-15};
            if (!self.section_chapterController) {
                for(UIViewController *vc in self.childViewControllers){
                    if([vc isKindOfClass:[Section_ChapterViewController_iPhone_Embed class]]){
                        self.section_chapterController = (Section_ChapterViewController_iPhone_Embed *)vc;
                        self.section_chapterController.isMovieView = YES;
                        break;
                    }
                }
            }
            self.section_chapterController.lessonId = self.sectionModel.lessonId;
            LessonModel *lessonModel = [self.delegate lessonModelForDrMoviePlayerViewController];
//            LessonModel *lessonModel  = [CaiJinTongManager shared].lesson;
            if (lessonModel) {
                self.section_chapterController.dataArray = lessonModel.chapterList;
            }
            [self.section_chapterController.tableViewList reloadData];
//            }
            self.isPopupChapter = YES;
            self.isForgoundForPlayerView = NO;
        }else {
            self.isPopupChapter = NO;
            self.isForgoundForPlayerView = YES;
        }
    }else
        if (item == self.myQuestionItem) {
            self.chapterDismissByItself = NO;
            self.isPopupChapter = NO;
            self.isForgoundForPlayerView = NO;
            LHLCommitQuestionViewController *commitQuestionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLCommitQuestionViewController"];
            commitQuestionVC.view.frame = (CGRect){0,0,IP5(516, 435),280};
            commitQuestionVC.delegate = self;
            self.commitQuestionVC = commitQuestionVC;
            self.commitQuestionVC.modalPresentationStyle = UIModalPresentationFormSheet;
//            [self presentViewController:self.commitQuestionVC animated:YES completion:^{
//                self.myQuestionItem.isSelected = NO;
//            }];
//            self.commitQuestionVC.view.backgroundColor = [UIColor clearColor];
            [self presentPopupViewController:commitQuestionVC animationType:MJPopupViewAnimationFade isAlignmentCenter:YES dismissed:^{
                self.myQuestionItem.isSelected = NO;
            }];
        
            [self changePlayButtonStatus:NO];
        }else
            if (item == self.myNotesItem) {
                self.chapterDismissByItself = NO;
                self.isPopupChapter = NO;
                self.isForgoundForPlayerView = NO;
                LHLTakingMovieNoteViewController *takingMovieNotesVC = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLTakingMovieNoteViewController"];
                takingMovieNotesVC.view.frame = (CGRect){0,0,IP5(516, 435),120};
                takingMovieNotesVC.delegate = self;
                [self presentPopupViewController:takingMovieNotesVC animationType:MJPopupViewAnimationFade isAlignmentCenter:YES dismissed:^{
                    self.myNotesItem.isSelected = NO;
                }];
                [self changePlayButtonStatus:NO];
            }
}
#pragma mark --

- (IBAction)playBtClicked:(id)sender {
    self.isPlaying = !self.isPlaying;
    [self changePlayButtonStatus:self.isPlaying];
//    if (self.isPlaying) {
//        [self.moviePlayer play];
//        [self.playBt setBackgroundImage:[UIImage imageNamed:@"_play_01_03.png"] forState:UIControlStateNormal];
//        [self startStudyTime];
//    }else{
//        [self.moviePlayer pause];
//        [self.playBt setBackgroundImage:[UIImage imageNamed:@"_play_03.png"] forState:UIControlStateNormal];
//        [self pauseStudyTime];
//    }
}

- (IBAction)seekSliderTouchChangeValue:(id)sender {
    NSLog(@"seekSliderTouchChangeValue:%f",((UISlider*)sender).value);
    double playBack = self.moviePlayer.duration*((UISlider*)sender).value;
    DLog(@"%f,%f",self.moviePlayer.duration,((UISlider*)sender).value);
    self.moviePlayer.currentPlaybackTime = playBack;
    
    self.moviePlayer.currentPlaybackTime = playBack;
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:playBack]];
    self.timeTotalLabel.text = [NSString stringWithFormat:@"%@",[Utility formateDateStringWithSecond:self.moviePlayer.duration]];
    UIImageView *thubImageView = [self.seekSlider.subviews lastObject];
    float x = CGRectGetMinX([self.seekSlider convertRect:thubImageView.frame toView:self.volumeAndTrackProgressBackView])+4;
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
        [self.volumeBackView rotate90DegreeTopRect:CGRectOffset(rect, 0, 13) withFinished:^{
            
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

#pragma mark notification
-(void)playVideo:(NSNotification*)notification{
    [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    self.isBack = NO;
    [self saveCurrentStatus];

    SectionModel *ssm = [notification.userInfo objectForKey:@"sectionSaveModel"];
    self.drMovieSourceType = MPMovieSourceTypeFile;
    NSURL *url = [NSURL fileURLWithPath:ssm.sectionMovieLocalURL];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
        [self playMovieWithSectionModel:ssm withFileType:MPMovieSourceTypeFile];
    }else{
        [Utility errorAlert:@"当前文件正在播放"];
        [MBProgressHUD hideAllHUDsForView:self.moviePlayerView animated:YES];
    }
}

//切换视频
-(void)changePlayVideoOnLine:(NSNotification*)notification{
    self.isBack = NO;
    [self changePlayButtonStatus:YES];
    if (self.loadMovieDataProgressView) {
        [self.loadMovieDataProgressView removeFromSuperview];
        [self.loadMovieDataProgressView hide:NO];
        self.loadMovieDataProgressView = nil;
    }
    self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    
    [self saveCurrentStatus];
    SectionModel *section = [notification.userInfo objectForKey:@"sectionModel"];
    self.drMovieSourceType = MPMovieSourceTypeStreaming;
    NSURL *url = [NSURL URLWithString:section.sectionMoviePlayURL];
    if (![self.movieUrl.absoluteString  isEqualToString:url.absoluteString]) {
        //菜单消失
        if(self.isPopupChapter){
            self.isPopupChapter = NO;
        }
        [self changeMovieContentURLWithSectionModel:section withFileType:MPMovieSourceTypeStreaming];
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
    if ([[notification.userInfo  objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] integerValue] == MPMovieFinishReasonPlaybackEnded) {
        self.seekSlider.value = 1;
        if ( self.sectionModel.sectionLastPlayTime && [self.sectionModel.sectionLastPlayTime floatValue] >= self.moviePlayer.duration) {
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
            [self endObservePlayBackProgressBar];
            [self updateMoviePlayBackProgressBar];
            [self.moviePlayer stop];
        }else{
            [self.moviePlayer stop];
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
    }else if (self.moviePlayer.loadState == MPMovieLoadStatePlaythroughOK ) {
        [MBProgressHUD hideHUDForView:self.moviePlayerView animated:YES];
    }
    
}

#pragma mark -- 提交问题代理
-(void)commitQuestionControllerDidStartCutScreenButtonClicked:(LHLCommitQuestionViewController *)controller isCut:(BOOL)isCut{
//    [self.cutScreenButton setHidden:NO];
//    [self changePlayButtonStatus:NO];
//    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideBottomTop];
    [self cutMovieScreen];
}

-(void)commitQuestionController:(LHLCommitQuestionViewController *)controller didCommitQuestionWithTitle:(NSString *)title andText:(NSString *)text andQuestionId:(NSString *)questionId{
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
            
            __weak LHLMoviePlayViewController *weakSelf = self;
            [UploadImageDataInterface uploadImageWithUserId:user.userId withQuestionCategoryId:questionId withQuestionTitle:title withQuestionContent:text withUploadedData:UIImageJPEGRepresentation(controller.cutImage, 0) withSuccess:^(NSString *success) {
                LHLMoviePlayViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                    [Utility errorAlert:@"提交问题成功"];
                    tempSelf.commitQuestionVC.titleField.text = nil;  //清空提问VC的内容
                    tempSelf.commitQuestionVC.contentField.text = nil;
                    tempSelf.commitQuestionVC.selectedQuestionId = nil;
                    tempSelf.commitQuestionVC.categoryTextField.text = nil;
                }
                
            } withFailure:^(NSString *failureMsg) {
                LHLMoviePlayViewController *tempSelf = weakSelf;
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

#pragma mark -- 提交笔记
-(void)takingMovieNoteController:(LHLTakingMovieNoteViewController *)controller commitNote:(NSString *)text andTime:(NSString *)noteTime{
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
    [self.section_chapterController.view setHidden:YES];
    [self.moviePlayer stop];
    self.moviePlayer = nil;
    [self dismissViewControllerAnimated:YES completion:^{
       
    }];
}
-(void)drMoviePlayerTopBarbackItemClicked:(DRMoviePlayerTopBar *)topBar{
    self.isBack = YES;
    self.myQuestionItem.isSelected = NO;
    self.myNotesItem.isSelected = NO;
    [self changePlayButtonStatus:NO];
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
    [self startObservePlayBackProgressBar];
}

#pragma mark --
#pragma mark action

-(void)playMovie{
    if (!self.movieUrl) {
        return;
    }
//    [self notificateBackwillBeginPlayMovie];
    [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];
    if (self.moviePlayer.isPreparedToPlay) {
        [self.moviePlayer stop];
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
    
    if ([CaiJinTongManager shared].isShowLocalData) {
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
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
                //[MBProgressHUD showHUDAddedTo:self.view animated:YES];
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

-(void)playMovieWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType{
    if (!sectionModel) {
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utility errorAlert:@"没有发现要播放的文件"];
        return;
    }
    self.sectionModel = sectionModel;
//    [self removeMoviePlayBackNotification];
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

//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType{
//    //----本地url 待删除
//    NSArray *pathes = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = pathes[0];
//    NSString *urlString = [path stringByAppendingPathComponent:@"/Application/123.mp4"];
//    url = [NSURL fileURLWithPath:urlString];
//    //----待删除
//    self.movieUrl = url;
//    self.drMovieSourceType = fileType;
//    if (self.isViewLoaded) {
//        [self playMovie];
//    }
//}
//
//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType withLessonName:(NSString*)lessonName{
//    [self playMovieWithURL:url withFileType:fileType];
//    self.drMovieTopBar.titleLabel.text = lessonName;
//}

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
    
    [self performSelectorOnMainThread:@selector(updateStudyTimeValueMain) withObject:nil waitUntilDone:YES];
}

-(void)updateStudyTimeValueMain{
    self.studyTime +=1;
}
/**
 改变播放状态
 */
-(void)changePlayButtonStatus:(BOOL)isPlay{
    if (isPlay) {
        [self.moviePlayer play];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"_play_01_03.png"] forState:UIControlStateNormal];
        [self startStudyTime];
    }else{
        [self.moviePlayer pause];
        [self.playBt setBackgroundImage:[UIImage imageNamed:@"_play_03.png"] forState:UIControlStateNormal];
        [self pauseStudyTime];
    }
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
    float x = CGRectGetMinX([self.seekSlider convertRect:thubImageView.frame toView:self.volumeAndTrackProgressBackView])+4;
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

#pragma mark 播放路径改变
-(void)changeMovieContentURLWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType{
    if (!sectionModel) {
        [Utility errorAlert:@"没有发现要播放的文件"];
        return;
    }
    [self.moviePlayer stop];
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
            //            self.movieUrl = [NSURL fileURLWithPath:[CaiJinTongManager getMovieLocalPathWithSectionID:sectionModel.sectionId]];
            self.movieUrl = [NSURL fileURLWithPath:section.sectionMovieLocalURL];
        }else
            if (fileType == MPMovieSourceTypeStreaming) {
                self.movieUrl = [NSURL URLWithString:sectionModel.sectionMoviePlayURL];
            }
        
        if (self.loadMovieDataProgressView) {
            [self.loadMovieDataProgressView removeFromSuperview];
            [self.loadMovieDataProgressView hide:NO];
            self.loadMovieDataProgressView = nil;
        }
        self.loadMovieDataProgressView =  [MBProgressHUD showHUDAddedTo:self.moviePlayerView animated:YES];;
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
                self.section_ChapterView.frame = (CGRect){IP5(568, 480),0,247,274};
                self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,15};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
                if(self.chapterDismissByItself){
                    [self changePlayButtonStatus:YES];
                    self.chapterDismissByItself = NO;
                }
            }];
            [self.section_chapterController removeFromParentViewController];
        }else{
            [self.section_chapterController willMoveToParentViewController:self];
            [UIView animateWithDuration:0.5 animations:^{
                self.section_ChapterView.frame = (CGRect){IP5(321, 233),0,247,274};
            } completion:^(BOOL finished) {
                [self.movieplayerControlBackView setUserInteractionEnabled:YES];
            }];
            [self addChildViewController:self.section_chapterController];
        }
    }
}

//点击空白区域触发的方法
-(void)setIsHiddlePlayerControlView:(BOOL)isHiddlePlayerControlView{
    _isHiddlePlayerControlView = isHiddlePlayerControlView;
    [UIView animateWithDuration:0.5 animations:^{
        if (isHiddlePlayerControlView) {
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = NO;
                self.chapterListItem.isSelected = YES;
            }
            [self.volumeBackView setHidden:YES];
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,320+22.5};
            self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,-15};
        }else{
            if (self.chapterListItem.isSelected) {
                self.isPopupChapter = YES;
                [self changePlayButtonStatus:NO];
                self.chapterDismissByItself = YES;
            }else{
                self.drMovieTopBar.center = (CGPoint){self.movieplayerControlBackView.center.x,15};
            }
            self.movieplayerControlBackView.center = (CGPoint){self.movieplayerControlBackView.center.x,320-28};
            
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
        
        [_moviePlayer setScalingMode:MPMovieScalingModeAspectFit];
    }
    return _moviePlayer;
}

-(UIButton *)cutScreenButton{
    if(!_cutScreenButton){
        _cutScreenButton  = [[UIButton alloc] initWithFrame:(CGRect){IP5(244, 200),141,80,38}];
        [_cutScreenButton setTitle:@"点击截屏" forState:UIControlStateNormal];
        [_cutScreenButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        _cutScreenButton.backgroundColor = [UIColor clearColor];
        [_cutScreenButton addTarget:self action:@selector(cutMovieScreen) forControlEvents:UIControlEventTouchUpInside];
        [_cutScreenButton setHidden:YES];
        [self.view addSubview:_cutScreenButton];
    }
    return _cutScreenButton;
}

#pragma mark 剪切图
-(void)cutMovieScreen{
//    [self changePlayButtonStatus:NO];
    UIImage *cutImage = [self.moviePlayer thumbnailImageAtTime:self.moviePlayer.currentPlaybackTime timeOption:MPMovieTimeOptionNearestKeyFrame];
//    if (!self.commitQuestionVC) {
//        DRCommitQuestionViewController *commitController = [self.storyboard instantiateViewControllerWithIdentifier:@"DRCommitQuestionViewController"];
//        commitController.view.frame = (CGRect){0,0,804,426};
//        commitController.delegate = self;
//        self.commitQuestionController = commitController;
//    }
    self.commitQuestionVC.cutImage = cutImage;
//    self.commitQuestionVC.isCut = NO;
//    [self presentPopupViewController:self.commitQuestionVC animationType:MJPopupViewAnimationSlideTopBottom isAlignmentCenter:YES dismissed:^{
//        self.myQuestionItem.isSelected = NO;
//    }];
//    self.isPopupChapter = NO;
//    [self.cutScreenButton setHidden:YES];
    
}

#pragma mark --
- (BOOL)shouldAutorotate {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (orientation != UIInterfaceOrientationLandscapeLeft) {
        return YES;
    }
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeLeft;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark -- PlayBackInterfaceDelegate

-(void)getPlayBackInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (self.isBack) {
                [self exitPlayMovie];
            }
            [DRFMDBDatabaseTool updateSectionReCalculatePlayDateWithUserId:[CaiJinTongManager shared].user.userId withSectionId:self.sectionModel.sectionId withFinished:^(BOOL flag) {
                
            }];

        });
    });
}
-(void)getPlayBackDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if (self.isBack) {
        [self exitPlayMovie];
    }else if (![errorMsg isEqualToString:@""]) {
        [Utility errorAlert:errorMsg];
    }
}
#pragma mark -- SumitNoteInterfaceDelegate
-(void)getSumitNoteInfoDidFinished{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"笔记提交成功"];
            //前一个view笔记里面加上刚提交的笔记
            if (self.delegate && [self.delegate respondsToSelector:@selector(lhlMoviePlayerViewController:commitNotesSuccess:andNoteSectionName:andTime:)]) {
                [self.delegate lhlMoviePlayerViewController:self commitNotesSuccess:self.commitNoteText andNoteSectionName:self.sectionModel.sectionName andTime:self.commitNoteTime];
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
