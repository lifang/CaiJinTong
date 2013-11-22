//
//  DRMoviePlayerTopBar.m
//  CaiJinTongApp
//
//  Created by david on 13-11-22.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRMoviePlayerTopBar.h"

@implementation DRMoviePlayerTopBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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
-(IBAction)LeftBackBtClicked:(id)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(drMoviePlayerTopBarbackItemClicked:)]) {
        [self.delegate drMoviePlayerTopBarbackItemClicked:self];
    }
}
@end
