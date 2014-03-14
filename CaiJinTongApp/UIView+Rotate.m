//
//  UIView+Rotate.m
//  RotateViewTest
//
//  Created by david on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UIView+Rotate.h"

@implementation UIView(Rotate)
-(void)rotate90DegreeTopRect:(CGRect)rect withFinished:(void(^)(void))finish{
    self.alpha = 0;
    self.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI*1.5);
    } completion:^(BOOL finished) {
        self.frame = (CGRect){CGRectGetMinX(rect)+rect.size.width/2-CGRectGetWidth(self.frame)/2,CGRectGetMinY(rect) - CGRectGetHeight(self.frame)-2,self.frame.size};
        [UIView animateWithDuration:0.5 animations:^{
            self.alpha = 1;
            if (finish) {
                finish();
            }
        }];
    }];
}
@end
