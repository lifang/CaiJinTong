//
//  DRMoviePlayerTopBar.h
//  CaiJinTongApp
//
//  Created by david on 13-11-22.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DRMoviePlayerTopBarDelegate;
@interface DRMoviePlayerTopBar : UIView
@property (weak,nonatomic) IBOutlet UIButton *LeftBackBt;
@property (weak,nonatomic) IBOutlet UILabel *titleLabel;
@property (weak,nonatomic) IBOutlet  id<DRMoviePlayerTopBarDelegate> delegate;
-(IBAction)LeftBackBtClicked:(id)sender;
@end

@protocol DRMoviePlayerTopBarDelegate <NSObject>

-(void)drMoviePlayerTopBarbackItemClicked:(DRMoviePlayerTopBar*)topBar ;

@end