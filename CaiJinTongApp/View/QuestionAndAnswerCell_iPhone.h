//
//  QuestionAndAnswerCell_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnswerModel.h"
#import "DRAttributeStringView.h"
//#define TEXT_FONT_SIZE 10
//#define TEXT_FONT [UIFont systemFontOfSize:TEXT_FONT_SIZE]
#define lTEXT_PADDING 5
#define lTEXT_HEIGHT 30
#define  lQUESTIONANDANSWER_CELL_WIDTH 265
@protocol QuestionAndAnswerCell_iPhoneDelegate;
@interface QuestionAndAnswerCell_iPhone : UITableViewCell<UITextViewDelegate>
@property (weak,nonatomic) IBOutlet id<QuestionAndAnswerCell_iPhoneDelegate> delegate;
@property (strong,nonatomic) NSIndexPath *path;

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;

@property (weak, nonatomic) IBOutlet UILabel *qTitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *qflowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qflowerImageView;
@property (weak, nonatomic) IBOutlet UIButton *qflowerBt;
@property (weak, nonatomic) IBOutlet UITextView *questionTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptAnswerBt;
@property (weak, nonatomic) IBOutlet UIButton *answerBt;
@property (weak, nonatomic) IBOutlet UIButton *reaskBt;//追问
@property (weak, nonatomic) IBOutlet DRAttributeStringView *answerAttributeTextView;
@property (assign,nonatomic) ReaskType reaskType;
- (IBAction)qflowerBtClicked:(id)sender;
- (IBAction)answerBtClicked:(id)sender;
- (IBAction)questionOKBtClicked:(id)sender;
- (IBAction)acceptAnswerBtClicked:(id)sender;

-(void)setAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question;
@end

@protocol QuestionAndAnswerCell_iPhoneDelegate <NSObject>

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell summitQuestion:(NSString*)questionStr atIndexPath:(NSIndexPath*)path withReaskType:(ReaskType)reaskType;

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell flowerAnswerAtIndexPath:(NSIndexPath*)path;

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell acceptAnswerAtIndexPath:(NSIndexPath*)path;

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell  isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath*)path;

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell  willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath*)path;
-(float)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone*)cell  getCellheightAtIndexPath:(NSIndexPath*)path;
@end