//
//  ChapterQuestionInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol ChapterQuestionInterfaceDelegate;

@interface ChapterQuestionInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<ChapterQuestionInterfaceDelegate>delegate;

-(void)getChapterQuestionInterfaceDelegateWithUserId:(NSString *)userId andChapterQuestionId:(NSString *)chapterQuestionId;
@end

@protocol ChapterQuestionInterfaceDelegate <NSObject>

-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result;
-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg;

@end