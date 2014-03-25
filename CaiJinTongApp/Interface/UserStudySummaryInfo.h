//
//  UserStudySummaryInfo.h
//  CaiJinTongApp
//
//  Created by david on 14-3-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudySummaryModel.h"
/** UserStudySummaryInfo
 *
 * 加载当前用户所有学习的大概信息
 */
@interface UserStudySummaryInfo : NSObject
+(void)downloadStudySummaryInfoWithUserId:(NSString*)userId withSuccess:(void(^)(StudySummaryModel *studySummaryModel))success withError:(void (^)(NSError *error))failure;
@end
