//
//  AskQuestionInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol AskQuestionInterfaceDelegate;
@interface AskQuestionInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<AskQuestionInterfaceDelegate>delegate;
-(void)getAskQuestionInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andQuestionName:(NSString *)questionName andQuestionContent:(NSString *)content;

@end

@protocol AskQuestionInterfaceDelegate <NSObject>

-(void)getAskQuestionInfoDidFinished;
-(void)getAskQuestionDidFailed:(NSString *)errorMsg;
@end

