//
//  QuestionAndAnswerCell.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCell.h"
#define TEXT_PADDING 10
@implementation QuestionAndAnswerCell

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

    // Configure the view for the selected state
}

- (IBAction)qflowerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:flowerAnswerAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self flowerAnswerAtIndexPath:self.path];
    }
}

- (IBAction)answerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:isHiddleQuestionView:atIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self isHiddleQuestionView:self.questionBackgroundView.isHidden atIndexPath:self.path];
    }
}

- (IBAction)questionOKBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:summitQuestion:atIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self summitQuestion:self.questionTextField.text atIndexPath:self.path];
    }
}

#pragma mark UITextFieldDelegate

#pragma mark --

-(void)setAnswerModel:(AnswerModel*)answer isHiddleQuestionView:(BOOL)ishiddle{
    self.qTitleNameLabel.text = answer.answerNick;
    self.qDateLabel.text = [NSString stringWithFormat:@"发表于%@",answer.answerTime];
    self.qflowerLabel.text = answer.answerPraiseCount;
    self.answerTextField.text = answer.answerContent;
    [self.questionBackgroundView setHidden:ishiddle];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    
    self.qTitleNameLabel.frame = (CGRect){0,0,[Utility getTextSizeWithString:self.qTitleNameLabel.text withFont:self.qTitleNameLabel.font].width,CGRectGetHeight(self.qTitleNameLabel.frame)};
    
    self.qDateLabel.frame = (CGRect){CGRectGetMaxX(self.qTitleNameLabel.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qDateLabel.text withFont:self.qDateLabel.font].width,CGRectGetHeight(self.qDateLabel.frame)};
    
    self.qflowerImageView.frame = (CGRect){CGRectGetMaxX(self.qDateLabel.frame)+TEXT_PADDING,0,CGRectGetHeight(self.qflowerImageView.frame),CGRectGetHeight(self.qflowerImageView.frame)};
    
    self.qflowerLabel.frame = (CGRect){CGRectGetMaxX(self.qflowerImageView.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qflowerLabel.text withFont:self.qflowerLabel.font].width,CGRectGetHeight(self.qflowerLabel.frame)};
    
    self.qflowerBt.frame = (CGRect){CGRectGetMaxX(self.qflowerLabel.frame)+TEXT_PADDING,0,self.qflowerBt.frame.size};
    
    self.answerBackgroundView.frame = (CGRect){self.answerBackgroundView.frame.origin,CGRectGetWidth(self.answerBackgroundView.frame),[Utility getTextSizeWithString:self.answerTextField.text withFont:self.answerTextField.font].height};
    
}


@end
