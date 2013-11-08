//
//  CaiJinTongManager.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CaiJinTongManager : NSObject
{
    BOOL _free;
    BOOL _holding;
}

@property (nonatomic, strong) NSString * userId;

+ (CaiJinTongManager *)shared;

/** hold the thread when background task will terminate */
- (void)hold;

/** free from holding when applicaiton become active */
- (void)stop;

/** running in background, call this funciton when application become background */
- (void)run;
@end
