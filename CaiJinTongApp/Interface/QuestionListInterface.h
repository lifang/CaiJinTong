//
//  QuestionListInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "QuestionModel.h"
//分页显示问题
@protocol QuestionListInterfaceDelegate;

@interface QuestionListInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<QuestionListInterfaceDelegate>delegate;

-(void)getQuestionListInterfaceDelegateWithUserId:(NSString *)userId andChapterQuestionId:(NSString *)chapterQuestionId andLastQuestionID:(NSString*)lastQuestionID;
@end

@protocol QuestionListInterfaceDelegate <NSObject>

-(void)getQuestionListInfoDidFinished:(NSDictionary *)result;
-(void)getQuestionListInfoDidFailed:(NSString *)errorMsg;

@end