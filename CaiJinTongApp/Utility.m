//
//  Utility.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "Utility.h"
#import <objc/runtime.h>
#import <CommonCrypto/CommonDigest.h>
@implementation Utility

+ (void)errorAlert:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"财金通提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
+ (NSString *)isExistenceNetwork {
    NSString *str = nil;
	Reachability *r = [Reachability reachabilityWithHostName:@"lms.finance365.com"];
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

+(NSAttributedString*)getTextSizeWithAnswerModel:(AnswerModel*)answer withFont:(UIFont*)font withWidth:(float)width{
    if (answer.answerContent && font) {
        NSMutableString *content = [NSMutableString stringWithFormat:@"     %@",answer.answerContent?:@""];
        for (Reaskmodel *reask in answer.reaskModelArray) {
            NSString *reaskTitle = [NSString stringWithFormat:@"\n\n%@ 追问 发表于%@\n",reask.reaskNickName?:@"",reask.reaskDate?:@""];
            NSString *isTeacher = @"";
            if (reask.reAnswerIsTeacher && [reask.reAnswerIsTeacher isEqualToString:@"1"]) {
                isTeacher = @"老师";
            }
            NSString *reAnswerTitle = [NSString stringWithFormat:@"\n\n%@%@ 回复 发表于%@\n",reask.reAnswerNickName?:@"",isTeacher,reask.reaskDate?:@""];
            [content appendString:reaskTitle];
            [content appendString:[NSString stringWithFormat:@"     %@",reask.reaskContent?:@""]];
            [content appendString:reAnswerTitle];
            [content appendString:[NSString stringWithFormat:@"     %@",reask.reAnswerContent?:@""]];
        }
        
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:content];
        int contentLenght =[[NSString stringWithFormat:@"     %@",answer.answerContent?:@""] length];
        [attriString addAttribute:NSParagraphStyleAttributeName value:[NSMutableParagraphStyle defaultParagraphStyle] range:NSMakeRange(0, contentLenght)];
        [attriString addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attriString.length)];
        [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(contentLenght, attriString.length-contentLenght)];
        for (Reaskmodel *reask in answer.reaskModelArray) {
            NSString *reaskTitle = [NSString stringWithFormat:@"\n\n%@ 追问 发表于%@\n",reask.reaskNickName?:@"",reask.reaskDate?:@""];
            for (NSDictionary *subRange in [self getAllSubStringRanges:content withSubString:reaskTitle]) {
                NSRange range = (NSRange){[[subRange objectForKey:@"startIndex"] integerValue],[[subRange objectForKey:@"lenght"] integerValue]};
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            }
            
            NSString *isTeacher = @"";
            if (reask.reAnswerIsTeacher && [reask.reAnswerIsTeacher isEqualToString:@"1"]) {
                isTeacher = @"老师";
            }
            NSString *reAnswerTitle = [NSString stringWithFormat:@"\n\n%@%@ 回复 发表于%@\n",reask.reAnswerNickName?:@"",isTeacher,reask.reaskDate?:@""];
            for (NSDictionary *subRange in [self getAllSubStringRanges:content withSubString:reAnswerTitle]) {
                NSRange range = (NSRange){[[subRange objectForKey:@"startIndex"] integerValue],[[subRange objectForKey:@"lenght"] integerValue]};
                [attriString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:range];
                [attriString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range];
            }
        }
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.headIndent = 40;
        style.tailIndent = width;
        [attriString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0,attriString.length)];
        return attriString;
    }
    
    return nil;
}


+(CGSize)getAttributeStringSizeWithWidth:(float)width withAttributeString:(NSAttributedString*)attriString{
 CGRect rect = [attriString boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingUsesDeviceMetrics context:nil];
    return (CGSize){rect.size.width,rect.size.height+30};
}

+(NSArray*)getAllSubStringRanges:(NSString*)string withSubString:(NSString *)subString{
    if (!string || !subString) {
        return nil;
    }
    NSMutableString *tempString = [[NSMutableString alloc] initWithString:string];
    NSMutableArray *subRangeArr = [NSMutableArray array];
    NSMutableString *replaceString = [[NSMutableString alloc] init];
    for (int index = 0; index < subString.length; index++) {
        [replaceString appendFormat:@"￡"];
    }
    
    while (YES) {
        NSRange range = [tempString rangeOfString:subString];
        if (range.length <= 0) {
            break;
        }
        [subRangeArr addObject:@{@"startIndex": [NSNumber numberWithInt:range.location],@"lenght":[NSNumber numberWithInt:range.length]}];
        [tempString replaceCharactersInRange:range withString:replaceString];
    }
    return subRangeArr;
}
+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes{
    int level = 0;
    NSString *convertSize = nil;
    long long size = bytes.longLongValue;
    double lenght = size*1.0;
    while (lenght >= 1024.0) {
        if (level >= 3) {
            break;
        }
        level++;
        lenght = lenght/1024.0;
    }
    
    switch (level) {
        case 0:
            convertSize = [NSString stringWithFormat:@"%0.2fKB",lenght];
            break;
        case 1:
            convertSize = [NSString stringWithFormat:@"%0.2fM",lenght];
            break;
        case 2:
            convertSize = [NSString stringWithFormat:@"%0.2fG",lenght];
            break;
        case 3:
            convertSize = [NSString stringWithFormat:@"%0.2fTB",lenght];
            break;
        default:
            break;
    }
    return convertSize;
}
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGSize size = [text boundingRectWithSize:(CGSize){width,MAXFLOAT} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
            return size;
        }else{
            CGSize size = [[text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] sizeWithFont:font constrainedToSize:(CGSize){width,MAXFLOAT} lineBreakMode:NSLineBreakByWordWrapping];
            return size;
        }
    } else {
        return CGSizeZero;
    }
}

//+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width{
//    if (text && font) {
//        CGSize size = [text boundingRectWithSize:(CGSize){width,2000.0} options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName: font} context:nil].size;
//        return size;
//    } else {
//        return CGSizeZero;
//    }
//}


+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font{
    if (text && font) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            return [text sizeWithAttributes:@{NSFontAttributeName: font}];
        }else{
            CGSize size = [text sizeWithFont:font];
            return size;
        }
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

+(NSString*)getStringFromDate:(NSDate*)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter stringFromDate:date];
}
+(NSDate*)getDateFromDateString:(NSString*)dateString{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:dateString];
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

//对IOS7和6使用不同的背景
+ (void)setBackgroungWithView:(UIView *)view andImage6:(NSString *)str6 andImage7:(NSString *)str7{
    if (platform == 6.0) {
        view.backgroundColor = [UIColor colorWithPatternImage:Image(str6)];
    }else {
        view.backgroundColor = [UIColor colorWithPatternImage:Image(str7)];
    }
}
@end
