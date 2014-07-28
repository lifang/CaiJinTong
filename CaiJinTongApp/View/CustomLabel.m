//
//  CustomLabel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-8.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CustomLabel.h"

@implementation CustomLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect{
    for (CATextLayer *textLayer in [self.layer sublayers]) {
        if ([textLayer.name isEqualToString:@"textLayer"]) {
             [textLayer removeFromSuperlayer];
        }
       
    }
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.string = _attString;
    textLayer.name = @"textLayer";
    textLayer.frame = CGRectMake(3, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:textLayer];
}

- (void)setText:(NSString *)text{
    [super setText:text];
    if (text == nil) {
        self.attString = nil;
    }else{
        self.attString = [[NSMutableAttributedString alloc] initWithString:text];
    }
}

// 设置某段字的颜色
- (void)setColor:(UIColor *)color fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTForegroundColorAttributeName
                       value:(id)color.CGColor
                       range:NSMakeRange(location, length)];
}

// 设置某段字的字体
- (void)setFont:(UIFont *)font fromIndex:(NSInteger)location length:(NSInteger)length{
    if (location < 0||location>self.text.length-1||length+location>self.text.length) {
        return;
    }
    [_attString addAttribute:(NSString *)kCTFontAttributeName
                       value:(__bridge id)CTFontCreateWithName((CFStringRef)font.fontName,
                                                      font.pointSize,
                                                      NULL)
                       range:NSMakeRange(location, length)];
}


@end
