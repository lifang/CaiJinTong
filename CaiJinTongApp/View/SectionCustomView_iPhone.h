//
//  SectionCustomView_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SectionCustomView_iPhone : UIControl

@property (nonatomic, strong) UILabel *nameLab;//视频名称
@property (nonatomic, strong) UIImageView *imageView;//视频封面
@property (nonatomic,strong) UISlider *pv; //视频进度

- (id)initWithFrame:(CGRect)frame andSection:(SectionModel *)section andItemLabel:(float)itemLabel;
@end
