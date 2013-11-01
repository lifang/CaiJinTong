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

-(void)getAcceptAnswerInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId;
@end

@protocol AcceptAnswerInterfaceDelegate <NSObject>

-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result;
-(void)getAcceptAnswerInfoDidFailed:(NSString *)errorMsg;

@end