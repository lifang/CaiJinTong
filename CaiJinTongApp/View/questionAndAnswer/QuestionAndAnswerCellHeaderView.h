//
//  QuestionAndAnswerCellHeaderView.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
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
@protocol QuestionAndAnswerCellHeaderViewDelegate;
@interface QuestionAndAnswerCellHeaderView : UITableViewHeaderFooterView<UITextViewDelegate>
@property (strong,nonatomic) NSIndexPath *path;
@property (weak,nonatomic) id <QuestionAndAnswerCellHeaderViewDelegate> delegate;
@property (assign,nonatomic) QuestionAndAnswerScope *scope;//判断是回答还是追问
-(void)setQuestionModel:(QuestionModel*)question withQuestionAndAnswerScope:(QuestionAndAnswerScope)scope;
@end

@protocol QuestionAndAnswerCellHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header willAnswerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header didAnswerQuestionAtIndexPath:(NSIndexPath*)path withAnswer:(NSString*)text;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath*)path;
@end