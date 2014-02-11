//
//  UploadImageDataInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "UploadImageDataInterface.h"
#import "ASIFormDataRequest.h"
#import <Foundation/Foundation.h>
@implementation UploadImageDataInterface
static UploadImageDataInterface *defaultUploadImage;
+(UploadImageDataInterface*)defaultUploadImageDataInterface{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUploadImage = [[UploadImageDataInterface alloc] init];
    });
    return defaultUploadImage;
}
+(void)uploadImageWithUserId:(NSString*)userId withQuestionCategoryId:(NSString*)categoryId withQuestionTitle:(NSString*)questionTitle withQuestionContent:(NSString*)questionContent withUploadedData:(NSData*)uploadData withSuccess:(void (^)(NSString *success))success withFailure:(void (^)(NSString *failureMsg))failure{

#if kRunScopeTest
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://lms-finance365-com-5we3gmhhky2y.runscope.net/api/iosuploadify.aspx"]];
#else
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://lms.finance365.com/api/iosuploadify.aspx"]];
#endif
    [request addPostValue:@"asihttp.png" forKey:@"name"];
    [request addPostValue:userId?:@"" forKey:@"userId"];
    [request addPostValue:categoryId?:@"" forKey:@"sectionId"];
    [request addPostValue:questionTitle?:@"" forKey:@"title"];
    [request addPostValue:questionContent?:@"" forKey:@"content"];
    if (uploadData) {
        [request addPostValue:@"1" forKey:@"isImage"];//如果带图片数据就为1，不带图片就传2
        [request addData:uploadData forKey:@"img"];
    }else{
        [request addPostValue:@"2" forKey:@"isImage"];//如果带图片数据就为1，不带图片就传2
    }
    
//    [request setBytesSentBlock:^(unsigned long long size, unsigned long long total) {
//        NSLog(@"%llu,%llu",size,total);
//    }];
    __weak ASIHTTPRequest *weakRequest = request;
    [request setCompletionBlock:^{
        ASIHTTPRequest *tempRequest = weakRequest;
        if (tempRequest) {
            DLog(@"%@",tempRequest.responseString);
            NSData *data = [[NSData alloc]initWithData:[tempRequest responseData]];
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            if (jsonObject && [jsonObject isKindOfClass:[NSDictionary class]]) {
                NSString *status = [NSString stringWithFormat:@"%@",[jsonObject objectForKey:@"Status"]];
                if ([status isEqualToString:@"1"]) {
                    if (success) {
                        success(@"上传文件成功");
                    }
                }else{
                    if (failure) {
                        failure(@"上传文件失败");
                    }
                }
            }else{
                if (failure) {
                    failure(@"上传文件失败");
                }
            }
        }
    }];
    [request setFailedBlock:^{
        if (failure) {
            failure(@"上传文件失败");
        }
    }];
    [request startAsynchronous];
}
@end
