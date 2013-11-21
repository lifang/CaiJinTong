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

//@interface DRMoviePlayViewController : UIViewController<MovieControllerItemDelegate,DRMoviePlayerPlaybackProgressBarDelegate,CustomPlayerViewDelegate,PlayBackInterfaceDelegate>

#import "DRCommitQuestionViewController.h"
#import "DRTakingMovieNoteViewController.h"
typedef enum {MOVIE_FILE,MOVIE_INTERNET}MovieLocateType;
@interface DRMoviePlayViewController : UIViewController<MovieControllerItemDelegate,DRMoviePlayerPlaybackProgressBarDelegate,CustomPlayerViewDelegate,DRCommitQuestionViewControllerDelegate,DRTakingMovieNoteViewControllerDelegate>
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
@property (strong,nonatomic) NSString *movieUrlString;
@property (assign,nonatomic) MovieLocateType movieLacateType;

@property (nonatomic, strong) PlayBackInterface *playBackInterface;
@property (strong, nonatomic) NSString *sectionId;
- (IBAction)playBtClicked:(id)sender;
- (IBAction)seekSliderTouchChangeValue:(id)sender;
- (IBAction)volumeSliderTouchChangeValue:(id)sender;
- (IBAction)volumeBtClicked:(id)sender;
@end
