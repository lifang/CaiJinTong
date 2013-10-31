//
//  CaiJinTongManager.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RJDBKit;
@interface CaiJinTongManager : NSObject {
    RJDBKit* _db;
}
@property (nonatomic, retain) NSString *sessionId;
+ (CaiJinTongManager *)sharedInstance;

+ (void)releaseSharedInstance;

@end
