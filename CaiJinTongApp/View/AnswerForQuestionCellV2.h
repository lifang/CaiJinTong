//
//  AnswerForQuestionCellV2.h
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichQuestionContentView.h"
#import "AnswerModel.h"
@protocol AnswerForQuestionCellV2Delegate;
/** AnswerForQuestionCellV2
 *
 *对问答的回答cell
 */
@interface AnswerForQuestionCellV2 : UITableViewCell
#pragma mark IBoutlet
///如果不是回答时，需要隐藏
@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;

///设置时间
@property (weak, nonatomic) IBOutlet UILabel *titleTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBt;
///显示回答内容
@property (weak, nonatomic) IBOutlet RichQuestionContentView *richContentView;

///当前回答是正确答案后显示，其他情况隐藏
@property (weak, nonatomic) IBOutlet UIImageView *correctFlagImageView;

///回答的多功能按钮
- (IBAction)moreBtClicked:(id)sender;

#pragma mark --
///当前回答所在位置
@property (strong,nonatomic) NSIndexPath *path;
@property (strong,nonatomic) AnswerModel *answerModel;
@property (weak,nonatomic) id<AnswerForQuestionCellV2Delegate> delegate;

///重新赋值
-(void)refreshCellWithAnswerModel:(AnswerModel*)answer;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@protocol AnswerForQuestionCellV2Delegate <NSObject>

///选中内容图片时调用
-(void)answerForQuestionCellV2:(AnswerForQuestionCellV2*)answerCell selectedImageType:(RichContextObj*)richContentObj AtIndexPath:(NSIndexPath*)path;

///选择多动能按钮时调用
-(void)answerForQuestionCellV2:(AnswerForQuestionCellV2*)answerCell selectedMoreButtonAtIndexPath:(NSIndexPath*)path withAnswerType:(ReaskType)answerType;
@end