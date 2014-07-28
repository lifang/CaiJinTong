//
//  AcceptAnswerInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol AcceptAnswerInterfaceDelegate;

@interface AcceptAnswerInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<AcceptAnswerInterfaceDelegate>delegate;
/*
 *
 *userId:提交采纳正确答案的用户
  questionId：问题id
  answerID：答案回答者ID
  correctAnswerID：答案的ID
 */
-(void)getAcceptAnswerInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andCorrectAnswerID:(NSString*)correctAnswerID;
@end

@protocol AcceptAnswerInterfaceDelegate <NSObject>

-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result;
-(void)getAcceptAnswerInfoDidFailed:(NSString *)errorMsg;

@end