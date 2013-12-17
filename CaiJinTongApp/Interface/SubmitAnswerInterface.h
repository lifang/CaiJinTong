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
@property (nonatomic, assign) ReaskType reaskType;
//resultId:resultId=0 表示回答 resultId大于0 表示追问
-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andReaskTyep:(ReaskType)reask  andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andResultId:(NSString *)resultId;

@end

@protocol SubmitAnswerInterfaceDelegate <NSObject>
/*
 *@brief 提交追问或者回答回调方法
 */
-(void)getSubmitAnswerInfoDidFinished:(NSDictionary *)result withReaskType:(ReaskType)reask;
-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg withReaskType:(ReaskType)reask;
@end


