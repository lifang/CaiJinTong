//
//  Utility.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Utility : NSObject

+ (NSString *)isExistenceNetwork;
+ (NSString *)createMD5:(NSString *)params;
+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath;
+ (NSString *)getNowDateFromatAnDate;
+ (void)errorAlert:(NSString *)message;

+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font;
@end
