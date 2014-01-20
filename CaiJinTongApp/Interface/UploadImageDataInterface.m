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
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@""]];
    [request addData:uploadData forKey:@"img"];
    [request addPostValue:@"asihttp" forKey:@"name"];
    [request addPostValue:userId?:@"" forKey:@"userId"];
    [request addPostValue:categoryId?:@"" forKey:@"categoryId"];
    [request addPostValue:questionTitle?:@"" forKey:@"questionTitle"];
    [request addPostValue:questionContent?:@"" forKey:@"questionContent"];
    [request setCompletionBlock:^{
        if ([UploadImageDataInterface defaultUploadImageDataInterface].uploadDataSuccess) {
            [UploadImageDataInterface defaultUploadImageDataInterface].uploadDataSuccess(@"上传文件成功");
        }
    }];
    [request setFailedBlock:^{
        if ([UploadImageDataInterface defaultUploadImageDataInterface].uploadDataFailure) {
            [UploadImageDataInterface defaultUploadImageDataInterface].uploadDataFailure(@"上传文件失败");
        }
    }];
    [request startAsynchronous];
}
@end
