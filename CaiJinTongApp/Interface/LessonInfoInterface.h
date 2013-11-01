//
//  LessonInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol LessonInfoInterfaceDelegate;

@interface LessonInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<LessonInfoInterfaceDelegate>delegate;

-(void)getLessonInfoInterfaceDelegateWithUserId:(NSString *)userId;
@end

@protocol LessonInfoInterfaceDelegate <NSObject>

-(void)getLessonInfoDidFinished:(NSDictionary *)result;
-(void)getLessonInfoDidFailed:(NSString *)errorMsg;

@end