//
//  QuestionAndAnswerCell_iPhoneHeaderView.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#define TEXT_FONT_SIZE 12
#define TEXT_FONT [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define TEXT_PADDING 5
#define HEADER_TEXT_HEIGHT 28
#define QUESTIONHEARD_VIEW_WIDTH 271
#define QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT 97
@protocol QuestionAndAnswerCell_iPhoneHeaderViewDelegate;
@interface QuestionAndAnswerCell_iPhoneHeaderView : UITableViewCell<UITextViewDelegate>
@property (strong,nonatomic) NSIndexPath *path;
@property (weak,nonatomic) id <QuestionAndAnswerCell_iPhoneHeaderViewDelegate> delegate;
@property (assign,nonatomic) QuestionAndAnswerScope *scope;//判断是回答还是追问
-(void)setQuestionModel:(QuestionModel*)question withQuestionAndAnswerScope:(QuestionAndAnswerScope)scope;
@end

@protocol QuestionAndAnswerCell_iPhoneHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header willAnswerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header didAnswerQuestionAtIndexPath:(NSIndexPath*)path withAnswer:(NSString*)text;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath*)path;
@end