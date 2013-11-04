//
//  SuggestionInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SuggestionInterfaceDelegate;
@interface SuggestionInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<SuggestionInterfaceDelegate>delegate;
-(void)getAskQuestionInterfaceDelegateWithUserId:(NSString *)userId andSuggestionContent:(NSString *)suggestionContent;

@end

@protocol SuggestionInterfaceDelegate <NSObject>

-(void)getSuggestionInfoDidFinished:(NSDictionary *)result;
-(void)getSuggestionInfoDidFailed:(NSString *)errorMsg;
@end
