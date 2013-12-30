//
//  DRMoviePlayViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-11-5.
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

#import "Section_ChapterViewController.h"

typedef enum {MOVIE_FILE,MOVIE_INTERNET}MovieLocateType;
@protocol DRMoviePlayViewControllerDelegate;
@interface DRMoviePlayViewController : UIViewController<MovieControllerItemDelegate,DRMoviePlayerPlaybackProgressBarDelegate,CustomPlayerViewDelegate,PlayBackInterfaceDelegate,SumitNoteInterfaceDelegate,DRMoviePlayerTopBarDelegate,AskQuestionInterfaceDelegate>

@property (weak, nonatomic) IBOutlet DRMoviePlayerTopBar *drMovieTopBar;
@property (nonatomic, strong) SumitNoteInterface *sumitNoteInterface;
@property (nonatomic, strong) AskQuestionInterface *askQuestionInterface;
@property (weak, nonatomic) IBOutlet CustomPlayerView *moviePlayerView;
@property (weak, nonatomic) IBOutlet UIButton *playBt;
@property (weak, nonatomic) IBOutlet MoviePlayerHolderView *moviePlayerHolderView;
@property (weak, nonatomic) IBOutlet UISlider *seekSlider;
//@property (weak, nonatomic) IBOutlet UIView *rightPopupView;
@property (weak, nonatomic) IBOutlet UIView *movieplayerControlBackView;
@property (weak, nonatomic) IBOutlet UISlider *volumeSlider;
@property (weak, nonatomic) IBOutlet UIButton *volumeBt;
@property (weak, nonatomic) IBOutlet MovieControllerItem *chapterListItem;
@property (weak, nonatomic) IBOutlet MovieControllerItem *myQuestionItem;
@property (weak, nonatomic) IBOutlet MovieControllerItem *myNotesItem;
@property (weak, nonatomic) IBOutlet UIView *moviePlayerControlBackDownView;
@property (strong,nonatomic) NSURL *movieUrl;
@property (nonatomic,weak) id<DRMoviePlayViewControllerDelegate> delegate;
@property (nonatomic, strong) PlayBackInterface *playBackInterface;
@property (strong, nonatomic) NSString *commitNoteText;
@property (strong, nonatomic) NSString *commitNoteTime;

- (IBAction)playBtClicked:(id)sender;
- (IBAction)seekSliderTouchChangeValue:(id)sender;
- (IBAction)volumeSliderTouchChangeValue:(id)sender;
- (IBAction)volumeBtClicked:(id)sender;
//开始播放入口，设置播放文件
//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType;
//-(void)playMovieWithURL:(NSURL*)url withFileType:(MPMovieSourceType)fileType withLessonName:(NSString*)lessonName;
-(void)playMovieWithSectionModel:(SectionModel*)sectionModel orLocalSectionModel:(SectionSaveModel*)saveSectionModel withFileType:(MPMovieSourceType)fileType;
@end

@protocol DRMoviePlayViewControllerDelegate <NSObject>

-(void)drMoviePlayerViewController:(DRMoviePlayViewController*)playerController commitNotesSuccess:(NSString*)noteText andTime:(NSString *)noteTime;
-(LessonModel*)lessonModelForDrMoviePlayerViewController;
@end
