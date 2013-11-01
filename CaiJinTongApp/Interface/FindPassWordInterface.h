//
//  FindPassWordInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol FindPassWordInterfaceDelegate;

@interface FindPassWordInterface : BaseInterface <BaseInterfaceDelegate>

@property (nonatomic, assign) id<FindPassWordInterfaceDelegate>delegate;

-(void)getFindPassWordInterfaceDelegateWithName:(NSString *)theName andEmail:(NSString *)theEmail;
@end


@protocol FindPassWordInterfaceDelegate <NSObject>

-(void)getFindPassWordInfoDidFinished:(NSDictionary *)result;
-(void)getFindPassWordInfoDidFailed:(NSString *)errorMsg;

@end