//
//  CustomTextView.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-8.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CustomTextView.h"

@implementation CustomTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [self.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [self.layer setBorderWidth:1.0];
    [self.layer setCornerRadius:8.0f];
    [self.layer setMasksToBounds:YES];
}


@end
