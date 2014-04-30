//
//  Utility.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AnswerModel.h"
@interface Utility : NSObject
+(Utility*)defaultUtility;

#pragma mark 16进制颜色转换

+ (UIColor*) colorWithHex:(NSInteger)hexValue;
+ (UIColor*) colorWithHex:(NSInteger)hexValue alpha:(CGFloat)alphaValue;
+ (NSString *) hexFromUIColor: (UIColor*) color;

#pragma mark --
///查找播放记录
+(float)getStartPlayerTimeWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId;

///保存播放记录
+(void)setStartPlayerTimeWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withPlayerTime:(float)time;
///返回文件类型
+(DRURLFileType)getFileTypeWithFileExtension:(NSString*)extension;

///过滤json数据，可能出现<NULL>,null,等等情况
+(NSString *)filterValue:(NSString*)value;

///异步请求网络数据
+(void)requestDataWithASIRequest:(ASIHTTPRequest*)request withSuccess:(void (^)(NSDictionary *dicData))success withFailure:(void (^)(NSError *error))failure;

///把秒数转换成时间字符串，如：61 => 1'1"
+(NSString*)formateDateStringWithSecond:(int)second;

+(BOOL)requestFailure:(NSError*)error tipMessageBlock:(void(^)(NSString *tipMsg))msg;
+ (UIImage *)getNormalImage:(UIView *)view;
//+ (NSString *)isExistenceNetwork;
/**
 * @brief
 *
 * @param
 *
 * @return networkStatus :ReachableViaWWAN：三G网络，ReachableViaWiFi：wifi网络，NotReachable：无网络
 */
+(void)judgeNetWorkStatus:(void (^)(NSString*networkStatus))networkStatus;
+ (NSString *)createMD5:(NSString *)params;
+ (NSDictionary *)initWithJSONFile:(NSString *)jsonPath;
+ (NSString *)getNowDateFromatAnDate;
+(NSDate*)getDateFromDateString:(NSString*)dateString;
+(NSString*)getStringFromDate:(NSDate*)date;
+ (void)errorAlert:(NSString *)message;
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font withWidth:(float)width;
+(NSAttributedString*)getTextSizeWithAnswerModel:(AnswerModel*)answer withFont:(UIFont*)font withWidth:(float)width;
+(CGSize)getAttributeStringSizeWithWidth:(float)width withAttributeString:(NSAttributedString*)attriString;
+ (void)setBackgroungWithView:(UIView *)view andImage6:(NSString *)str6 andImage7:(NSString *)str7;
+(CGSize)getTextSizeWithString:(NSString*)text withFont:(UIFont*)font;
+(NSString*)convertFileSizeUnitWithBytes:(NSString*)bytes;
@end
