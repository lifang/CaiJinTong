//
//  QuestionInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
//获取问题分类信息
@protocol QuestionInfoInterfaceDelegate;

@interface QuestionInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<QuestionInfoInterfaceDelegate>delegate;

-(void)getQuestionInfoInterfaceDelegateWithUserId:(NSString *)userId;

@end

@protocol QuestionInfoInterfaceDelegate <NSObject>

-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr;
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg;

@end