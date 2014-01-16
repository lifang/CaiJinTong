//
//  CollectionCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "CollectionCell.h"
#import "UIImageView+WebCache.h"
@implementation CollectionCell
-(void)changeLessonModel:(LessonModel*)lessonModel{
    self.lessonNameLabel.text = lessonModel.lessonName;
    [self.lessonImageView setImageWithURL:[NSURL URLWithString:lessonModel.lessonImageURL] placeholderImage:[UIImage imageNamed:@"logo@2x.png"]];
    self.imageBackView.layer.borderWidth = 1;
    self.imageBackView.layer.borderColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.4].CGColor;
    //学习进度
    CGFloat xx = [lessonModel.lessonStudyProgress floatValue];
    if ( xx > 1.0) {
        xx=1.0;
    }
    if (!xx) {
        xx = 0;
    }
    float width = CGRectGetWidth(self.imageBackView.frame)*xx;
    self.progressTrackImageView.frame = (CGRect){0,CGRectGetMinY(self.progressTrackImageView.frame),width,CGRectGetHeight(self.progressTrackImageView.frame)};
    self.progressLabel.text = [NSString stringWithFormat:@"学习进度 : %0.2f%%",xx*100];
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
