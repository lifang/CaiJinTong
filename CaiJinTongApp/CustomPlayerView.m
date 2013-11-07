//
//  CustomPlayerView.m
//  VideoStreamDemo2
//
//  Created by 刘 大兵 on 12-5-17.
//  Copyright (c) 2012年 中华中等专业学校. All rights reserved.
//

#import "CustomPlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
@interface CustomPlayerView()
@property (nonatomic,assign) CGPoint beforePoint;
@end

@implementation CustomPlayerView
@synthesize volume;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"began %f==%f",touchPoint.x,touchPoint.y);
    x = (touchPoint.x);
    y = (touchPoint.y);
    self.beforePoint = touchPoint;
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    if ((touchPoint.y - self.beforePoint.y) >= 50 && (touchPoint.x - self.beforePoint.x) <= 50 && (touchPoint.x - self.beforePoint.x) >= -50)
    {
        NSLog(@"减小音量 1/10");
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        if ((mpc.volume - 0.1) <= 0)
        {
            mpc.volume = 0;
        }
        else
        {
            mpc.volume = mpc.volume - 0.05;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(TouchVolumeDOWN)]) {
            [self.delegate TouchVolumeDOWN];
        }
        self.beforePoint = touchPoint;
    }
    if ((self.beforePoint.y - touchPoint.y) >= 50)
    {
        NSLog(@"加大音量");
        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
        if ((mpc.volume + 0.1) >= 1)
        {
            mpc.volume = 1;
        }
        else
        {
            mpc.volume = mpc.volume + 0.05;
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(TouchVolumeUP)]) {
            [self.delegate TouchVolumeUP];
        }
        self.beforePoint = touchPoint;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    NSLog(@"end %f==%f",touchPoint.x,touchPoint.y);
    if ((touchPoint.x - x) >= 50 && (touchPoint.y - y) <= 20 && (touchPoint.y - y) >= -20)
    {
        NSLog(@"快进");
        if ([self.delegate respondsToSelector:@selector(Touchspeed)])
        {
            [self.delegate Touchspeed];
        }
    }
    if ((touchPoint.x - x) >= 50 && (y - touchPoint.y) <= 50 && (y - touchPoint.y) >= -50)
    {
        NSLog(@"快进");
        if ([self.delegate respondsToSelector:@selector(Touchspeed)])
        {
            [self.delegate Touchspeed];
        }
    }
    if ((x - touchPoint.x) >= 50 && (touchPoint.y - y) <= 50 && (touchPoint.y - y) >= -50)
    {
        NSLog(@"快退");
        if ([self.delegate respondsToSelector:@selector(Touchretreat)])
        {
            [self.delegate Touchretreat];
        }

    }
    if ((x - touchPoint.x) >= 50 && (y - touchPoint.y) <= 50 && (y - touchPoint.y) >= -50)
    {
        NSLog(@"快退");
        if ([self.delegate respondsToSelector:@selector(Touchretreat)])
        {
            [self.delegate Touchretreat];
        }
        
    }
//    if ((touchPoint.y - y) >= 50 && (touchPoint.x - x) <= 50 && (touchPoint.x - x) >= -50)
//    {
//        NSLog(@"减小音量 1/10");
//        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//        if ((mpc.volume - 0.1) <= 0)
//        {
//            mpc.volume = 0;
//        }
//        else
//        {
//            mpc.volume = mpc.volume - 0.05;
//        }
//    }
//    if ((y - touchPoint.y) >= 50)
//    {
//        NSLog(@"加大音量");
//        MPMusicPlayerController *mpc = [MPMusicPlayerController applicationMusicPlayer];
//        if ((mpc.volume + 0.1) >= 1)
//        {
//            mpc.volume = 1;
//        }
//        else
//        {
//            mpc.volume = mpc.volume + 0.05;
//        }
//
//    }
    //单击事件
    if (abs(x- touchPoint.x) < 10 && abs(y - touchPoint.y) <10) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(TouchSingleTap)]) {
            [self.delegate TouchSingleTap];
        }
    }
}

@end
