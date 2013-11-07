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
typedef enum {MOVIE_FILE,MOVIE_INTERNET}MovieLocateType;
@interface DRMoviePlayViewController : UIViewController<MovieControllerItemDelegate,DRMoviePlayerPlaybackProgressBarDelegate,CustomPlayerViewDelegate>
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
@property (strong,nonatomic) NSString *movieUrlString;
@property (assign,nonatomic) MovieLocateType movieLacateType;
- (IBAction)playBtClicked:(id)sender;
- (IBAction)seekSliderTouchChangeValue:(id)sender;
- (IBAction)volumeSliderTouchChangeValue:(id)sender;
- (IBAction)volumeBtClicked:(id)sender;
@end
