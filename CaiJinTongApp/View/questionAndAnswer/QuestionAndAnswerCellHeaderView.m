//
//  QuestionAndAnswerCellHeaderView.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCellHeaderView.h"
#define TEXT_FONT [UIFont systemFontOfSize:24]
#define TEXT_PADDING 10

@interface QuestionAndAnswerCellHeaderView ()
@property (nonatomic,strong) UILabel *questionNameLabel;
@property (nonatomic,strong) UILabel *questionDateLabel;
@property (nonatomic,strong) UIImageView *questionFlowerImageView;
@property (nonatomic,strong) UILabel *questionFlowerLabel;
@property (nonatomic,strong) UILabel *questionContentLabel;
@end

@implementation QuestionAndAnswerCellHeaderView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.questionNameLabel = [[UILabel alloc] init];
        self.questionNameLabel.backgroundColor = [UIColor redColor];
        self.questionNameLabel.font = TEXT_FONT;
        self.questionNameLabel.textColor = [UIColor blackColor];
        self.questionNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.questionNameLabel];
        
        self.questionDateLabel = [[UILabel alloc] init];
        self.questionDateLabel.backgroundColor = [UIColor purpleColor];
        self.questionDateLabel.font = TEXT_FONT;
        self.questionDateLabel.textColor = [UIColor blackColor];
        self.questionDateLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.questionDateLabel];
        
        self.questionFlowerImageView = [[UIImageView alloc] init];
        self.questionFlowerImageView.image = [UIImage imageNamed:@"retreat.png"];
        self.questionFlowerImageView.backgroundColor = [UIColor greenColor];
        [self addSubview:self.questionFlowerImageView];
        
        self.questionFlowerLabel = [[UILabel alloc] init];
        self.questionFlowerLabel.backgroundColor = [UIColor yellowColor];
        self.questionFlowerLabel.font = TEXT_FONT;
        self.questionFlowerLabel.textColor = [UIColor blackColor];
        self.questionFlowerLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.questionFlowerLabel];
        
        self.questionContentLabel = [[UILabel alloc] init];
        self.questionContentLabel.backgroundColor = [UIColor yellowColor];
        self.questionContentLabel.font = [UIFont systemFontOfSize:30];
        self.questionContentLabel.textColor = [UIColor blueColor];
        self.questionContentLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.questionContentLabel];
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

-(void)setQuestionModel:(QuestionModel*)question{

}

-(void)layoutSubviews{
    self.questionNameLabel.frame = (CGRect){};
}
@end
