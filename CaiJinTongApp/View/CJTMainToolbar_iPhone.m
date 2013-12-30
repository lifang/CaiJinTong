//
//  CJTMainToolbar_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CJTMainToolbar_iPhone.h"

#define X frame.origin.x
#define Y frame.origin.y
#define WIDTH frame.size.width
#define HEIGHT frame.size.height

#define LABEL_X ((WIDTH - RECENT_BUTTON_WIDTH - PROGRESS_BUTTON_WIDTH - NAME_BUTTON_WIDTH - 2 * BUTTON_SPACE ) )
#define BUTTON_Y (HEIGHT / 4)
#define BUTTON_SPACE (WIDTH / 14)
#define BUTTON_HEIGHT (HEIGHT / 2)

#define RECENT_BUTTON_WIDTH (WIDTH * 102 / 281)
#define PROGRESS_BUTTON_WIDTH (60 * WIDTH / 281)
#define NAME_BUTTON_WIDTH (75 * WIDTH / 281)

#define FONT_SIZE ((CGFloat) round(WIDTH * 15.0 / 281))

#define RECENT_TAG 12345
#define PROGRESS_TAG 12346
#define NAME_TAG 12347
@implementation CJTMainToolbar_iPhone


- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        [self setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0]];
        [self.layer setCornerRadius:3.0f];
		CGFloat leftButtonX = LABEL_X;
        //默认(最近播放)
        UIButton *recentPlayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        recentPlayBtn.frame = CGRectMake(leftButtonX, BUTTON_Y, RECENT_BUTTON_WIDTH, BUTTON_HEIGHT);
        [recentPlayBtn setTitle:NSLocalizedString(@"默认(最近播放)", @"button") forState:UIControlStateNormal];
        recentPlayBtn.tag = RECENT_TAG;
		[recentPlayBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [recentPlayBtn addTarget:self action:@selector(recentButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		recentPlayBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        DLog(@"%f大大大大大大大",FONT_SIZE);
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
		progressBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
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
		nameBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
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
