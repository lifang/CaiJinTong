//
//  QuestionAndAnswerCell_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCell_iPhone.h"
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
}

- (IBAction)qflowerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:flowerAnswerAtIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self flowerAnswerAtIndexPath:self.path];
    }
}

- (IBAction)answerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:isHiddleQuestionView:atIndexPath:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self isHiddleQuestionView:self.questionBackgroundView.isHidden atIndexPath:self.path];
    }
}

- (IBAction)questionOKBtClicked:(id)sender {
    if (!self.questionTextField.text || [[self.questionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(QuestionAndAnswerCell_iPhone:summitQuestion:atIndexPath:withReaskType:)]) {
        [self.delegate QuestionAndAnswerCell_iPhone:self summitQuestion:self.questionTextField.text atIndexPath:self.path withReaskType:self.reaskType];
        self.questionTextField.text = @"";
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
//修改赞状态
-(void)modifyPraiseBtStatusWithAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    UserModel *user = [[CaiJinTongManager shared] user];
    if ([answer.isPraised isEqualToString:@"1"] || [[user userId] isEqualToString:answer.answerId]) {
        self.qflowerImageView.alpha = 0.5;
        [self.qflowerBt setUserInteractionEnabled:NO];
    }else{
        self.qflowerImageView.alpha = 1;
        [self.qflowerBt setUserInteractionEnabled:YES];
    }
}

//修改是否采纳回答状态
-(void)modifyAcceptAnswerBtStatusWithAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    UserModel *user = [[CaiJinTongManager shared] user];
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
        if ([[CaiJinTongManager shared] userId] && [[user userId] isEqualToString:question.askerId]) {
            [self.acceptAnswerBt setHidden:NO];
            [self.acceptAnswerBt setUserInteractionEnabled:YES];
            [self.acceptAnswerBt setTitle:@"采纳回答" forState:UIControlStateNormal];
            [self.acceptAnswerBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        }else{
            [self.acceptAnswerBt setHidden:YES];
        }
    }
}

//修改追问状态
-(void)modifyReaskAnswerBtStatusWithAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    UserModel *user = [[CaiJinTongManager shared] user];
    [self.answerBt setUserInteractionEnabled:YES];
    if (user.userId &&[[user userId] isEqualToString:question.askerId]) {
        //自己提的问题
        if (answer.reaskModelArray.count > 0) {
            Reaskmodel *reask = [answer.reaskModelArray lastObject];
            //            if (reask.reAnswerID && ![reask.reAnswerID isEqualToString:@""] && ![reask.reAnswerID isEqualToString:@"<null>"] ) {
            if (reask.reAnswerContent && ![reask.reAnswerContent isEqualToString:@""]) {
                //追问
                [self.reaskBt setTitle:@"追问" forState:UIControlStateNormal];
                self.reaskType = ReaskType_Reask;
            }else{
                //修改追问
                [self.reaskBt setTitle:@"修改追问" forState:UIControlStateNormal];
                self.reaskType = ReaskType_ModifyReask;
            }
        }else{
            //只能追问
            [self.reaskBt setTitle:@"追问" forState:UIControlStateNormal];
            self.reaskType = ReaskType_Reask;
        }
        
    }else{
        //别人提的问题
        if ([user.userId isEqualToString:answer.answerId]) {
            //自己的答案
            if (answer.reaskModelArray.count > 0) {
                //有追问
                Reaskmodel *reask = [answer.reaskModelArray lastObject];
                if (reask.reAnswerContent && ![reask.reAnswerContent isEqualToString:@""]) {
                    //修改回复
                    [self.reaskBt setTitle:@"修改回复" forState:UIControlStateNormal];
                    self.reaskType = ReaskType_AnswerForReasking;
                }else{
                    //对追问进行回复
                    [self.reaskBt setTitle:@"回复" forState:UIControlStateNormal];
                    self.reaskType = ReaskType_AnswerForReasking;
                }
            }else{
                //没有追问,修改回答
                [self.reaskBt setTitle:@"修改回答" forState:UIControlStateNormal];
                self.reaskType = ReaskType_ModifyAnswer;
            }
            
        }else{
            //别人的答案无权操作
            [self.answerBt setUserInteractionEnabled:NO];
        }
    }
}
-(void)setAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    self.qTitleNameLabel.text = answer.answerNick;
    self.qDateLabel.text = [NSString stringWithFormat:@"发表于%@",answer.answerTime];
    self.qflowerLabel.text = answer.answerPraiseCount;
    [self.questionBackgroundView setHidden:!answer.isEditing]; //此处决定是否显示追问界面
    
    //赞
    [self modifyPraiseBtStatusWithAnswerModel:answer withQuestion:question];
    self.questionTextField.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    //是否采纳回答
    [self modifyAcceptAnswerBtStatusWithAnswerModel:answer withQuestion:question];
    
    //追问实现
    [self modifyReaskAnswerBtStatusWithAnswerModel:answer withQuestion:question];
    
    //绘制回答内容
    self.answerAttributeTextView.answerModel = answer;

    [self setNeedsLayout];
//    self.answerTextField.contentInset = UIEdgeInsetsMake(-10, -27, 0, 0);
    
}

-(void)layoutSubviews{
    
    //第一行
    self.qTitleNameLabel.frame = (CGRect){0,0,[Utility getTextSizeWithString:self.qTitleNameLabel.text withFont:self.qTitleNameLabel.font].width,CGRectGetHeight(self.qTitleNameLabel.frame)};
    
    self.qDateLabel.frame = (CGRect){CGRectGetMaxX(self.qTitleNameLabel.frame)+lTEXT_PADDING,0,[Utility getTextSizeWithString:self.qDateLabel.text withFont:self.qDateLabel.font].width,CGRectGetHeight(self.qDateLabel.frame)};
    
    self.qflowerImageView.frame = (CGRect){CGRectGetMaxX(self.qDateLabel.frame)+lTEXT_PADDING,4,CGRectGetHeight(self.qflowerImageView.frame),CGRectGetHeight(self.qflowerImageView.frame)};
    
    self.qflowerLabel.frame = (CGRect){CGRectGetMaxX(self.qflowerImageView.frame)+lTEXT_PADDING,0,[Utility getTextSizeWithString:self.qflowerLabel.text withFont:self.qflowerLabel.font].width,CGRectGetHeight(self.qflowerLabel.frame)};
    
//    self.acceptAnswerBt.frame = (CGRect){CGRectGetMaxX(self.qflowerLabel.frame)+TEXT_PADDING,0,self.acceptAnswerBt.frame.size};
    
    self.qflowerBt.frame = (CGRect){CGRectGetMinX(self.qflowerImageView.frame)-lTEXT_PADDING,0,CGRectGetMaxX(self.qflowerLabel.frame) - CGRectGetMinX(self.qflowerImageView.frame)+lTEXT_PADDING*2,CGRectGetHeight(self.qTitleNameLabel.frame)};
    

    //回答的正文
    float cellHeight = [self.delegate QuestionAndAnswerCell_iPhone:self getCellheightAtIndexPath:self.path];
    self.answerAttributeTextView.frame = (CGRect){self.answerAttributeTextView.frame.origin,lQUESTIONANDANSWER_CELL_WIDTH,cellHeight};
//    self.answerBt.frame = (CGRect){0,0,self.answerAttributeTextView.frame.size};
    self.answerBt.frame = self.answerAttributeTextView.frame;
    DLog(@"self.answerBt.frame : %f %f %f %f",self.answerBt.frame.origin.x,self.answerBt.frame.origin.y,self.answerBt.frame.size.width,self.answerBt.frame.size.height);
//    self.answerBackgroundView.frame = (CGRect){self.answerBackgroundView.frame.origin,QUESTIONANDANSWER_CELL_WIDTH,cellHeight};
    
//    self.answerAttributeTextView.frame = (CGRect){0,0,self.answerBackgroundView.frame.size.width + 27,self.answerBackgroundView.frame.size.height};  //调整文字位置27
    
    
    //追问部分
//    self.questionBackgroundView.frame = (CGRect){CGRectGetMinX(self.questionBackgroundView.frame),CGRectGetMaxY(self.answerAttributeTextView.frame)+5,self.questionBackgroundView.frame.size};
//    self.reaskBt.frame = (CGRect){self.questionTextField.center.x + 10,CGRectGetMaxY(self.questionTextField.frame) + 5,110,30};
    
    [self.questionTextField.layer setCornerRadius:4.0];
    [self.questionTextField.layer setBorderWidth:0.6];
    [self.questionTextField.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [self.reaskBt setBackgroundImage:[UIImage imageNamed:@"btn0@2x.png"] forState:UIControlStateNormal];
    [self.reaskBt.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
}

@end
