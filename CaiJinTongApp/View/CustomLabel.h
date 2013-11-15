//
//  CustomLabel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-8.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@interface CustomLabel : UILabel

@property (nonatomic, strong)NSMutableAttributedString *attString;

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length;

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length;

@end
