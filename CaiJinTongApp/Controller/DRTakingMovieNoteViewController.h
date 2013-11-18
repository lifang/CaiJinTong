//
//  DRTakingMovieNoteViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRTakingMovieNoteViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *noteTimeLabel;//记笔记时的播放时间
@property (weak, nonatomic) IBOutlet UITextView *contentField; //主文本框
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;


- (IBAction)spaceAreaClicked:(id)sender;
- (IBAction)cancelBtnClicked:(UIButton *)sender;
- (IBAction)commitBtnClicked:(UIButton *)sender;

@end