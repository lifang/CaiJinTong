//
//  PlayBackInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol PlayBackInterfaceDelegate;

@interface PlayBackInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<PlayBackInterfaceDelegate>delegate;
-(void)getPlayBackInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andTimeEnd:(NSString *)timeEnd;

@end

@protocol PlayBackInterfaceDelegate <NSObject>

-(void)getPlayBackInfoDidFinished:(NSDictionary *)result;
-(void)getPlayBackDidFailed:(NSString *)errorMsg;
@end