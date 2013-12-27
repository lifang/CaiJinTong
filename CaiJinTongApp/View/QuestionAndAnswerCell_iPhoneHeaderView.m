//
//  QuestionAndAnswerCell_iPhoneHeaderView.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionAndAnswerCell_iPhoneHeaderView.h"

@interface QuestionAndAnswerCell_iPhoneHeaderView ()
@property (nonatomic,strong) UILabel *questionNameLabel;
@property (nonatomic,strong) UILabel *questionDateLabel;
@property (nonatomic,strong) UIImageView *questionFlowerImageView;
@property (nonatomic,strong) UILabel *questionFlowerLabel;
@property (nonatomic,strong) UITextView *questionContentTextField;
//@property (nonatomic,strong) UIButton *questionFlowerBt;
@property (nonatomic,strong) UIView *backgroundView;
@property (nonatomic,strong) UIImageView *questionImg;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *answerQuestionBt;//回答按钮
@property (nonatomic,strong) UIView *summitQuestionAnswerBackView;
@property (nonatomic,strong) UITextView *answerQuestionTextField;//回答输入框
@property (nonatomic,strong) UIButton *submitAnswerBt;//提交回答
@end

@implementation QuestionAndAnswerCell_iPhoneHeaderView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        self.backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.backgroundView];
        
        self.questionNameLabel = [[UILabel alloc] init];
        self.questionNameLabel.backgroundColor = [UIColor clearColor];
        self.questionNameLabel.font = TEXT_FONT;
        self.questionNameLabel.textColor = [UIColor blackColor];
        self.questionNameLabel.textAlignment = NSTextAlignmentLeft;
        self.questionNameLabel.textColor = [UIColor darkGrayColor];
        [self.backgroundView addSubview:self.questionNameLabel];
        
        self.questionDateLabel = [[UILabel alloc] init];
        self.questionDateLabel.backgroundColor = [UIColor clearColor];
        self.questionDateLabel.font = TEXT_FONT;
        self.questionDateLabel.textColor = [UIColor blackColor];
        self.questionDateLabel.textAlignment = NSTextAlignmentLeft;
        self.questionDateLabel.textColor = [UIColor darkGrayColor];
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
        self.questionFlowerLabel.textColor = [UIColor darkGrayColor];
        [self.backgroundView addSubview:self.questionFlowerLabel];
        
        self.questionContentTextField = [[UITextView alloc] init];
        self.questionContentTextField.backgroundColor = [UIColor clearColor];
        self.questionContentTextField.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE+4];
        self.questionContentTextField.textColor = [UIColor blueColor];
        self.questionContentTextField.textAlignment = NSTextAlignmentLeft;
        [self.questionContentTextField setUserInteractionEnabled:NO];
        self.questionContentTextField.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
        //        self.questionContentTextField.textColor = [UIColor darkGrayColor];
        [self.backgroundView addSubview:self.questionContentTextField];
        
        self.questionImg = [[UIImageView alloc] init];
        self.questionImg.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
        self.questionImg.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.questionImg];
        
        
        self.answerQuestionBt = [[UIButton alloc] init];
        self.answerQuestionBt.backgroundColor = [UIColor clearColor];
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
        self.answerQuestionTextField.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
        self.answerQuestionTextField.layer.borderWidth = 0.5;
        self.answerQuestionTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        [self.answerQuestionTextField.layer setCornerRadius:4.0];
        self.answerQuestionTextField.delegate = self;
        [self.summitQuestionAnswerBackView addSubview:self.answerQuestionTextField];
        
        self.submitAnswerBt = [[UIButton alloc] init];
        [self.submitAnswerBt setBackgroundImage:[UIImage imageNamed:@"btn0@2x.png"] forState:UIControlStateNormal];
        [self.submitAnswerBt addTarget:self action:@selector(submitQuestionAnswetBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.submitAnswerBt.titleLabel setFont:[UIFont boldSystemFontOfSize:12.0]];
        [self.submitAnswerBt setTitle:@"确认回答" forState:UIControlStateNormal];
        [self.summitQuestionAnswerBackView addSubview:self.submitAnswerBt];
    }
    return self;
}

-(void)flowerBtClicked{
    //    int flower = [self.questionFlowerLabel.text intValue];
    //    self.questionFlowerLabel.text = [NSString stringWithFormat:@"%d",flower+1];
    //     [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:flowerQuestionAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self flowerQuestionAtIndexPath:self.path];
    }
}

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:willBeginTypeAnswerQuestionAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self willBeginTypeAnswerQuestionAtIndexPath:self.path];
    }
}
#pragma mark --

-(void)willAnswerQuestionBtClicked{
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:willAnswerQuestionAtIndexPath:)]) {
        [self.answerQuestionBt setUserInteractionEnabled:NO];
        [self.summitQuestionAnswerBackView setHidden:NO];
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self willAnswerQuestionAtIndexPath:self.path];
    }
}

-(void)submitQuestionAnswetBtClicked{
    if (!self.answerQuestionTextField.text || [[self.answerQuestionTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"回答内容不能为空"];
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:didAnswerQuestionAtIndexPath:withAnswer:)]) {
        [self.answerQuestionBt setUserInteractionEnabled:YES];
        [self.summitQuestionAnswerBackView setHidden:YES];
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self didAnswerQuestionAtIndexPath:self.path withAnswer:self.answerQuestionTextField.text];
    }
}

-(void)setQuestionModel:(QuestionModel*)question withQuestionAndAnswerScope:(QuestionAndAnswerScope)scope{
    if (!question) {
        return;
    }
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
    self.questionFlowerLabel.text = question.praiseCount.length > 0 ? question.praiseCount : @"0";
    self.questionContentTextField.text = question.questionName;
    //    [self.questionFlowerBt setUserInteractionEnabled:NO];
    [self.summitQuestionAnswerBackView setHidden:!question.isEditing];
    [self setNeedsLayout];
}

-(void)layoutSubviews{
    self.backgroundView.frame = self.bounds;
    
    self.lineView.frame = (CGRect){TEXT_PADDING*2,0,QUESTIONHEARD_VIEW_WIDTH,1};
    
    //第一行
    float topY = 5;
    float textHeight = HEADER_TEXT_HEIGHT-10;
    self.questionNameLabel.frame = (CGRect){0,topY,[Utility getTextSizeWithString:self.questionNameLabel.text withFont:self.questionNameLabel.font].width,textHeight};
    self.questionDateLabel.frame = (CGRect){CGRectGetMaxX(self.questionNameLabel.frame)+TEXT_PADDING,topY,[Utility getTextSizeWithString:self.questionDateLabel.text withFont:self.questionNameLabel.font].width,textHeight};
    
    self.questionFlowerImageView.frame = (CGRect){CGRectGetMaxX(self.questionDateLabel.frame)+TEXT_PADDING,topY,HEADER_TEXT_HEIGHT/2,HEADER_TEXT_HEIGHT/2};
    
    self.questionFlowerLabel.frame = (CGRect){CGRectGetMaxX(self.questionFlowerImageView.frame)+TEXT_PADDING,topY,[Utility getTextSizeWithString:self.questionFlowerLabel.text withFont:self.questionFlowerLabel.font].width,textHeight};
    
    
//    self.answerQuestionBt.frame = (CGRect){CGRectGetMaxX(self.questionFlowerLabel.frame),2,100,HEADER_TEXT_HEIGHT};
    
    //第二行,问题
    self.questionImg.frame = (CGRect){0,HEADER_TEXT_HEIGHT+2,14,14};
    self.questionContentTextField.frame = (CGRect){CGRectGetMaxX(self.questionImg.frame),HEADER_TEXT_HEIGHT,QUESTIONHEARD_VIEW_WIDTH+TEXT_PADDING*2,[Utility getTextSizeWithString:self.questionContentTextField.text withFont:self.questionContentTextField.font withWidth:QUESTIONHEARD_VIEW_WIDTH + TEXT_PADDING * 2].height};
    
    self.answerQuestionBt.frame = self.questionContentTextField.frame;
    [self bringSubviewToFront:self.answerQuestionBt];
    //回答
    if (!self.summitQuestionAnswerBackView.isHidden) {
        self.summitQuestionAnswerBackView.frame = (CGRect){TEXT_PADDING*2,CGRectGetMaxY(self.questionContentTextField.frame)+TEXT_PADDING,QUESTIONHEARD_VIEW_WIDTH,QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT - TEXT_PADDING};
        self.answerQuestionTextField.frame = (CGRect){0,0,QUESTIONHEARD_VIEW_WIDTH,60};
        self.submitAnswerBt.frame = (CGRect){QUESTIONHEARD_VIEW_WIDTH-105,65,95,27};
    }
}
@end
