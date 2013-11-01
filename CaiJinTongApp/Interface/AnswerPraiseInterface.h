//
//  AnswerPraiseInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol AnswerPraiseInterfaceDelegate;

@interface AnswerPraiseInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<AnswerPraiseInterfaceDelegate>delegate;

-(void)getAnswerPraiseInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId;
@end

@protocol AnswerPraiseInterfaceDelegate <NSObject>

-(void)getAnswerPraiseInfoDidFinished:(NSDictionary *)result;
-(void)getAnswerPraiseInfoDidFailed:(NSString *)errorMsg;

@end