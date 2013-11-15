//
//  LessonListHeaderView.m
//  CaiJinTongApp
//
//  Created by david on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonListHeaderView.h"
#define FONT_SIZE 20
@interface LessonListHeaderView ()


@property (nonatomic,strong) UIButton *coverBt;

@end
@implementation LessonListHeaderView

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
        self.lessonTextLabel = [[UILabel alloc] init];
        self.lessonTextLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.lessonTextLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.lessonTextLabel];
        self.lessonDetailLabel = [[UILabel alloc] init];
         self.lessonDetailLabel.font = [UIFont systemFontOfSize:FONT_SIZE];
        self.lessonDetailLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.lessonDetailLabel];
        
        self.lessonTextLabel.backgroundColor = [UIColor redColor];
        self.lessonDetailLabel.backgroundColor = [UIColor greenColor];
        
        self.flagImageView = [[UIImageView alloc] init];
        
        self.flagImageView.backgroundColor = [UIColor purpleColor];
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
//    [super layoutSubviews];
    self.lessonTextLabel.frame = (CGRect){25,0,CGRectGetWidth(self.frame)-65,CGRectGetHeight(self.frame)};
    self.lessonDetailLabel.frame = (CGRect){CGRectGetMaxX(self.lessonTextLabel.frame),0,CGRectGetWidth(self.frame)-CGRectGetMaxX(self.lessonTextLabel.frame),CGRectGetHeight(self.frame)};
    self.flagImageView.frame = (CGRect){5,CGRectGetHeight(self.frame)/2- 10,20,20};
    self.coverBt.frame = self.bounds;
}
-(void)cellSelected{
    self.isSelected = !self.isSelected;
    if (self.delegate && [self.delegate respondsToSelector:@selector(lessonHeaderView:selectedAtIndex:)]) {
        [self.delegate lessonHeaderView:self selectedAtIndex:self.path];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    if ([self.lessonTextLabel.text isEqualToString:@"本地下载"]) {
        if (isSelected) {
            self.flagImageView.image = Image(@"foregroundStar.png");;
        }else{
            self.flagImageView.image = Image(@"backgroundStar.png");;
        }
    }else {
        if (isSelected) {
            self.flagImageView.image = [UIImage imageNamed:@"jiantou_down.png"];
        }else{
            self.flagImageView.image = [UIImage imageNamed:@"jiantou_up.png"];
        }
    }
}
@end
