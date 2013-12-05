//
//  LessonListHeaderView_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonListHeaderView_iPhone.h"
#define FONT_SIZE 15
@interface LessonListHeaderView_iPhone ()


@property (nonatomic,strong) UIButton *coverBt;
@property (nonatomic,strong) UIImageView *lineImageView;
@end
@implementation LessonListHeaderView_iPhone

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.lineImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"play-courselist_0d3@2x.png"]];
        self.lineImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.lineImageView];
        
        self.backgroundView = [UIView new];
        self.lessonTextLabel = [[UILabel alloc] init];
        self.lessonTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.lessonTextLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.lessonTextLabel];
        self.lessonDetailLabel = [[UILabel alloc] init];
        self.lessonDetailLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.lessonDetailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.lessonDetailLabel];
        
        self.lessonTextLabel.backgroundColor = [UIColor clearColor];
        self.lessonDetailLabel.backgroundColor = [UIColor clearColor];
        
        self.lessonTextLabel.textColor = [UIColor whiteColor];
        self.lessonDetailLabel.textColor = [UIColor whiteColor];
        
        self.flagImageView = [[UIImageView alloc] init];
        
        self.flagImageView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.flagImageView];
        
        self.coverBt = [[UIButton alloc] init];
        self.coverBt.backgroundColor = [UIColor clearColor];
        [self addSubview:self.coverBt];
        [self.coverBt addTarget:self action:@selector(cellSelected) forControlEvents:UIControlEventTouchUpInside];
        self.isSelected = NO;
    }
    return self;
}

-(void)layoutSubviews{
    self.lineImageView.frame = (CGRect){0,0,CGRectGetWidth(self.frame),2};
    
    self.lessonTextLabel.frame = (CGRect){25,2,CGRectGetWidth(self.frame)-55,CGRectGetHeight(self.frame)-2};
    self.lessonDetailLabel.frame = (CGRect){CGRectGetMaxX(self.lessonTextLabel.frame),2,CGRectGetWidth(self.frame)-CGRectGetMaxX(self.lessonTextLabel.frame)-5,CGRectGetHeight(self.frame)-2};
    self.flagImageView.frame = (CGRect){5,CGRectGetHeight(self.frame)/2- 4,8,8};
    self.coverBt.frame = self.bounds;
}
-(void)cellSelected{
    self.isSelected = !self.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonHeaderView:selectedAtIndex:)]) {
        [self.delegate lessonHeaderView:self selectedAtIndex:self.path];
    }
}

-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.flagImageView.backgroundColor = [UIColor clearColor];
    if ([self.lessonTextLabel.text isEqualToString:@"本地下载"]) {
        self.flagImageView.image = Image(@"backgroundStar");
    }else {
        if (isSelected) {
            self.flagImageView.image = [UIImage imageNamed:@"course-courses_06_right.png"];
        }else{
            self.flagImageView.image = [UIImage imageNamed:@"course-courses_06.png"];
        }
    }
}
@end
