//
//  UpdateDownloadTimesInfo.h
//  CaiJinTongApp
//
//  Created by david on 14-3-21.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** UpdateDownloadTimesInfo
 *
 * 获取下载次数
 */
@interface UpdateDownloadTimesInfo : NSObject
+(void)downloadDownloadTimesWithUserId:(NSString*)userId withLearningMatearilId:(NSString*)matearilId withSuccess:(void(^)(int downloadCount))success withError:(void (^)(NSError *error))failure;
@end
