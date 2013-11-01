//
//  PlayVideoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol PlayVideoInterfaceDelegate;

@interface PlayVideoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<PlayVideoInterfaceDelegate>delegate;
-(void)getPlayVideoInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andTimeStart:(NSString *)timeStart;
@end

@protocol PlayVideoInterfaceDelegate <NSObject>

-(void)getPlayVideoInfoDidFinished:(NSDictionary *)result;
-(void)getPlayVideoInfoDidFailed:(NSString *)errorMsg;
@end