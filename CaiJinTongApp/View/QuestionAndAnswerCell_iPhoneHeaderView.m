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
        self.questionContentTextField.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE+6];
        self.questionContentTextField.textColor = [UIColor blueColor];
        self.questionContentTextField.textAlignment = NSTextAlignmentLeft;
        [self.questionContentTextField setUserInteractionEnabled:NO];
        self.questionContentTextField.contentInset = UIEdgeInsetsMake(-10,-5,0,0);
        //        self.questionContentTextField.textColor = [UIColor darkGrayColor];
        [self.backgroundView addSubview:self.questionContentTextField];
        
        //        self.questionFlowerBt = [[UIButton alloc] init];
        //        self.questionFlowerBt.backgroundColor = [UIColor clearColor];
        //        [self.questionFlowerBt addTarget:self action:@selector(flowerBtClicked) forControlEvents:UIControlEventTouchUpInside];
        //        [self.backgroundView addSubview:self.questionFlowerBt];
        
        self.questionImg = [[UIImageView alloc] init];
        self.questionImg.image = [UIImage imageNamed:@"Q&A-myq_15.png"];
        self.questionImg.backgroundColor = [UIColor clearColor];
        [self.backgroundView addSubview:self.questionImg];
        
        self.backgroundView.backgroundColor = [UIColor clearColor];
        
        self.answerQuestionBt = [[UIButton alloc] init];
        self.answerQuestionBt.backgroundColor = [UIColor clearColor];
        [self.answerQuestionBt setTitle:@"回答" forState:UIControlStateNormal];
        [self.answerQuestionBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [self.answerQuestionBt.titleLabel setFont:TEXT_FONT];
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
        [self.submitAnswerBt setBackgroundImage:[UIImage imageNamed:@"btn0@2x.png"] forState:UIControlStateNormal];
        [self.submitAnswerBt addTarget:self action:@selector(submitQuestionAnswetBtClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.submitAnswerBt setTitle:@"提交回答" forState:UIControlStateNormal];
        [self.summitQuestionAnswerBackView addSubview:self.submitAnswerBt];
    }
    return self;
}

-(void)flowerBtClicked{
    int flower = [self.questionFlowerLabel.text intValue];
    self.questionFlowerLabel.text = [NSString stringWithFormat:@"%d",flower+1];
    [self setNeedsLayout];
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:flowerQuestionAtIndexPath:)]) {
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self flowerQuestionAtIndexPath:self.path];
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(questionAndAnswerCell_iPhoneHeaderView:didAnswerQuestionAtIndexPath:withAnswer:)]) {
        [self.answerQuestionBt setUserInteractionEnabled:YES];
        [self.summitQuestionAnswerBackView setHidden:YES];
        [self.delegate questionAndAnswerCell_iPhoneHeaderView:self didAnswerQuestionAtIndexPath:self.path withAnswer:self.answerQuestionTextField.text];
    }
}

-(void)setQuestionModel:(QuestionModel*)question{
    if (!question) {
        return;
    }
    self.questionNameLabel.text = question.askerNick;
    self.questionDateLabel.text = [NSString stringWithFormat:@"发表于%@",question.askTime];
    self.questionFlowerLabel.text = question.praiseCount;
    self.questionContentTextField.text = question.questionName;
    //    [self.questionFlowerBt setUserInteractionEnabled:NO];
    [self.summitQuestionAnswerBackView setHidden:!question.isEditing];
    if ([[CaiJinTongManager shared] userId] && [[[CaiJinTongManager shared] userId] isEqualToString:question.askerId]) {
        [self.submitAnswerBt setHidden:YES];
    }else{
        [self.submitAnswerBt setHidden:NO];
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
    
    self.questionFlowerImageView.frame = (CGRect){CGRectGetMaxX(self.questionDateLabel.frame)+TEXT_PADDING,topY,HEADER_TEXT_HEIGHT/2,HEADER_TEXT_HEIGHT/2};
    
    self.questionFlowerLabel.frame = (CGRect){CGRectGetMaxX(self.questionFlowerImageView.frame)+TEXT_PADDING,topY,[Utility getTextSizeWithString:self.questionFlowerLabel.text withFont:self.questionFlowerLabel.font].width,textHeight};
    
    //    self.questionFlowerBt.frame = (CGRect){CGRectGetMinX(self.questionFlowerImageView.frame)-TEXT_PADDING*5,topY,CGRectGetMaxX(self.questionFlowerLabel.frame) -CGRectGetMinX(self.questionFlowerImageView.frame) +50,textHeight};
    
    self.answerQuestionBt.frame = (CGRect){CGRectGetMaxX(self.questionFlowerLabel.frame),5,100,HEADER_TEXT_HEIGHT};
    
    self.questionImg.frame = (CGRect){TEXT_PADDING*2+2,HEADER_TEXT_HEIGHT+2,20,20};
    //    float contentWidth = CGRectGetWidth(self.frame)-CGRectGetMaxX(self.questionImg.frame)-TEXT_PADDING*2;
    self.questionContentTextField.frame = (CGRect){CGRectGetMaxX(self.questionImg.frame),HEADER_TEXT_HEIGHT,QUESTIONHEARD_VIEW_WIDTH,[Utility getTextSizeWithString:self.questionContentTextField.text withFont:self.questionContentTextField.font withWidth:QUESTIONHEARD_VIEW_WIDTH].height};
    
    if (!self.summitQuestionAnswerBackView.isHidden) {
        self.summitQuestionAnswerBackView.frame = (CGRect){TEXT_PADDING*2,CGRectGetMaxY(self.questionContentTextField.frame)+TEXT_PADDING,QUESTIONHEARD_VIEW_WIDTH,QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT-TEXT_PADDING};
        self.answerQuestionTextField.frame = (CGRect){0,0,QUESTIONHEARD_VIEW_WIDTH,80};
        self.submitAnswerBt.frame = (CGRect){QUESTIONHEARD_VIEW_WIDTH/2-50,90,100,30};
    }
}
@end