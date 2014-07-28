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
//@property (nonatomic,strong) UITextView *questionContentTextField;
//@property (nonatomic,strong) UIButton *questionFlowerBt;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIImageView *questionImg;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *answerQuestionBt;//回答按钮
@property (nonatomic,strong) UIView *summitQuestionAnswerBackView;

@property (nonatomic,strong) UIButton *submitAnswerBt;//提交回答
@property (nonatomic,strong) UIButton *attachmentButton;//附件
@property (nonatomic,strong) QuestionModel *questionModel;
@end

@implementation QuestionAndAnswerCellHeaderView
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        self.questionNameLabel = [[UILabel alloc] init];
        self.questionNameLabel.backgroundColor = [UIColor clearColor];
        self.questionNameLabel.font = TEXT_FONT;
        self.questionNameLabel.textAlignment = NSTextAlignmentLeft;
        self.questionNameLabel.textColor = [UIColor colorWithRed:0.349 green:0.647 blue:0.933 alpha:1.000];
        [self.backgroundView addSubview:self.questionNameLabel];
        
        self.questionDateLabel = [[UILabel alloc] init];
        self.questionDateLabel.backgroundColor = [UIColor clearColor];
        self.questionDateLabel.font = TEXT_FONT;
        self.questionDateLabel.textColor = [UIColor blackColor];
        self.questionDateLabel.textAlignment = NSTextAlignmentLeft;
        self.questionDateLabel.textColor = [UIColor colorWithWhite:0.631 alpha:1.000];
        [self.backgroundView addSubview:self.questionDateLabel];
        
        self.questionFlowerImageView = [[UIImageView alloc] init];
        self.questionFlowerImageView.image = [UIImage imageNamed:@"mail_n.png"];
        self.questionFlowerImageView.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.questionFlowerImageView];
        
        self.questionFlowerLabel = [[UILabel alloc] init];
        self.questionFlowerLabel.backgroundColor = [UIColor clearColor];
        self.questionFlowerLabel.font = TEXT_FONT;
        self.questionFlowerLabel.textColor = [UIColor blackColor];
        self.questionFlowerLabel.textAlignment = NSTextAlignmentLeft;
        self.questionFlowerLabel.textColor = [UIColor colorWithWhite:0.631 alpha:1.000];
        [self.backgroundView addSubview:self.questionFlowerLabel];
        
        self.attachmentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.attachmentButton setTitle:@"点击查看附件" forState:UIControlStateNormal];
        [self.attachmentButton addTarget:self action:@selector(scanQuestionAttachmentBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.attachmentButton];
        
        self.questionContentAttributeView = [[DRAttributeStringView alloc] init];
        [self.backgroundView addSubview:self.questionContentAttributeView];

        
        self.questionImg = [[UIImageView alloc] init];
        self.questionImg.image = [UIImage imageNamed:@"question_n.png"];
        self.questionImg.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.questionImg];
        
        
        self.answerQuestionBt = [[UIButton alloc] init];
        self.answerQuestionBt.backgroundColor = [UIColor colorWithRed:154./255. green:196./255. blue:240./255. alpha:1.0];
        self.answerQuestionBt.layer.borderColor = [UIColor colorWithRed:0.406 green:0.640 blue:0.916 alpha:1.000].CGColor;
        self.answerQuestionBt.layer.borderWidth = 0.8;
        self.answerQuestionBt.layer.cornerRadius = 5.;
        [self.answerQuestionBt setTitle:@"回 答" forState:UIControlStateNormal];
        [self.answerQuestionBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.answerQuestionBt.titleLabel setFont:BUTTON_TITLE_FONT];
        [self.answerQuestionBt addTarget:self action:@selector(willAnswerQuestionBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView addSubview:self.answerQuestionBt];
        
        self.lineView = [[UIView alloc] init];
        self.lineView.backgroundColor = [UIColor darkGrayColor];
        [self.backgroundView addSubview:self.lineView];
        
        self.summitQuestionAnswerBackView = [[UIView alloc] init];
        self.summitQuestionAnswerBackView.backgroundColor = [UIColor clearColor];
        //         [self.summitQuestionAnswerBackView setHidden:YES];
        [self.backgroundView addSubview:self.summitQuestionAnswerBackView];
        
        self.answerQuestionTextField = [[UITextView alloc] init];
        self.answerQuestionTextField.backgroundColor = [UIColor whiteColor];
        self.answerQuestionTextField.layer.borderWidth = 1;
        self.answerQuestionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.answerQuestionTextField.delegate = self;
        [self.summitQuestionAnswerBackView addSubview:self.answerQuestionTextField];
        
        self.submitAnswerBt = [[UIButton alloc] init];
        [self.submitAnswerBt setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
        [self.submitAnswerBt addTarget:self action:@selector(submitQuestionAnswetBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.submitAnswerBt setTitle:@"提交回答" forState:UIControlStateNormal];
        [self.summitQuestionAnswerBackView addSubview:self.submitAnswerBt];
        
//        self.scanMoreBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [self.scanMoreBt setTitle:@"点击显示更多..." forState:UIControlStateNormal];
//        [self.scanMoreBt setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
//        //        [self.scanMoreBt setBackgroundColor:[UIColor clearColor]];
//        [self.scanMoreBt addTarget:self action:@selector(scanQuestionContentBtClicked) forControlEvents:UIControlEventTouchUpInside];
////        [self.backgroundView addSubview:self.scanMoreBt];
    }
    return self;
}

-(void)scanQuestionAttachmentBtClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCellHeaderView:scanAttachmentFileAtIndexPath:)]) {
        [self.delegate questionAndAnswerCellHeaderView:self scanAttachmentFileAtIndexPath:self.path];
    }
}

-(void)flowerBtClicked{
//    int flower = [self.questionFlowerLabel.text intValue];
//    self.questionFlowerLabel.text = [NSString stringWithFormat:@"%d",flower+1];
//     [self setNeedsLayout];
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

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCellHeaderView:willBeginTypeAnswerQuestionAtIndexPath:)]) {
        [self.delegate questionAndAnswerCellHeaderView:self willBeginTypeAnswerQuestionAtIndexPath:self.path];
    }
}
#pragma mark --

-(void)willAnswerQuestionBtClicked{
    self.answerQuestionTextField.text = @"";
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCellHeaderView:willAnswerQuestionAtIndexPath:)]) {
//        [self.answerQuestionBt setUserInteractionEnabled:NO];
        if (!self.questionModel.isEditing) {
            [self.answerQuestionTextField resignFirstResponder];
            [self.summitQuestionAnswerBackView setHidden:YES];
        }
        [self.delegate questionAndAnswerCellHeaderView:self willAnswerQuestionAtIndexPath:self.path];
        if (self.questionModel.isEditing) {
//            [self.answerQuestionTextField becomeFirstResponder];
            [self.summitQuestionAnswerBackView setHidden:NO];
        }
    }
}

-(void)submitQuestionAnswetBtClicked{
    if (!self.answerQuestionTextField.text || [[self.answerQuestionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"回答内容不能为空"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCellHeaderView:didAnswerQuestionAtIndexPath:withAnswer:)]) {
        [self.answerQuestionBt setUserInteractionEnabled:YES];
        [self.summitQuestionAnswerBackView setHidden:YES];
        [self.delegate questionAndAnswerCellHeaderView:self didAnswerQuestionAtIndexPath:self.path withAnswer:self.answerQuestionTextField.text];
    }
}

-(void)setQuestionModel:(QuestionModel*)question withQuestionAndAnswerScope:(QuestionAndAnswerScope)scope{
    if (!question) {
        return;
    }
    self.questionModel = question;
    UserModel *user = [[CaiJinTongManager shared]user];
    if (question.askerId && [question.askerId isEqualToString:user.userId]) {
        [self.answerQuestionBt setHidden:YES];
    }else{
        [self.answerQuestionBt setHidden:NO];
    }
    for (AnswerModel *answer in question.answerList) {
        if ([answer.answerId isEqualToString:user.userId]) {
            [self.answerQuestionBt setHidden:YES];
            break;
        }
    }
    self.questionNameLabel.text = question.askerNick;
    self.questionDateLabel.text = [NSString stringWithFormat:@"发表于%@",question.askTime];

    self.questionFlowerLabel.text = question.answerList?[NSString stringWithFormat:@"回复: %d",question.answerList.count]:@"回复: 0";

    self.questionContentAttributeView.isTruncate = NO;
    self.questionContentAttributeView.questionModel = question;

    [self.summitQuestionAnswerBackView setHidden:!question.isEditing];
    
    if (!question.attachmentFileUrl || [question.attachmentFileUrl isEqualToString:@""] || ![question.attachmentFileUrl pathExtension] || [[question.attachmentFileUrl pathExtension] isEqualToString:@""]) {
        [self.attachmentButton setHidden:YES];
    }else{
        [self.attachmentButton setHidden:NO];
    }
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    self.backgroundView.frame = self.bounds;
    
    self.lineView.frame = (CGRect){TEXT_PADDING*2,0,QUESTIONHEARD_VIEW_WIDTH,1};
    float topY = 10;
    float textHeight = HEADER_TEXT_HEIGHT-10;
    self.questionNameLabel.frame = (CGRect){TEXT_PADDING*2,topY,[Utility getTextSizeWithString:self.questionNameLabel.text withFont:self.questionNameLabel.font].width,textHeight};
    self.questionDateLabel.frame = (CGRect){CGRectGetMaxX(self.questionNameLabel.frame)+TEXT_PADDING,topY,[Utility getTextSizeWithString:self.questionDateLabel.text withFont:self.questionNameLabel.font].width,textHeight};
    
    self.questionFlowerImageView.frame = (CGRect){CGRectGetMaxX(self.questionDateLabel.frame)+TEXT_PADDING,topY + 8,HEADER_TEXT_HEIGHT/2,HEADER_TEXT_HEIGHT/3};
    
    self.questionFlowerLabel.frame = (CGRect){CGRectGetMaxX(self.questionFlowerImageView.frame)+TEXT_PADDING,topY,[Utility getTextSizeWithString:self.questionFlowerLabel.text withFont:self.questionFlowerLabel.font].width,textHeight};

    self.answerQuestionBt.frame = (CGRect){self.frame.size.width - 100 - 25,5,100,HEADER_TEXT_HEIGHT - 2};
    
    self.attachmentButton.frame = (CGRect){CGRectGetMinX(self.answerQuestionBt.frame) - 100 - TEXT_PADDING,5,100,HEADER_TEXT_HEIGHT};
    self.questionImg.frame = (CGRect){TEXT_PADDING,HEADER_TEXT_HEIGHT,25,25};
    float height = [self.delegate questionAndAnswerCellHeaderView:self headerHeightAtIndexPath:self.path];

    self.questionContentAttributeView.frame = (CGRect){CGRectGetMaxX(self.questionImg.frame) + 2,HEADER_TEXT_HEIGHT,QUESTIONHEARD_VIEW_WIDTH,height};
    if (!self.summitQuestionAnswerBackView.isHidden) {
        self.summitQuestionAnswerBackView.frame = (CGRect){TEXT_PADDING*2,CGRectGetMaxY(self.questionContentAttributeView.frame)+TEXT_PADDING,QUESTIONHEARD_VIEW_WIDTH,QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT-TEXT_PADDING};
        self.answerQuestionTextField.frame = (CGRect){0,0,QUESTIONHEARD_VIEW_WIDTH,80};
        self.submitAnswerBt.frame = (CGRect){QUESTIONHEARD_VIEW_WIDTH/2-50,90,100,30};
    }
}
@end
