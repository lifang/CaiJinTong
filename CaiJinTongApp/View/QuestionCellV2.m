//
//  QuestionCellV2.m
//  CaiJinTongApp
//
//  Created by david on 14-4-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "QuestionCellV2.h"

@implementation QuestionCellV2

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

- (IBAction)extendAnswerListBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionCellV2:extendAnswerContentButtonAtIndexPath:)]) {
        [self.delegate questionCellV2:self extendAnswerContentButtonAtIndexPath:self.path];
    }
}

- (IBAction)attachmentBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionCellV2:viewAttachmentButtonAtIndexPath:)]) {
        [self.delegate questionCellV2:self viewAttachmentButtonAtIndexPath:self.path];
    }
}

- (IBAction)questionEditBtClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionCellV2:selectedMenuButtonAtIndexPath:)]) {
        [self.delegate questionCellV2:self selectedMenuButtonAtIndexPath:self.path];
    }
}

-(void)refreshCellWithQuestionModel:(QuestionModel*)question{
    
    if (!question) {
        return;
    }
    
    self.questionModel = question;
    //设置标题
    self.questionTitleLabel.text = question.questiontitle;
    
    //设置内容
    __weak QuestionCellV2 *weakCell = self;
    [self.questionRichContentview addContentArray:question.questionRichContentArray withWidth:260 finished:^(RichContextObj *richContent) {
        QuestionCellV2 *tempCell = weakCell;
        if (tempCell) {
            if (tempCell.delegate && [tempCell.delegate respondsToSelector:@selector(questionCellV2:selectedImageType:AtIndexPath:)]) {
                [tempCell.delegate questionCellV2:tempCell selectedImageType:richContent AtIndexPath:tempCell.path];
            }
        }
    } ];
    
    //是否隐藏多功能按钮
    if ([[CaiJinTongManager shared].user.userId isEqualToString:question.askerId]) {
        [self.questionBt setHidden:YES];
    }else{
        [self.questionBt setHidden:NO];
    }
    //设置时间
    self.questionTimeLabel.text = @"";
    NSMutableString *timeString = [NSMutableString stringWithFormat:@"%@ %@",question.askerNick?:@"",question.askTime?:@""];
    if (question.praiseCount && question.praiseCount.intValue > 0) {
        [timeString appendFormat:@" 赞 : %@",question.praiseCount];
    }
    
    NSMutableAttributedString *timeAttriString = [[NSMutableAttributedString alloc] initWithString:timeString];
    [timeAttriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, timeAttriString.length)];
    [timeAttriString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0xa1a1a1] range:NSMakeRange(0, timeAttriString.length)];
    [timeAttriString addAttribute:NSForegroundColorAttributeName value:[Utility colorWithHex:0x59a5ee] range:NSMakeRange(0, question.askerNick.length)];
    self.questionTimeLabel.attributedText = timeAttriString;
    
    //设置回复个数
    self.quesstionAnswerCountLabel.text = [NSString stringWithFormat:@"回复:%d",question.answerList?question.answerList.count:0];
    
    //是否有附件
    if (question.attachmentFileUrl && ![question.attachmentFileUrl isEqualToString:@""]) {
        [self.attachmentBt setHidden:NO];
    }else{
        [self.attachmentBt setHidden:YES];
    }
}
@end
