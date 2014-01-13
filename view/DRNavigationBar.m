//
//  DRNavigationBar.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNavigationBar.h"

@implementation DRNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, 589, 44)];
        self.titleLabel.textColor = [UIColor darkGrayColor];
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        self.titleLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLabel];
        
        self.navigationRightItem = [[UIButton alloc]initWithFrame:CGRectMake(640, 6, 70, 34)];
        [self.navigationRightItem setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03"] forState:UIControlStateNormal];
        self.navigationRightItem.backgroundColor = [UIColor clearColor];
        self.navigationRightItem.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.navigationRightItem];
        
        self.hiddenBtn = [[UIButton alloc]initWithFrame:CGRectMake(560, 6, 70, 34)];
        [self.hiddenBtn setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03"] forState:UIControlStateNormal];
        self.hiddenBtn.hidden = YES;
        self.hiddenBtn.backgroundColor = [UIColor clearColor];
        self.hiddenBtn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self addSubview:self.hiddenBtn];
        
        self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:232.0/255.0 alpha:1.0];
    }
    return self;
}


-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    UIView* result = [super hitTest:point withEvent:event];
    if (result)
        return result;
    for (UIView* sub in [self.subviews reverseObjectEnumerator]) {
        CGPoint pt = [self convertPoint:point toView:sub];
        result = [sub hitTest:pt withEvent:event];
        if (result)
            return result;
    }
    return nil;
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
