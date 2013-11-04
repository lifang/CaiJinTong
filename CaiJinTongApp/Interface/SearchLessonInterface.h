//
//  SearchLessonInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol SearchLessonInterfaceDelegate;

@interface SearchLessonInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<SearchLessonInterfaceDelegate>delegate;

-(void)getSearchLessonInterfaceDelegateWithUserId:(NSString *)userId andText:(NSString *)text;
@end

@protocol SearchLessonInterfaceDelegate <NSObject>

-(void)getSearchLessonInfoDidFinished:(NSDictionary *)result;
-(void)getSearchLessonInfoDidFailed:(NSString *)errorMsg;

@end