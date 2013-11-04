//
//  AnswerListInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "QuestionModel.h"

@protocol AnswerListInterfaceDelegate;
@interface AnswerListInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<AnswerListInterfaceDelegate>delegate;

-(void)getAnswerListInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andPageIndex:(int)pageIndex;
@end

@protocol AnswerListInterfaceDelegate <NSObject>

-(void)getAnswerListInfoDidFinished:(QuestionModel *)result;
-(void)getAnswerListInfoDidFailed:(NSString *)errorMsg;

@end

