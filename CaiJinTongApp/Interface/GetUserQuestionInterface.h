//
//  GetUserQuestionInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol GetUserQuestionInterfaceDelegate;

@interface GetUserQuestionInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<GetUserQuestionInterfaceDelegate>delegate;
-(void)getGetUserQuestionInterfaceDelegateWithUserId:(NSString *)userId andIsMyselfQuestion:(NSString *)isMyselfQuestion andLastQuestionID:(NSString*)lastQuestionID;
@end

@protocol GetUserQuestionInterfaceDelegate <NSObject>

-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result;
-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg;

@end