//
//  GradeInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol GradeInterfaceDelegate;

@interface GradeInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<GradeInterfaceDelegate>delegate;

-(void)getGradeInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andScore:(NSString *)score andContent:(NSString *)content;
@end

@protocol GradeInterfaceDelegate <NSObject>

-(void)getGradeInfoDidFinished:(NSDictionary *)result;
-(void)getGradeInfoDidFailed:(NSString *)errorMsg;

@end