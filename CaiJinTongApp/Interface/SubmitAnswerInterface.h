//
//  SubmitAnswerInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SubmitAnswerInterfaceDelegate;
/*
 *提交追问或者回答
 */
@interface SubmitAnswerInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, assign) id<SubmitAnswerInterfaceDelegate>delegate;
//resultId:resultId=0 表示回答 resultId大于0 表示追问
-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId;

@end

@protocol SubmitAnswerInterfaceDelegate <NSObject>
/*
 *@brief 提交追问或者回答回调方法
 */
-(void)getSubmitAnswerInfoDidFinished:(NSDictionary *)result;
-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg;
@end


