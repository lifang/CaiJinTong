//
//  QuestionAndAnswerCell_iPhoneHeaderView.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-9.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#define TEXT_FONT_SIZE 14
#define TEXT_FONT [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define TEXT_PADDING 10
#define HEADER_TEXT_HEIGHT 40
#define QUESTIONHEARD_VIEW_WIDTH  506
#define QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT 141
@protocol QuestionAndAnswerCell_iPhoneHeaderViewDelegate;
@interface QuestionAndAnswerCell_iPhoneHeaderView : UITableViewHeaderFooterView<UITextViewDelegate>
@property (strong,nonatomic) NSIndexPath *path;
@property (weak,nonatomic) id <QuestionAndAnswerCell_iPhoneHeaderViewDelegate> delegate;
-(void)setQuestionModel:(QuestionModel*)question;
@end

@protocol QuestionAndAnswerCell_iPhoneHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header willAnswerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header didAnswerQuestionAtIndexPath:(NSIndexPath*)path withAnswer:(NSString*)text;

-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView*)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath*)path;
@end