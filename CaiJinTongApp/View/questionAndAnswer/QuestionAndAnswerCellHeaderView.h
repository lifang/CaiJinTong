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
#define TEXT_HEIGHT 40
#define QUESTIONHEARD_VIEW_WIDTH  506
@protocol QuestionAndAnswerCellHeaderViewDelegate;
@interface QuestionAndAnswerCellHeaderView : UITableViewHeaderFooterView
@property (strong,nonatomic) NSIndexPath *path;
@property (weak,nonatomic) id <QuestionAndAnswerCellHeaderViewDelegate> delegate;
-(void)setQuestionModel:(QuestionModel*)question;
@end

@protocol QuestionAndAnswerCellHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

@end