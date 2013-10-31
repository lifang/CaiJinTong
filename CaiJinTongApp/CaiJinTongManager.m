//
//  CaiJinTongManager.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "CaiJinTongManager.h"
#import "RJFileUtils.h"
#import "RJDBKit.h"

@interface CaiJinTongManager(CJTPrivate)

@end
@implementation CaiJinTongManager(CJTPrivate)

@end

@implementation CaiJinTongManager
@synthesize sessionId;

static CaiJinTongManager * caiJinTongManager = nil;
- (id)init{
    self = [super init];
    if (!self) {
        
    }
    return self;
}

+ (CaiJinTongManager *)sharedInstance {
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        caiJinTongManager = [[super alloc] init];
    });
    return caiJinTongManager;
}

+ (void)releaseSharedInstance {
    caiJinTongManager = nil;
}
@end
