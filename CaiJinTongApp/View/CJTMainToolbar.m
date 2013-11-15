//
//  CJTMainToolbar.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CJTMainToolbar.h"

#define LABEL_X 53
#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define LABEL_WIDTH 56.0f
#define RECENT_BUTTON_WIDTH 136.0f
#define PROGRESS_BUTTON_WIDTH 80.0f
#define NAME_BUTTON_WIDTH 100.0f

#define RECENT_TAG 12345
#define PROGRESS_TAG 12346
#define NAME_TAG 12347
@implementation CJTMainToolbar


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
		CGFloat leftButtonX = BUTTON_X;

        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(LABEL_X, BUTTON_Y, LABEL_WIDTH, BUTTON_HEIGHT)];
        titleLab.text = @"筛选:";
        titleLab.font = [UIFont systemFontOfSize:20];
        titleLab.textColor = [UIColor grayColor];
        titleLab.backgroundColor = [UIColor clearColor];
        [self addSubview:titleLab];
        
        leftButtonX = LABEL_X+LABEL_WIDTH+BUTTON_SPACE;
        //默认(最近播放)
        UIButton *recentPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recentPlayBtn.frame = CGRectMake(leftButtonX, BUTTON_Y, RECENT_BUTTON_WIDTH, BUTTON_HEIGHT);
        [recentPlayBtn setTitle:NSLocalizedString(@"默认(最近播放)", @"button") forState:UIControlStateNormal];
        recentPlayBtn.tag = RECENT_TAG;
		[recentPlayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recentPlayBtn addTarget:self action:@selector(recentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//		[recentPlayBtn setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//		[recentPlayBtn setBackgroundImage:buttonN forState:UIControlStateNormal];
		recentPlayBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
		recentPlayBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:recentPlayBtn];
        
        leftButtonX = leftButtonX +BUTTON_SPACE+RECENT_BUTTON_WIDTH;
        //学习进度
        UIButton *progressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        progressBtn.frame = CGRectMake(leftButtonX, BUTTON_Y, PROGRESS_BUTTON_WIDTH, BUTTON_HEIGHT);
        [progressBtn setTitle:NSLocalizedString(@"学习进度", @"button") forState:UIControlStateNormal];
        progressBtn.tag = PROGRESS_TAG;
		[progressBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [progressBtn addTarget:self action:@selector(progressButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//		[progressBtn setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//		[progressBtn setBackgroundImage:buttonN forState:UIControlStateNormal];
		progressBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
		progressBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:progressBtn];
        
        leftButtonX = leftButtonX +BUTTON_SPACE + PROGRESS_BUTTON_WIDTH;
        //名称(A-Z)
        UIButton *nameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        nameBtn.frame = CGRectMake(leftButtonX, BUTTON_Y, NAME_BUTTON_WIDTH, BUTTON_HEIGHT);
        [nameBtn setTitle:NSLocalizedString(@"名称(A-Z)", @"button") forState:UIControlStateNormal];
        nameBtn.tag = NAME_TAG;
		[nameBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [nameBtn addTarget:self action:@selector(nameButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
//		[nameBtn setBackgroundImage:buttonH forState:UIControlStateHighlighted];
//		[nameBtn setBackgroundImage:buttonN forState:UIControlStateNormal];
		nameBtn.titleLabel.font = [UIFont systemFontOfSize:20.0f];
		nameBtn.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:nameBtn];
    }
    return self;
}
- (void)hideToolbar
{
	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.alpha = 0.0f;
         }
                         completion:^(BOOL finished)
         {
             self.hidden = YES;
         }
         ];
	}
}

- (void)showToolbar
{
	if (self.hidden == YES)
	{
		//....
        
		[UIView animateWithDuration:0.25 delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^(void)
         {
             self.hidden = NO;
             self.alpha = 1.0f;
         }
                         completion:NULL
         ];
	}
}

- (void)recentButtonTapped:(UIButton *)button
{
	[_delegate tappedInToolbar:self recentButton:button];
}
- (void)progressButtonTapped:(UIButton *)button
{
	[_delegate tappedInToolbar:self progressButton:button];
}
- (void)nameButtonTapped:(UIButton *)button
{
	[_delegate tappedInToolbar:self nameButton:button];
}
@end
