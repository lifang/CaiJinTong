//
//  UpdateDownloadTimesInfo.m
//  CaiJinTongApp
//
//  Created by david on 14-3-21.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UpdateDownloadTimesInfo.h"

@implementation UpdateDownloadTimesInfo
+(void)downloadDownloadTimesWithUserId:(NSString*)userId withLearningMatearilId:(NSString*)matearilId withSuccess:(void(^)(int downloadCount))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
//    http://lms.finance365.com/api/ios.ashx?active=updatekmdownnum&userId=&kmId=
    NSString *urlString = [NSString stringWithFormat:@"%@?active=updatekmdownnum&userId=%@&kmId=%@",kHost,userId,matearilId?:@""];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        
        NSDictionary *dic = [dicData objectForKey:@"ReturnObject"];
        if (!dic || dic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        NSString *count = [NSString stringWithFormat:@"%@",[Utility filterValue:[dic objectForKey:@"downnum"]]];
        if (!count) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(count.intValue-1<0?0:(count.intValue));
            }
        });
    } withFailure:failure];
}
@end
