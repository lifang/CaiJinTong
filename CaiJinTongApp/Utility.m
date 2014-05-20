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
@interface Utility()
@property (nonatomic,strong) UIAlertView *alert;
@end
@implementation Utility
+(Utility*)defaultUtility{
    static Utility *defaultUti = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultUti = [[Utility alloc] init];
    });
    return defaultUti;
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue
{
    return [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0
                           green:((float)((hexValue & 0xFF00) >> 8))/255.0
                            blue:((float)(hexValue & 0xFF))/255.0 alpha:alphaValue];
}

+ (UIColor*) colorWithHex:(NSInteger)hexValue
{
    return [Utility colorWithHex:hexValue alpha:1.0];
}

+ (NSString *) hexFromUIColor: (UIColor*) color {
    if (CGColorGetNumberOfComponents(color.CGColor) < 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        color = [UIColor colorWithRed:components[0]
                                green:components[0]
                                 blue:components[0]
                                alpha:components[1]];
    }
    
    if (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) != kCGColorSpaceModelRGB) {
        return [NSString stringWithFormat:@"#FFFFFF"];
    }
    
    return [NSString stringWithFormat:@"#XXX", (int)((CGColorGetComponents(color.CGColor))[0]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[1]*255.0),
            (int)((CGColorGetComponents(color.CGColor))[2]*255.0)];
}

///查找播放记录_时间
+(float)getStartPlayerTimeWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId{
    if (!userId && !sectionId) {
        return 0;
    }
    return  [[NSUserDefaults standardUserDefaults] floatForKey:[NSString stringWithFormat:@"playerTime_%@_%@",userId,sectionId]];
}

///查找播放记录_日期
+ (NSString *)getLastPlayDateWithUserId:(NSString *)userId withSectionId:(NSString *)sectionId{
    if (!userId && !sectionId) {
        return nil;
    }
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastPlayDate_%@_%@",userId,sectionId]];
}

///保存播放记录
+(void)setStartPlayerTimeWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withPlayerTime:(float)time withLastPlayDate:(NSString *)lastPlayDate{
    if (!userId && !sectionId) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setFloat:time forKey:[NSString stringWithFormat:@"playerTime_%@_%@",userId,sectionId]];
    [[NSUserDefaults standardUserDefaults] setObject:lastPlayDate forKey:[NSString stringWithFormat:@"lastPlayDate_%@_%@",userId,sectionId]];
}
///返回文件类型
+(DRURLFileType)getFileTypeWithFileExtension:(NSString*)extension{
    if (!extension || [extension isEqualToString:@""]) {
        return DRURLFileType_OTHER;
    }
    if ([extension isEqualToString:@"png"] || [extension isEqualToString:@"jpg"] || [extension isEqualToString:@"jpeg"]){
        return DRURLFileType_IMAGR;
    }
    if ([extension isEqualToString:@"pdf"]) {
        return  DRURLFileType_PDF;
    }
    if ([extension isEqualToString:@"doc"] || [extension isEqualToString:@"docx"]) {
       return DRURLFileType_WORD;
    }
    if ([extension isEqualToString:@"txt"]) {
        return DRURLFileType_TEXT;
    }
    if ([extension isEqualToString:@"ppt"]) {
       return DRURLFileType_PPT;
    }
    if ([extension isEqualToString:@"gif"]) {
        return DRURLFileType_GIF;
    }
    return DRURLFileType_OTHER;
}

+(NSString *)filterValue:(NSString*)filterValue{
    if (!filterValue) {
        return nil;
    }
    NSString *value = [NSString stringWithFormat:@"%@",filterValue];
    if ([value isEqualToString:@""] || [value isEqualToString:@"<NULL>"] || [value isEqualToString:@"null"] || [value isEqualToString:@"<null>"]) {
        return nil;
    }
    return value;
}

///异步请求网络数据
+(void)requestDataWithASIRequest:(ASIHTTPRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure{
    if (!request) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [request startSynchronous];
        NSError *error = request.error;
        NSData *data = request.responseData;
        DLog(@"%@,立刻舒服了看见,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": tipMsg}]);
                    }
                });
            }];
            
            return ;
        }
        
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取空数据"}]);
                }
            });
            return ;
        }
        
        
        NSString *status = [Utility filterValue:[dicData objectForKey:@"Status"]];
        if (!status || [status isEqualToString:@"error"] || [status isEqualToString:@"0"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"Msg"]?:@"获取数据失败"}]);
                }
            });
            return;
        }
        if (success) {
            success(dicData);
        }
    });
}

+(NSString*)formateDateStringWithSecond:(int)second{
    if (second <=0) {
        return @"00:00";
    }
    if (second >= MAXFLOAT) {
        return @"00:00";
    }
    int temp = second;
    int level = 2;
    NSMutableString *date = [[NSMutableString alloc] init];
    while (level > 0) {
        if (temp/(int)pow(60, level) <= 0) {
            level--;
            continue;
        }
        switch (level) {
            case 2:
            {
                if (temp < 10) {
                    [date appendFormat:@"0%d:",temp/(int)pow(60, level)];
                }else{
                    [date appendFormat:@"%d:",temp/(int)pow(60, level)];
                }
            }
                break;
            case 1:
            {
                if (temp < 10) {
                     [date appendFormat:@"0%d:",temp/(int)pow(60, level)];
                }else{
                     [date appendFormat:@"%d:",temp/(int)pow(60, level)];
                }
            }
                break;
            default:
                break;
        }
        temp = temp%(int)pow(60, level);
        level--;
    }
    if (date.length <= 0) {
        if (temp < 10) {
            [date appendFormat:@"00:0%d",temp];
        }else{
            [date appendFormat:@"00:%d",temp];
        }
    }else{
        if (temp < 10) {
            [date appendFormat:@"0%d",temp];
        }else{
            [date appendFormat:@"%d",temp];
        }
    }
    return date.lowercaseString;
}


+ (UIImage *)getNormalImage:(UIView *)view{
    float width = [UIScreen mainScreen].bounds.size.width;
    float height = [UIScreen mainScreen].bounds.size.height;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:context];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (void)errorAlert:(NSString *)message {
    if (!message || [message isEqualToString:@""]) {
        return;
    }
    if ([Utility defaultUtility].alert != nil) {
        UIAlertView *alert = [Utility defaultUtility].alert;
        [alert dismissWithClickedButtonIndex:0 animated:NO];
    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"财金通提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [[Utility defaultUtility] setAlert:alert];
    [alert show];
}
//+ (NSString *)isExistenceNetwork {
//    NSString *str = nil;
//	Reachability *r = [Reachability reachabilityWithHostName:@"lms.finance365.com"];
//    switch ([r currentReachabilityStatus]) {
//        case NotReachable:
//			str = @"NotReachable";
//            break;
//        case ReachableViaWWAN:
//			str = @"ReachableViaWWAN";
//            break;
//        case ReachableViaWiFi:
//			str = @"ReachableViaWiFi";
//            break;
//    }
//    return str;
//}

+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus{
    NSString *str = @"NotReachable";
    switch ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus]) {
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
    if (networkStatus) {
        networkStatus(str);
    }
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
            convertSize = [NSString stringWithFormat:@"%0.2fB",lenght];
            break;
        case 1:
            convertSize = [NSString stringWithFormat:@"%0.2fKB",lenght];
            break;
        case 2:
            convertSize = [NSString stringWithFormat:@"%0.2fM",lenght];
            break;
        case 3:
            convertSize = [NSString stringWithFormat:@"%0.2fG",lenght];
            break;
        default:
            convertSize = [NSString stringWithFormat:@"%0.2fTB",lenght];
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
            if([text isEqualToString:@""]){
                //如果为空字符串,则本方法给出符合字体的基本高度,以与ios7的方法保持一致  
                text = @"1";
            }
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"Asia/Shanghai"]];
    NSString *timeString = [dateFormatter stringFromDate:[NSDate date]];
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

+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg{
    if (!error) {
        msg(@"无法连接服务器");
        return NO;
    }
    NSString *tip = [error.userInfo objectForKey:@"NSLocalizedDescription"];
    if (!tip) {
        msg(@"无法连接服务器");
        return NO;
    }
    
    if ([tip isEqualToString:@"The request timed out"]) {
        msg(@"连接网络失败");
        return YES;
    }
    
    if ([tip isEqualToString:@"A connection failure occurred"] || [tip isEqualToString:@"The Internet connection appears to be offline."]) {
        msg(@"当前网络不可用");
        return YES;
    }
    
    if ([tip isEqualToString:@"Could not connect to the server."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"Expected status code in (200-299)"]) {
        msg(@"无法连接服务器");
        return YES;
    }
    if ([tip isEqualToString:@"The network connection was lost."]) {
        msg(@"无法连接服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"未能连接到服务器。"]) {
        msg(@"未能连接到服务器");
        return YES;
    }
    
    if ([tip isEqualToString:@"似乎已断开与互联网的连接。"]) {
        msg(@"无法连接网络");
        return YES;
    }
    
    msg(@"无法连接服务器");
    return NO;
}

@end
