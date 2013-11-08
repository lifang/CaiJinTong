//
//  Utility.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>

@implementation Utility

+ (void)errorAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"财精通提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
+ (NSString *)isExistenceNetwork {
    NSString *str = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
			str = @"NotReachable";
            break;
        case ReachableViaWWAN:
			str = @"ReachableViaWWAN";
            break;
        case ReachableViaWiFi:
			str = @"ReachableViaWiFi";
            break;
    }
    return str;
}

+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font{
    if (text && font) {
        return [text sizeWithFont:font];
    } else {
        return CGSizeZero;
    }
}

+(NSString *)createMD5:(NSString *)signString
{
    const char*cStr =[signString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result);
    return[NSString stringWithFormat:
           @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           result[0], result[1], result[2], result[3],
           result[4], result[5], result[6], result[7],
           result[8], result[9], result[10], result[11],
           result[12], result[13], result[14], result[15]
           ];
}

+ (Class)JSONParserClass {
    return objc_getClass("NSJSONSerialization");
}

+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath {
    Class JSONSerialization = [Utility JSONParserClass];
    NSAssert(JSONSerialization != NULL, @"No JSON serializer available!");
    
    NSError *jsonParsingError = nil;
    NSString *filePath = [[NSBundle mainBundle] pathForResource:jsonPath ofType:@"json"];
    NSDictionary *dataObject = [JSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:filePath] options:0 error:&jsonParsingError];
    return dataObject;
}

+ (NSString *)getNowDateFromatAnDate {
    NSDate *anyDate = [NSDate date];
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    //转为string
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString *timeString = [dateFormatter stringFromDate:destinationDateNow];
    
    return timeString;
}


@end
