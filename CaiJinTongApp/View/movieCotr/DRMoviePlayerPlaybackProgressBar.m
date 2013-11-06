//
//  DRMoviePlayerPlaybackProgressBar.m
//  CaiJinTongApp
//
//  Created by david on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRMoviePlayerPlaybackProgressBar.h"

@implementation DRMoviePlayerPlaybackProgressBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    DLog(@"DRMoviePlayerPlaybackProgressBar touch Begin");
    if (self.delegate && [self.delegate respondsToSelector:@selector(playBackProgressBarTouchBegin:)]) {
        [self.delegate playBackProgressBarTouchBegin:self];
    }
}


-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    DLog(@"DRMoviePlayerPlaybackProgressBar touchesEnded");
    if (self.delegate && [self.delegate respondsToSelector:@selector(playBackProgressBarTouchEnd:)]) {
        [self.delegate playBackProgressBarTouchEnd:self];
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesCancelled:touches withEvent:event];
    DLog(@"DRMoviePlayerPlaybackProgressBar touchesCancelled");
    if (self.delegate && [self.delegate respondsToSelector:@selector(playBackProgressBarTouchEnd:)]) {
        [self.delegate playBackProgressBarTouchEnd:self];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
