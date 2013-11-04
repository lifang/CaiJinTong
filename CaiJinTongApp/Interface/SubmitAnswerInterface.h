//
//  SubmitAnswerInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SubmitAnswerInterfaceDelegate;
@interface SubmitAnswerInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<SubmitAnswerInterfaceDelegate>delegate;
-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId;

@end

@protocol SubmitAnswerInterfaceDelegate <NSObject>

-(void)getSubmitAnswerInfoDidFinished:(NSDictionary *)result;
-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg;
@end


