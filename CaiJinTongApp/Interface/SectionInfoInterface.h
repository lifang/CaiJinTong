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
/*
 获取课程详细信息
 */
@interface SectionInfoInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, weak) id<SectionInfoInterfaceDelegate>delegate;

-(void)getSectionInfoInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId;
@end

@protocol SectionInfoInterfaceDelegate <NSObject>

-(void)getSectionInfoDidFinished:(SectionModel *)result;
-(void)getSectionInfoDidFailed:(NSString *)errorMsg;

@end