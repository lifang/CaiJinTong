//
//  ChapterInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol ChapterInfoInterfaceDelegate;

@interface ChapterInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<ChapterInfoInterfaceDelegate>delegate;

-(void)getChapterInfoInterfaceDelegateWithUserId:(NSString *)userId andChapterId:(NSString *)chapterId;
@end

@protocol ChapterInfoInterfaceDelegate <NSObject>

-(void)getChapterInfoDidFinished:(NSDictionary *)result;
-(void)getChapterInfoDidFailed:(NSString *)errorMsg;

@end