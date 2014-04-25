//
//  RichContextObj.h
//  CaiJinTongApp
//
//  Created by david on 14-4-22.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** RichContextObj
 *
 * 问答要画的文本内容
 */
@interface RichContextObj : NSObject
///需要显示文本内容,只当richContentType＝DRURLFileType_STRING 时有用
@property (strong,nonatomic) NSString *richContext;

///显示文件的url
@property (strong,nonatomic) NSURL *richFileUrl;
///显示内容类型
@property (assign,nonatomic) DRURLFileType richContentType;

///内容画的位置
@property (assign,nonatomic) CGRect richContentRect;

///内容attributeString,,只当richContentType＝DRURLFileType_STRING 时有用
@property (strong,nonatomic) NSAttributedString *richAttributeString;
@end
