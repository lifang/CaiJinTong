//
//  MenuTableCell.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MenuTableCell.h"

@implementation MenuTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setIndentationLevel:2];
        
        if(!self.imageViews){//自定义图片
            self.imageViews = [[UIImageView alloc] init];
            [self.imageViews setFrame:CGRectMake(8, 5, 32, 32)];
            [self.imageViews setClipsToBounds:YES];
            [self.contentView addSubview:self.imageViews];
        }
        
        if(!self.textLabels){
            self.textLabels = [[UILabel alloc] initWithFrame:CGRectMake(10 + CGRectGetMaxX(self.imageViews.frame), 0, self.bounds.size.width - 10 - CGRectGetMaxX(self.imageViews.frame), self.bounds.size.height)];
            self.textLabels.textColor = [UIColor whiteColor];
            self.textLabels.font = [UIFont systemFontOfSize:15];
            [self.textLabels setBackgroundColor:[UIColor clearColor]];
            [self.contentView addSubview:self.textLabels];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabels.textColor = [UIColor orangeColor];
    }else {
        self.textLabels.textColor = [UIColor whiteColor];
    }
}

@end
