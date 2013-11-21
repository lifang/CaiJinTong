//
//  QuestionAndAnswerCellHeaderView.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCellHeaderView.h"

@interface QuestionAndAnswerCellHeaderView ()
@property (nonatomic,strong) UILabel *questionNameLabel;
@property (nonatomic,strong) UILabel *questionDateLabel;
@property (nonatomic,strong) UIImageView *questionFlowerImageView;
@property (nonatomic,strong) UILabel *questionFlowerLabel;
@property (nonatomic,strong) UITextField *questionContentTextField;
@property (nonatomic,strong) UIButton *questionFlowerBt;
@property (nonatomic,strong) UIView *backgroundView;
@end

@implementation QuestionAndAnswerCellHeaderView

-(id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        self.questionNameLabel = [[UILabel alloc] init];
        self.questionNameLabel.backgroundColor = [UIColor clearColor];
        self.questionNameLabel.font = TEXT_FONT;
        self.questionNameLabel.textColor = [UIColor blackColor];
        self.questionNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.backgroundView addSubview:self.questionNameLabel];
        
        self.questionDateLabel = [[UILabel alloc] init];
        self.questionDateLabel.backgroundColor = [UIColor clearColor];
        self.questionDateLabel.font = TEXT_FONT;
        self.questionDateLabel.textColor = [UIColor blackColor];
        self.questionDateLabel.textAlignment = NSTextAlignmentLeft;
        [self.backgroundView addSubview:self.questionDateLabel];
        
        self.questionFlowerImageView = [[UIImageView alloc] init];
        self.questionFlowerImageView.image = [UIImage imageNamed:@"Q&A-myq_11.png"];
        self.questionFlowerImageView.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.questionFlowerImageView];
        
        self.questionFlowerLabel = [[UILabel alloc] init];
        self.questionFlowerLabel.backgroundColor = [UIColor clearColor];
        self.questionFlowerLabel.font = TEXT_FONT;
        self.questionFlowerLabel.textColor = [UIColor blackColor];
        self.questionFlowerLabel.textAlignment = NSTextAlignmentLeft;
        [self.backgroundView addSubview:self.questionFlowerLabel];
        
        self.questionContentTextField = [[UITextField alloc] init];
        self.questionContentTextField.backgroundColor = [UIColor clearColor];
        self.questionContentTextField.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE+6];
        self.questionContentTextField.textColor = [UIColor blueColor];
        self.questionContentTextField.textAlignment = NSTextAlignmentLeft;
        [self.questionContentTextField setEnabled:NO];
        [self.backgroundView addSubview:self.questionContentTextField];
        
        self.questionFlowerBt = [[UIButton alloc] init];
        self.questionFlowerBt.backgroundColor = [UIColor clearColor];
        [self.questionFlowerBt addTarget:self action:@selector(flowerBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.questionFlowerBt];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)flowerBtClicked{
    int flower = [self.questionFlowerLabel.text intValue];
    self.questionFlowerLabel.text = [NSString stringWithFormat:@"%d",flower+1];
     [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCellHeaderView:flowerQuestionAtIndexPath:)]) {
        [self.delegate questionAndAnswerCellHeaderView:self flowerQuestionAtIndexPath:self.path];
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

-(void)setQuestionModel:(QuestionModel*)question{
    if (!question) {
        return;
    }
    self.questionNameLabel.text = question.askerNick;
    self.questionDateLabel.text = [NSString stringWithFormat:@"发表于%@",question.askTime];
    self.questionFlowerLabel.text = question.praiseCount;
    self.questionContentTextField.text = question.questionName;
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    self.backgroundView.frame = self.bounds;
    self.questionNameLabel.frame = (CGRect){TEXT_PADDING*2,0,[Utility getTextSizeWithString:self.questionNameLabel.text withFont:self.questionNameLabel.font].width,TEXT_HEIGHT};
    self.questionDateLabel.frame = (CGRect){CGRectGetMaxX(self.questionNameLabel.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.questionDateLabel.text withFont:self.questionNameLabel.font].width,TEXT_HEIGHT};
    
    self.questionFlowerImageView.frame = (CGRect){CGRectGetMaxX(self.questionDateLabel.frame)+TEXT_PADDING,0,TEXT_HEIGHT,TEXT_HEIGHT};
    
    self.questionFlowerLabel.frame = (CGRect){CGRectGetMaxX(self.questionFlowerImageView.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.questionFlowerLabel.text withFont:self.questionFlowerLabel.font].width,TEXT_HEIGHT};
    
    self.questionFlowerBt.frame = (CGRect){CGRectGetMinX(self.questionFlowerImageView.frame)-TEXT_PADDING*5,0,CGRectGetMaxX(self.questionFlowerLabel.frame) -CGRectGetMinX(self.questionFlowerImageView.frame) +50,TEXT_HEIGHT};
    self.questionContentTextField.frame = (CGRect){TEXT_PADDING*2,TEXT_HEIGHT,CGRectGetWidth(self.frame)-TEXT_PADDING*4,[Utility getTextSizeWithString:self.questionContentTextField.text withFont:self.questionContentTextField.font withWidth:CGRectGetWidth(self.frame)].height};
}
@end
