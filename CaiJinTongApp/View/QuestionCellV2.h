//
//  QuestionCellV2.h
//  CaiJinTongApp
//
//  Created by david on 14-4-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichQuestionContentView.h"
#import "QuestionModel.h"
@protocol QuestionCellV2Delegate;
#pragma mark IBOutlet

/** QuestionCellV2
 *
 * 问答界面显示
 */
@interface QuestionCellV2 :  UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *questionFlagImageview;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;

///显示发布时间
@property (weak, nonatomic) IBOutlet UILabel *questionTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *quesstionAnswerCountLabel;

@property (weak,nonatomic) id<QuestionCellV2Delegate> delegate;

@property (strong,nonatomic) NSIndexPath *path;

///点击可以进行回答，赞，回复，追问
@property (weak, nonatomic) IBOutlet UIButton *questionBt;
///附件背景view
@property (weak, nonatomic) IBOutlet UIView *attachmentBackView;

///显示问答内容，文本和图片
@property (weak, nonatomic) IBOutlet RichQuestionContentView *questionRichContentview;

///显示回答者个数，
@property (weak, nonatomic) IBOutlet UIButton *answerCountBt;

///如果数字大可以扩展,并且附件按钮向后移动
@property (weak, nonatomic) IBOutlet UIView *answerCountBackView;
///附件按钮，有附件时才显示
@property (weak, nonatomic) IBOutlet UIButton *attachmentBt;

///点击展开回答列表
- (IBAction)extendAnswerListBtClicked:(id)sender;

///点击查看附件
- (IBAction)attachmentBtClicked:(id)sender;
///点击可以进行回答，赞，回复，追问
- (IBAction)questionEditBtClicked:(id)sender;
#pragma mark --

@property (strong,nonatomic) QuestionModel *questionModel;

///重新赋值
-(void)refreshCellWithQuestionModel:(QuestionModel*)question;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol QuestionCellV2Delegate <NSObject>

///选中内容图片时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell selectedImageType:(RichContextObj*)richContentObj AtIndexPath:(NSIndexPath*)path;

///选中多功能按钮时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell selectedMenuButtonAtIndexPath:(NSIndexPath*)path;

///点击回答或者问题内容时调用,展开回答相关内容
-(void)questionCellV2:(QuestionCellV2*)questionCell extendAnswerContentButtonAtIndexPath:(NSIndexPath*)path;

///点击查看附件时调用
-(void)questionCellV2:(QuestionCellV2*)questionCell viewAttachmentButtonAtIndexPath:(NSIndexPath*)path;
@end