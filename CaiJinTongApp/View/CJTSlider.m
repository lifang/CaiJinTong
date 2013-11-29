//
//  CJTSlider.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CJTSlider.h"

@implementation CJTSlider

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *frontImage = [[UIImage imageNamed:@"progressBar-front.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        UIImage *backgroundImage = [[UIImage imageNamed:@"progressBar-background.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        [self setMinimumTrackImage:frontImage forState:UIControlStateNormal];
        [self setMaximumTrackImage:backgroundImage forState:UIControlStateNormal];
        [self setThumbImage:[UIImage imageNamed:@"nothing"] forState:UIControlStateNormal];
        [self setMaximumValue:100.0];
        [self setMinimumValue:0.0];
    }
    return self;
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
