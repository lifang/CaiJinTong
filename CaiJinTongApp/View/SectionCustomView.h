//
//  SectionCustomView.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMProgressView.h"
#import "SectionModel.h"

@interface SectionCustomView : UIControl

@property (nonatomic, strong) UILabel *nameLab;//视频名称
@property (nonatomic, strong) UIImageView *imageView;//视频封面
@property (nonatomic, strong) AMProgressView *pv;//视频进度

- (id)initWithFrame:(CGRect)frame andSection:(SectionModel *)section;
@end
