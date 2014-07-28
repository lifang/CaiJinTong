//
//  QuestionAndAnswerCell.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCell.h"
@interface QuestionAndAnswerCell()
@end
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

-(NSString *)returnAnsweContentWith:(NSString *)htmlString {
    NSString *content;
    
    if (htmlString && ![htmlString isEqualToString:@""]){
        HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:nil];
        
        for (HTMLNode *node in parser.body.children){
            if (node.contents){
            content = node.contents;
            }
        }
    }
    return content;
}

- (IBAction)answerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:isHiddleQuestionView:atIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self isHiddleQuestionView:self.questionBackgroundView.isHidden atIndexPath:self.path];
    }
}

- (IBAction)questionOKBtClicked:(id)sender {
    if (!self.questionTextField.text || [[self.questionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return;
    }
    [self.questionTextField resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:summitQuestion:atIndexPath:withReaskType:)]) {
        [self.delegate questionAndAnswerCell:self summitQuestion:self.questionTextField.text atIndexPath:self.path withReaskType:self.reaskType];
    }
}
//采纳答案
- (IBAction)acceptAnswerBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:acceptAnswerAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self acceptAnswerAtIndexPath:self.path];
    }
}

#pragma mark UITextViewDelegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell:willBeginTypeQuestionTextFieldAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell:self willBeginTypeQuestionTextFieldAtIndexPath:self.path];
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
            [self.acceptAnswerBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
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
    [self.answerBt setHidden:NO];
    if (user.userId &&[[user userId] isEqualToString:question.askerId]) {
        //自己提的问题
        if (answer.reaskModelArray.count > 0) {
            Reaskmodel *reask = [answer.reaskModelArray lastObject];
            if (reask.reAnswerContent && ![reask.reAnswerContent isEqualToString:@""]) {
                //追问
                [self.reaskBt setTitle:@"追问" forState:UIControlStateNormal];
                [self.answerBt setTitle:@"追问" forState:UIControlStateNormal];
                self.reaskType = ReaskType_Reask;
            }else{
                //修改追问
                [self.reaskBt setTitle:@"修改追问" forState:UIControlStateNormal];
                [self.answerBt setTitle:@"修改追问" forState:UIControlStateNormal];
                self.reaskType = ReaskType_ModifyReask;
            }
        }else{
            //只能追问
            [self.reaskBt setTitle:@"追问" forState:UIControlStateNormal];
            [self.answerBt setTitle:@"追问" forState:UIControlStateNormal];
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
                    [self.answerBt setTitle:@"修改回复" forState:UIControlStateNormal];
                    self.reaskType = ReaskType_AnswerForReasking;
                }else{
                    //对追问进行回复
                    [self.reaskBt setTitle:@"回复" forState:UIControlStateNormal];
                    [self.answerBt setTitle:@"回复" forState:UIControlStateNormal];
                    self.reaskType = ReaskType_AnswerForReasking;
                }
            }else{
                //没有追问,修改回答
                [self.reaskBt setTitle:@"修改回答" forState:UIControlStateNormal];
                [self.answerBt setTitle:@"修改回答" forState:UIControlStateNormal];
                self.reaskType = ReaskType_ModifyAnswer;
            }
            
        }else{
            //别人的答案无权操作
            [self.answerBt setUserInteractionEnabled:NO];
            [self.answerBt setHidden:YES];
        }
    }
}
-(void)setAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question{
    
    self.qTitleNameLabel.text = answer.answerNick;
    self.qDateLabel.text = [NSString stringWithFormat:@"发表于%@",answer.answerTime];
    self.qflowerLabel.text = answer.answerPraiseCount;
    [self.questionBackgroundView setHidden:!answer.isEditing];

    //赞
    [self modifyPraiseBtStatusWithAnswerModel:answer withQuestion:question];
    self.questionTextField.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
    
    //是否采纳回答
    [self modifyAcceptAnswerBtStatusWithAnswerModel:answer withQuestion:question];
    
    //追问实现
    [self modifyReaskAnswerBtStatusWithAnswerModel:answer withQuestion:question];
    
    self.answerAttributeTextView.answerModel = answer;
    
    self.questionTextField.text = @"";
    if (answer.isEditing) {
        NSString *text = self.answerBt.titleLabel.text;
        
        if ([text isEqualToString:@"修改回答"]){
            NSString *content = [self returnAnsweContentWith:answer.answerContent];
            if (content) {
                self.questionTextField.text = content;
            }
        }else if([text isEqualToString:@"修改追问"]){
            Reaskmodel *reaskObj = (Reaskmodel *)[answer.reaskModelArray lastObject];
            NSString *content = [self returnAnsweContentWith:reaskObj.reaskContent];
            if (content) {
                self.questionTextField.text = content;
            }
        }else if([text isEqualToString:@"修改回复"]){
            Reaskmodel *reaskObj = (Reaskmodel *)[answer.reaskModelArray lastObject];
            NSString *content = [self returnAnsweContentWith:reaskObj.reAnswerContent];
            if (content) {
                self.questionTextField.text = content;
            }
        }
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    self.qTitleNameImageView.frame = (CGRect){0,8,16,16};
    
    self.qTitleNameLabel.frame = (CGRect){CGRectGetMaxX(self.qTitleNameImageView.frame) + 2,0,[Utility getTextSizeWithString:self.qTitleNameLabel.text withFont:self.qTitleNameLabel.font].width,CGRectGetHeight(self.qTitleNameLabel.frame)};
    
    self.qDateLabel.frame = (CGRect){CGRectGetMaxX(self.qTitleNameLabel.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qDateLabel.text withFont:self.qDateLabel.font].width,CGRectGetHeight(self.qDateLabel.frame)};
    
    self.qflowerImageView.frame = (CGRect){CGRectGetMaxX(self.qDateLabel.frame)+TEXT_PADDING,0,CGRectGetHeight(self.qflowerImageView.frame),CGRectGetHeight(self.qflowerImageView.frame)};
    
    self.qflowerLabel.frame = (CGRect){CGRectGetMaxX(self.qflowerImageView.frame)+TEXT_PADDING,0,[Utility getTextSizeWithString:self.qflowerLabel.text withFont:self.qflowerLabel.font].width,CGRectGetHeight(self.qflowerLabel.frame)};
    
    //点击追问 / 修改追问 /修改回答
    self.answerBt.layer.cornerRadius = 4.;
    
    //采纳答案 / 正确回答
    self.acceptAnswerBt.layer.cornerRadius = 4.;

    float cellHeight = [self.delegate questionAndAnswerCell:self getCellheightAtIndexPath:self.path];
    self.answerAttributeTextView.frame = (CGRect){self.answerAttributeTextView.frame.origin,QUESTIONANDANSWER_CELL_WIDTH,cellHeight};
    
    self.qflowerBt.frame = (CGRect){CGRectGetMinX(self.qflowerImageView.frame)-TEXT_PADDING,0,CGRectGetMaxX(self.qflowerLabel.frame) - CGRectGetMinX(self.qflowerImageView.frame)+TEXT_PADDING*2,CGRectGetHeight(self.qTitleNameLabel.frame)};
    self.questionBackgroundView.frame = (CGRect){self.questionBackgroundView.frame.origin,QUESTIONANDANSWER_CELL_WIDTH,self.questionBackgroundView.frame.size.height};
}

@end
