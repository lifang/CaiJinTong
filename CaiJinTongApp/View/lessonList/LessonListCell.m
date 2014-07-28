//
//  LessonListCell.m
//  CaiJinTongApp
//
//  Created by david on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonListCell.h"

@implementation LessonListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.textLabel.textColor = [UIColor orangeColor];
    }else {
        self.textLabel.textColor = [UIColor whiteColor];
    }
    
}

@end
