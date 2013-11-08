//
//  QuestionAndAnswerCellHeaderView.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
@protocol QuestionAndAnswerCellHeaderViewDelegate;
@interface QuestionAndAnswerCellHeaderView : UITableViewHeaderFooterView
@property (strong,nonatomic) NSIndexPath *path;
@property (weak,nonatomic) id <QuestionAndAnswerCellHeaderViewDelegate> delegate;
-(void)setQuestionModel:(QuestionModel*)question;
@end

@protocol QuestionAndAnswerCellHeaderViewDelegate <NSObject>

-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView*)header flowerQuestionAtIndexPath:(NSIndexPath*)path;

@end