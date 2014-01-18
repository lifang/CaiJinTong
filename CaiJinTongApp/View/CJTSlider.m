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
        self.frontImageView = [[UIImageView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        self.frontImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self.frontImageView setImage:[UIImage imageNamed:@"downloadprogressBar.png"]];
        self.frontImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.frontImageView.clipsToBounds = YES;
        [self addSubview:self.frontImageView];        
        self.backgroundColor = [UIColor lightGrayColor];
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

-(void)setProgress:(float)progress{
    _progress = progress;
    self.frontImageView.frame = (CGRect){0,0,CGRectGetWidth(self.frame)*progress,self.frame.size.height};
}
@end
