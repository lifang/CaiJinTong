//
//  QuestionAndAnswerCell.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
#define TEXT_FONT_SIZE 14
#define TEXT_FONT [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define TEXT_PADDING 10
#define TEXT_HEIGHT 30
#define  QUESTIONANDANSWER_CELL_WIDTH 460
@protocol QuestionAndAnswerCellDelegate;

@interface QuestionAndAnswerCell : UITableViewCell<UITextViewDelegate>
@property (weak,nonatomic) IBOutlet id<QuestionAndAnswerCellDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;

@property (weak, nonatomic) IBOutlet UIView *answerBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *qTitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *qflowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qflowerImageView;
@property (weak, nonatomic) IBOutlet UIButton *qflowerBt;
@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptAnswerBt;

- (IBAction)qflowerBtClicked:(id)sender;
- (IBAction)answerBtClicked:(id)sender;
- (IBAction)questionOKBtClicked:(id)sender;
- (IBAction)acceptAnswerBtClicked:(id)sender;

-(void)setAnswerModel:(AnswerModel*)answer isQuestionID:(NSString*)questionID;
@end

@protocol QuestionAndAnswerCellDelegate <NSObject>

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell summitQuestion:(NSString*)questionStr atIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell flowerAnswerAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell acceptAnswerAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath*)path;
@end