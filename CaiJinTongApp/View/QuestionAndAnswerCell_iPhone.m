//
//  QuestionAndAnswerCell_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCell_iPhone.h"
@interface QuestionAndAnswerCell_iPhone()

@end
@implementation QuestionAndAnswerCell_iPhone

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
    int flower = [self.qflowerLabel.text intValue];
    self.qflowerLabel.text  = [NSString stringWithFormat:@"%d",flower+1];
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:flowerAnswerAtIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self flowerAnswerAtIndexPath:self.path];
    }
}

- (IBAction)answerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:isHiddleQuestionView:atIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self isHiddleQuestionView:self.questionBackgroundView.isHidden atIndexPath:self.path];
    }
    self.answerTextField.backgroundColor = [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0];
}

- (IBAction)questionOKBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:summitQuestion:atIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self summitQuestion:self.questionTextField.text atIndexPath:self.path];
    }
}
//采纳答案
- (IBAction)acceptAnswerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:acceptAnswerAtIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self acceptAnswerAtIndexPath:self.path];
    }
}

#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:willBeginTypeQuestionTextFieldAtIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self willBeginTypeQuestionTextFieldAtIndexPath:self.path];
    }
    return YES;
}

#pragma mark --

-(void)setAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    self.answerTextField.delegate = self;
    self.qTitleNameLabel.text = answer.answerNick;
    self.qDateLabel.text = [NSString stringWithFormat:@"发表于%@",answer.answerTime];
    self.qflowerLabel.text = answer.answerPraiseCount;
    self.answerTextField.text = answer.answerContent;
    [self.questionBackgroundView setHidden:!answer.isEditing];
    self.answerTextField.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE+6];
    [self.qflowerBt setUserInteractionEnabled:!answer.isPraised];
    
    if (question.isAcceptAnswer && [question.isAcceptAnswer intValue]==1) {
        if (answer.IsAnswerAccept && [answer.IsAnswerAccept intValue]==1) {
            [self.acceptAnswerBt setHidden:NO];
            [self.acceptAnswerBt setUserInteractionEnabled:NO];
            [self.acceptAnswerBt setTitle:@"正确回答" forState:UIControlStateNormal];
            [self.acceptAnswerBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        }else{
            [self.acceptAnswerBt setHidden:YES];
        }
    }else{
        [self.acceptAnswerBt setHidden:NO];
        [self.acceptAnswerBt setUserInteractionEnabled:YES];
        [self.acceptAnswerBt setTitle:@"采纳回答" forState:UIControlStateNormal];
        [self.acceptAnswerBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    }
    
    if ([[CaiJinTongManager shared] userId] && [[[CaiJinTongManager shared] userId] isEqualToString:question.askerId]) {
        [self.answerBt setHidden:NO];
    }else{
        [self.answerBt setHidden:YES];
    }
    
    [self setNeedsLayout];
    
    //    self.qTitleNameLabel.backgroundColor = [UIColor clearColor];
    //    self.qDateLabel.backgroundColor = [UIColor clearColor];
    //    self.qflowerImageView.image = [UIImage imageNamed:@"Q&A-myq_19.png"];
    //    self.qflowerLabel.backgroundColor = [UIColor clearColor];
    //    self.answerTextField.backgroundColor = [UIColor clearColor];
    //    self.acceptAnswerBt.backgroundColor = [UIColor clearColor];
    //    [self.qflowerBt setTitle:@"" forState:UIControlStateNormal];
    //    self.questionTextField.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    //    self.questionBackgroundView.backgroundColor = [UIColor clearColor];
    //    self.answerBackgroundView.backgroundColor = [UIColor clearColor];
    self.answerTextField.contentInset = UIEdgeInsetsMake(-10, -5, 0, 0);
}

-(void)layoutSubviews{
    
    self.qTitleNameLabel.frame = (CGRect){0,0,[Utility getTextSizeWithString:self.qTitleNameLabel.text withFont:self.qTitleNameLabel.font].width,CGRectGetHeight(self.qTitleNameLabel.frame)};
    
    self.qDateLabel.frame = (CGRect){CGRectGetMaxX(self.qTitleNameLabel.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qDateLabel.text withFont:self.qDateLabel.font].width,CGRectGetHeight(self.qDateLabel.frame)};
    
    self.qflowerImageView.frame = (CGRect){CGRectGetMaxX(self.qDateLabel.frame)+TEXT_PADDING,0,CGRectGetHeight(self.qflowerImageView.frame),CGRectGetHeight(self.qflowerImageView.frame)};
    
    self.qflowerLabel.frame = (CGRect){CGRectGetMaxX(self.qflowerImageView.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qflowerLabel.text withFont:self.qflowerLabel.font].width,CGRectGetHeight(self.qflowerLabel.frame)};
    
    self.acceptAnswerBt.frame = (CGRect){CGRectGetMaxX(self.qflowerLabel.frame)+TEXT_PADDING,0,self.acceptAnswerBt.frame.size};
    
    CGSize contentSize = [Utility getTextSizeWithString:self.answerTextField.text withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONANDANSWER_CELL_WIDTH];
    self.answerBackgroundView.frame = (CGRect){self.answerBackgroundView.frame.origin,QUESTIONANDANSWER_CELL_WIDTH,contentSize.height};
    
    self.qflowerBt.frame = (CGRect){CGRectGetMinX(self.qflowerImageView.frame)-TEXT_PADDING,0,CGRectGetMaxX(self.qflowerLabel.frame) - CGRectGetMinX(self.qflowerImageView.frame)+TEXT_PADDING*2,CGRectGetHeight(self.qTitleNameLabel.frame)};
}


@end
