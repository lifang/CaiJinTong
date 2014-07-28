//
//  LessonViewControllerCell_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 14-1-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LessonViewControllerCell_iPhone.h"

@implementation LessonViewControllerCell_iPhone

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

-(SectionCustomView_iPhone *)sectionCustomView{
    if(!_sectionCustomView){
        _sectionCustomView = [[SectionCustomView_iPhone alloc] initWithFrame:CGRectMake(18, 10, 125, 145)];
        [self addSubview:_sectionCustomView];
    }
    return _sectionCustomView;
}
@end
