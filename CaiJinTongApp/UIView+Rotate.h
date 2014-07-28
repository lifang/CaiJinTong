//
//  UIView+Rotate.h
//  RotateViewTest
//
//  Created by david on 14-3-14.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView(Rotate)
///旋转90度到rect顶部中间上面
-(void)rotate90DegreeTopRect:(CGRect)rect withFinished:(void(^)(void))finish;
@end
