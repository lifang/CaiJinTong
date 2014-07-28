//
//  UserStudySummaryInfo.m
//  CaiJinTongApp
//
//  Created by david on 14-3-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UserStudySummaryInfo.h"
#import "ASIHTTPRequest.h"
@implementation UserStudySummaryInfo
+(void)downloadStudySummaryInfoWithUserId:(NSString*)userId withSuccess:(void(^)(StudySummaryModel *studySummaryModel))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
//    http://lms.finance365.com/api/ios.ashx?active=protalinfo&userId=18676
    NSString *urlString = [NSString stringWithFormat:@"%@?active=protalinfo&userId=%@",kHost,userId];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:60];
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
        NSArray *array = [dic objectForKey:@"list"];
        if (!array || array.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        NSDictionary *data = [array firstObject];
        if (!data || data.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        
        StudySummaryModel *model = [[StudySummaryModel alloc] init];
        model.studyAllCourseCount = [[Utility filterValue:[data objectForKey:@"allcourse"]] intValue];
        model.studyBeginningCourseCount = [[Utility filterValue:[data objectForKey:@"courses"]] intValue];
        model.studyAllLearningMatarilCount = [[Utility filterValue:[data objectForKey:@"zl"]] intValue];
        model.studyAllNotesCount = [[Utility filterValue:[data objectForKey:@"surveys"]] intValue];
        model.studyAllQuestionCount = [[Utility filterValue:[data objectForKey:@"ask"]] intValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(model);
            }
        });
    } withFailure:failure];
}
@end
