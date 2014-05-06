//
//  AnswerForQuestionCellV2.m
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "AnswerForQuestionCellV2.h"

@implementation AnswerForQuestionCellV2

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

- (IBAction)moreBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(answerForQuestionCellV2:selectedMoreButtonAtIndexPath:withAnswerType:)]) {
        [self.delegate answerForQuestionCellV2:self selectedMoreButtonAtIndexPath:self.path withAnswerType:self.answerModel.answerContentType];
    }
}


///重新赋值
-(void)refreshCellWithAnswerModel:(AnswerModel*)answer{
    if (!answer) {
        return;
    }
    
    self.answerModel = answer;
    QuestionModel *question = (QuestionModel*)answer.questionModel;
    //是否隐藏图标
    if (answer.answerContentType == ReaskType_Answer || answer.answerContentType == ReaskType_ModifyAnswer) {
        [self.flagImageView setHidden:NO];
        self.titleTimeLabel.frame = (CGRect){CGRectGetMaxX(self.flagImageView.frame)+5,CGRectGetMinY(self.titleTimeLabel.frame),self.titleTimeLabel.frame.size};
    }else{
        [self.flagImageView setHidden:YES];
        self.titleTimeLabel.frame = (CGRect){CGRectGetMinX(self.flagImageView.frame)+5,CGRectGetMinY(self.titleTimeLabel.frame),self.titleTimeLabel.frame.size};
    }
    
    //只有最后一个回答才显示多功能按钮
    if (answer.answerContentType == ReaskType_Answer) {
        [self.moreBt setHidden:NO];
        
        if ([[CaiJinTongManager shared].user.userId isEqualToString:question.askerId]) {
             //我的提问
            
        }else{
        //别人的提问
            if ([answer.answerIsPraised isEqualToString:@"1"] && ![[CaiJinTongManager shared].user.userId isEqualToString:answer.answerUserId]) {
                [self.moreBt setHidden:YES];
            }
            if ([[CaiJinTongManager shared].user.userId isEqualToString:answer.answerUserId] && [answer.answerIsCorrect isEqualToString:@"1"]) {
                int index = [question.answerList indexOfObject:answer];
                if (index == question.answerList.count-1 || [(AnswerModel*)[question.answerList objectAtIndex:index+1] answerContentType] == ReaskType_Answer) {
                    //我的回答是正确答案，如果没有回复和追问隐藏
                    [self.moreBt setHidden:YES];
                }
            }
        }
        
    }else{
        [self.moreBt setHidden:YES];
    }
    
    //是否标记为正确答案
    if (answer.answerContentType == ReaskType_Answer || answer.answerContentType == ReaskType_ModifyAnswer) {
        if (answer.answerIsCorrect && [answer.answerIsCorrect isEqualToString:@"1"]) {
            [self.correctFlagImageView setHidden:NO];
        }else{
            [self.correctFlagImageView setHidden:YES];
        }
    }else{
        [self.correctFlagImageView setHidden:YES];
    }
    
    //设置标题
    if (answer.answerContentType == ReaskType_Answer || answer.answerContentType == ReaskType_ModifyAnswer) {
         NSMutableString *titleContent = [NSMutableString stringWithFormat:@"%@ %@",answer.answerUserNick,answer.answerTime];
        if (answer.answerPraiseCount && answer.answerPraiseCount.intValue > 0) {
            [titleContent appendFormat:@" 赞:%@",answer.answerPraiseCount];
        }
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleContent];
        [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attriText.length)];
        [attriText addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0xa1a1a1] range:NSMakeRange(0, attriText.length)];
        [attriText addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0x59a5ee] range:NSMakeRange(0, answer.answerUserNick.length)];
        self.titleTimeLabel.attributedText = attriText;
    }else{
        NSString *tipTitle = nil;
        NSMutableString *titleContent = [NSMutableString stringWithFormat:@"发表于 %@",answer.answerTime];
        if (answer.answerPraiseCount && answer.answerPraiseCount.intValue > 0) {
            [titleContent appendFormat:@" 赞 : %@",answer.answerPraiseCount];
        }
        switch (answer.answerContentType) {
                
            case ReaskType_Reask://追问
            {
                tipTitle = @"追问 : ";
            }
                break;
            case ReaskType_AnswerForReasking://对追问进行回复
            {
                tipTitle = @"回复 : ";
            }
                break;
            case ReaskType_ModifyReask://修改追问
            {
                tipTitle = @"追问 : ";
            }
                break;
                
            case ReaskType_ModifyReaskAnswer://对回复进行修改
            {
                tipTitle = @"回复 : ";
            }
                break;
            default:
                tipTitle = @"";
                break;
        }
        [titleContent insertString:tipTitle atIndex:0];
        NSMutableAttributedString *attriText = [[NSMutableAttributedString alloc] initWithString:titleContent];
        [attriText addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, attriText.length)];
        [attriText addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0xa1a1a1] range:NSMakeRange(0, attriText.length)];
        [attriText addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0xd68a1e] range:NSMakeRange(0, tipTitle.length)];
        self.titleTimeLabel.attributedText = attriText;
    }
    
    //设置回答内容
    __weak AnswerForQuestionCellV2 *weakSelf = self;
    [self.richContentView addContentArray:answer.answerRichContentArray withWidth:260 finished:^(RichContextObj *richContent) {
        AnswerForQuestionCellV2 *tempSelf = weakSelf;
        if (tempSelf) {
            if (tempSelf.delegate && [tempSelf.delegate respondsToSelector:@selector(answerForQuestionCellV2:selectedImageType:AtIndexPath:)]) {
                [tempSelf.delegate answerForQuestionCellV2:tempSelf selectedImageType:richContent AtIndexPath:tempSelf.path];
            }
        }
    }];
}
@end
