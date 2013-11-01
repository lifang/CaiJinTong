//
//  QuestionInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol QuestionInfoInterfaceDelegate;

@interface QuestionInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<QuestionInfoInterfaceDelegate>delegate;

-(void)getQuestionInfoInterfaceDelegateWithUserId:(NSString *)userId;

@end

@protocol QuestionInfoInterfaceDelegate <NSObject>

-(void)getQuestionInfoDidFinished:(NSDictionary *)result;
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg;

@end