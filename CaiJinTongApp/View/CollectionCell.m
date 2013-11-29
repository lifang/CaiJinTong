//
//  CollectionCell.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.pv = [[CJTSlider alloc]initWithFrame:CGRectMake(-2, 182, 254, 33)];
        [self.contentView addSubview:self.pv];

        //视频名称
        UIFont *font = [UIFont systemFontOfSize:20];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 31)];
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentLeft;
        nameLabel.backgroundColor = [UIColor clearColor];
        nameLabel.font = font;
        self.nameLab = nameLabel;
        [self.contentView addSubview:self.nameLab];
        nameLabel = nil;
        
        //视频封面
        UIImageView *imageViewC = [[UIImageView alloc]initWithFrame:CGRectMake(0, 31, 250, 184)];
        self.imageView = imageViewC;
        [self.contentView addSubview:self.imageView];
        imageViewC = nil;

        
        UILabel *progress = [[UILabel alloc] initWithFrame:CGRectMake(1, 184, 249, 31)];
        progress.textAlignment = NSTextAlignmentLeft;
        progress.backgroundColor = [UIColor clearColor];
        self.progressLabel = progress;
        [self.contentView addSubview:self.progressLabel];
        progress = nil;
        
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
