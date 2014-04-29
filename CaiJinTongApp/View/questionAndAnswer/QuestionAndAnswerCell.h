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
#define  QUESTIONANDANSWER_CELL_WIDTH 600
#import "DRAttributeStringView.h"
#import "IndexPathModel.h"
@protocol QuestionAndAnswerCellDelegate;
@interface QuestionAndAnswerCell : UITableViewCell<UITextViewDelegate>
@property (weak,nonatomic) IBOutlet id<QuestionAndAnswerCellDelegate> delegate;
@property (strong,nonatomic) IndexPathModel *path;

@property (weak, nonatomic) IBOutlet UIView *questionBackgroundView;
@property (weak, nonatomic) IBOutlet DRAttributeStringView *answerAttributeTextView;

@property (weak, nonatomic) IBOutlet UIImageView *qTitleNameImageView;
@property (weak, nonatomic) IBOutlet UILabel *qTitleNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *qDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *qflowerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qflowerImageView;
@property (weak, nonatomic) IBOutlet UIButton *qflowerBt;
//@property (weak, nonatomic) IBOutlet UITextView *answerTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionTextField;
@property (weak, nonatomic) IBOutlet UIButton *acceptAnswerBt;
@property (weak, nonatomic) IBOutlet UIButton *answerBt;
@property (weak, nonatomic) IBOutlet UIButton *reaskBt;//追问
@property (assign,nonatomic) ReaskType reaskType;
- (IBAction)qflowerBtClicked:(id)sender;
- (IBAction)answerBtClicked:(id)sender;
- (IBAction)questionOKBtClicked:(id)sender;
- (IBAction)acceptAnswerBtClicked:(id)sender;

-(void)setAnswerModel:(AnswerModel*)answer withQuestion:(QuestionModel*)question;
@end

@protocol QuestionAndAnswerCellDelegate <NSObject>
//提交追问
-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell summitQuestion:(NSString*)questionStr atIndexPath:(IndexPathModel*)path withReaskType:(ReaskType)reaskType;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell flowerAnswerAtIndexPath:(IndexPathModel*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell acceptAnswerAtIndexPath:(IndexPathModel*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(IndexPathModel*)path;

-(void)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  willBeginTypeQuestionTextFieldAtIndexPath:(IndexPathModel*)path;

-(float)questionAndAnswerCell:(QuestionAndAnswerCell*)cell  getCellheightAtIndexPath:(IndexPathModel*)path;
@end