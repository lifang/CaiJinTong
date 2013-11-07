//
//  DRMoviePlayerPlaybackProgressBar.h
//  CaiJinTongApp
//
//  Created by david on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DRMoviePlayerPlaybackProgressBarDelegate;
@interface DRMoviePlayerPlaybackProgressBar : UISlider
@property (weak,nonatomic) IBOutlet id<DRMoviePlayerPlaybackProgressBarDelegate> delegate;
@end

@protocol DRMoviePlayerPlaybackProgressBarDelegate <NSObject>

-(void)playBackProgressBarTouchBegin:(DRMoviePlayerPlaybackProgressBar*)progressBar;
-(void)playBackProgressBarTouchEnd:(DRMoviePlayerPlaybackProgressBar*)progressBar;
@end