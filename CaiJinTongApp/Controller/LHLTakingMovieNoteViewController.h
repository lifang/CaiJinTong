//
//  LHLTakingMovieNoteViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@protocol LHLTakingMovieNoteViewControllerDelegate;
@interface LHLTakingMovieNoteViewController : BaseViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *noteTimeLabel;//记笔记时的播放时间
@property (weak, nonatomic) IBOutlet UITextView *contentField; //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak,nonatomic) id<LHLTakingMovieNoteViewControllerDelegate> delegate;

- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;

@end

@protocol LHLTakingMovieNoteViewControllerDelegate <NSObject>

-(void)takingMovieNoteController:(LHLTakingMovieNoteViewController*)controller commitNote:(NSString*)text andTime:(NSString *)noteTime;

-(void)takingMovieNoteControllerCancel;
@end