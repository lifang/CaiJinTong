//
//  QuestionAndAnswerCellHeaderView.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
#import "DRAttributeStringView.h"
#define TEXT_FONT_SIZE 14
#define TEXT_FONT [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define TEXT_PADDING 10
#define HEADER_TEXT_HEIGHT 40
#define QUESTIONHEARD_VIEW_WIDTH  650
#define QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT 141
#define ContentMinHeight 210
@protocol QuestionAndAnswerCellHeaderViewDelegate;
@interface QuestionAndAnswerCellHeaderView : UITableViewCell<UITextViewDelegate>
@property (strong,nonatomic) NSIndexPath *path;
@property (nonatomic,strong) DRAttributeStringView *questionContentAttributeView;
@property (weak,nonatomic) id <QuestionAndAnswerCellHeaderViewDelegate> delegate;
@property (assign,nonatomic) QuestionAndAnswerScope *scope;//判断是回答还是追问
-(void)setQuestionModel:(QuestionModel*)question withQuestionAndAnswerScope:(QuestionAndAnswerScope)scope;
@end

@protocol QuestionAndAnswerCellHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header willAnswerQuestionAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header didAnswerQuestionAtIndexPath:(NSIndexPath*)path withAnswer:(NSString*)text;

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath*)path;

-(float)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header headerHeightAtIndexPath:(NSIndexPath*)path;
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header scanAttachmentFileAtIndexPath:(NSIndexPath*)path;
@end