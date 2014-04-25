//
//  RichQuestionContentView.h
//  CaiJinTongApp
//
//  Created by david on 14-4-22.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RichContextObj.h"
#import "UIImageView+WebCache.h"
/** RichQuestionContentView
 *
 * 显示文本，图片，表情，和图标，点击可以下载查看
 */
@interface RichQuestionContentView : UIView
///存放要显示对象
@property (strong,nonatomic) NSArray *contentObjsArray;

///点击图片类型时显示
@property (strong,nonatomic) void (^tapedimageTypeBlock)(RichContextObj *richContent);

///设置显示内容，contentArray 存放RichContextObj
-(void)addContentArray:(NSArray*)contentArray withWidth:(float)width finished:(void (^)(RichContextObj *richContent))finished;
//////组合所有的RichContextObj 内容得到高度，richContentArray存放RichContextObj对象数组
+(CGRect)richQuestionContentStringWithRichContentObjs:(NSArray*)richContentArray withWidth:(float)width;
@end
