//
//  LHLNavigationBar.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLNavigationBar.h"
#define Y (IS_4_INCH ? 8 : 0)
@implementation LHLNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(52, 15 + Y, 216, 35)];
        self.title.textColor = [UIColor whiteColor];
        self.title.text = @"我是标题";
        self.title.font = [UIFont systemFontOfSize:20];
        [self.title setTextAlignment:NSTextAlignmentCenter];
        self.title.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        self.title.backgroundColor = [UIColor clearColor];
        [self addSubview:self.title];
        
        self.rightItem = [[UIButton alloc]initWithFrame:CGRectMake(278, 21 + Y, 24, 24)];
        [self.rightItem setBackgroundImage:[UIImage imageNamed:@"rightItemBg.png"] forState:UIControlStateNormal];
        self.rightItem.backgroundColor = [UIColor clearColor];
        self.rightItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.rightItem];
        
        self.leftItem = [[UIButton alloc]initWithFrame:CGRectMake(18, 21 + Y, 24, 24)];
        [self.leftItem setBackgroundImage:[UIImage imageNamed:@"leftItemBg.png"] forState:UIControlStateNormal];
        self.leftItem.backgroundColor = [UIColor clearColor];
        self.leftItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.leftItem];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        [self setBackgroundColor:[UIColor colorWithRed:14.0/255.0 green:50.0/255.0 blue:84.0/255.0 alpha:1.0]];
    }
    return self;
}



@end
