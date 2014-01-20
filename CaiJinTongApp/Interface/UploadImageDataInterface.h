//
//  UploadImageDataInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-18.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 
 上传图片
 */
@interface UploadImageDataInterface : NSObject
@property (strong,nonatomic) void (^uploadDataSuccess)(NSString *sucess);
@property (strong,nonatomic) void (^uploadDataFailure)(NSString *failureMsg);
+(void)uploadImageWithUserId:(NSString*)userId withQuestionCategoryId:(NSString*)categoryId withQuestionTitle:(NSString*)questionTitle withQuestionContent:(NSString*)questionContent withUploadedData:(NSData*)uploadData withSuccess:(void (^)(NSString *success))success withFailure:(void (^)(NSString *failureMsg))failure;
@end