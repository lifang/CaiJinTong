//
//  QuestionAndAnswerCell.h
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
@protocol QuestionAndAnswerCellDelegate;

@interface QuestionAndAnswerCell : UITableViewCell<UITextFieldDelegate>
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

- (IBAction)qflowerBtClicked:(id)sender;
- (IBAction)answerBtClicked:(id)sender;
- (IBAction)questionOKBtClicked:(id)sender;

-(void)setAnswerModel:(AnswerModel*)answer isHiddleQuestionView:(BOOL)ishiddle;
@end

@protocol QuestionAndAnswerCellDelegate <NSObject>

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell summitQuestion:(NSString*)questionStr atIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell flowerAnswerAtIndexPath:(NSIndexPath*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath*)path;
@end