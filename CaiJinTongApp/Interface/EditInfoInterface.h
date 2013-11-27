//
//  EditInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseImageInfo.h"
#import "BaseInterface.h"
@protocol EditInfoInterfaceDelegate;
@interface EditInfoInterface : BaseInterface <BaseInterfaceDelegate>
@property (nonatomic, assign) id <EditInfoInterfaceDelegate> delegate;

-(void)getEditInfoInterfaceDelegateWithUserId:(NSString *)userId andBirthday:(NSString *)birthday andSex:(NSString *)sex andAddress:(NSString *)address andImage:(NSData *)Image withNickName:(NSString*)nickName;
@end

@protocol EditInfoInterfaceDelegate <NSObject>

-(void)getEditInfoDidFinished:(NSDictionary *)result;
-(void)getEditInfoDidFailed:(NSString *)errorMsg;

@end