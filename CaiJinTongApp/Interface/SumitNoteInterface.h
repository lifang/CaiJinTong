//
//  SumitNoteInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SumitNoteInterfaceDelegate;
@interface SumitNoteInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<SumitNoteInterfaceDelegate>delegate;
-(void)getSumitNoteInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andNoteTime:(NSString *)noteTime andNoteText:(NSString *)noteText;

@end

@protocol SumitNoteInterfaceDelegate <NSObject>

-(void)getSumitNoteInfoDidFinished;
-(void)getSumitNoteDidFailed:(NSString *)errorMsg;
@end


