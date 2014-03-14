//
//  LHLMoviePlayViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomPlayerView.h"
#import "MovieControllerItem.h"
#import "DRMoviePlayerPlaybackProgressBar.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MoviePlayerHolderView.h"
#import "PlayBackInterface.h"
#import "SumitNoteInterface.h"

#import "SectionModel.h"
#import "SectionSaveModel.h"

#import "DRMoviePlayerTopBar.h"
#import "AskQuestionInterface.h"

#import "Section_ChapterViewController_iPhone_Embed.h"

#import <MediaPlayer/MPMoviePlayerController.h>
#import <QuartzCore/QuartzCore.h>
#import "LHLTakingMovieNoteViewController.h"
#import "MBProgressHUD.h"
#import "LHLCommitQuestionViewController.h"
#import "Section.h"
#import "UIImage+Scale.h"

@protocol LHLMoviePlayViewControllerDelegate;
@interface LHLMoviePlayViewController : UIViewController<MovieControllerItemDelegate,DRMoviePlayerPlaybackProgressBarDelegate,CustomPlayerViewDelegate,PlayBackInterfaceDelegate,SumitNoteInterfaceDelegate,DRMoviePlayerTopBarDelegate,AskQuestionInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UILabel *timeTotalLabel;
@property (weak, nonatomic) IBOutlet UIView *volumeAndTrackProgressBackView;
@property (weak, nonatomic) IBOutlet UIView *volumeBackView;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet DRMoviePlayerTopBar *drMovieTopBar;
@property (weak, nonatomic) IBOutlet CustomPlayerView *moviePlayerView;
@property (weak, nonatomic) IBOutlet UIButton *playBt;
@property (weak, nonatomic) IBOutlet MoviePlayerHolderView *moviePlayerHolderView;
@property (weak, nonatomic) IBOutlet UISlider *seekSlider;
@property (weak, nonatomic) IBOutlet UIView *movieplayerControlBackView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *volumeBt;
@property (weak, nonatomic) IBOutlet MovieControllerItem *chapterListItem;
@property (weak, nonatomic) IBOutlet MovieControllerItem *myQuestionItem;
@property (weak, nonatomic) IBOutlet MovieControllerItem *myNotesItem;
@property (weak, nonatomic) IBOutlet UIView *moviePlayerControlBackDownView;
@property (weak, nonatomic) IBOutlet UIView *section_ChapterView;


@property (strong,nonatomic) NSURL *movieUrl;
@property (assign,nonatomic) MovieLocateType movieLacateType;
@property (nonatomic,weak) id<LHLMoviePlayViewControllerDelegate> delegate;
@property (nonatomic, strong) PlayBackInterface *playBackInterface;
@property (strong, nonatomic) NSString *sectionId;

@property (nonatomic, strong) SumitNoteInterface *sumitNoteInterface;
@property (nonatomic, strong) AskQuestionInterface *askQuestionInterface;
@property (nonatomic,strong) SectionInfoInterface *sectionInterface;  //测试数据
@property (nonatomic, strong) SectionModel *sectionModel;
@property (nonatomic, strong) SectionSaveModel *sectionSaveModel;

@property (strong, nonatomic) NSString *commitNoteText;
@property (strong, nonatomic) NSString *commitNoteTime;
@property (assign,nonatomic) MPMovieSourceType drMovieSourceType;



- (IBAction)playBtClicked:(id)sender;
- (IBAction)seekSliderTouchChangeValue:(id)sender;
- (IBAction)volumeSliderTouchChangeValue:(id)sender;
- (IBAction)volumeBtClicked:(id)sender;
//开始播放入口，设置播放文件
//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType;
//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType withLessonName:(NSString*)lessonName;
-(void)playMovieWithSectionModel:(SectionModel*)sectionModel withFileType:(MPMovieSourceType)fileType;
@end

@protocol LHLMoviePlayViewControllerDelegate <NSObject>

-(void)lhlMoviePlayerViewController:(LHLMoviePlayViewController*)playerController commitNotesSuccess:(NSString*)noteText andNoteSectionName:(NSString *)noteSectionName andTime:(NSString *)noteTime;
-(LessonModel*)lessonModelForDrMoviePlayerViewController;
@end
