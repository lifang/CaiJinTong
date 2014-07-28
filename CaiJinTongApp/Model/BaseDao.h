//
//  BaseDao.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface BaseDao : NSObject
@property (nonatomic, strong) NSString *dbPath;
@property (nonatomic, strong) FMDatabase *db;
@end
