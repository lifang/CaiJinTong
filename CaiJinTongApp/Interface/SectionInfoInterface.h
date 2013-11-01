//
//  SectionInfoInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "SectionModel.h"

@protocol SectionInfoInterfaceDelegate;

@interface SectionInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<SectionInfoInterfaceDelegate>delegate;

-(void)getSectionInfoInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId;
@end

@protocol SectionInfoInterfaceDelegate <NSObject>

-(void)getSectionInfoDidFinished:(SectionModel *)result;
-(void)getSectionInfoDidFailed:(NSString *)errorMsg;

@end