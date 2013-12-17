//
//  SectionCustomView.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SectionModel.h"
#import "CJTSlider.h"
@interface SectionCustomView : UIControl

@property (nonatomic, strong) UILabel *nameLab;//视频名称
@property (nonatomic, strong) UIImageView *imageView;//视频封面
@property (nonatomic,strong) CJTSlider *pv; //视频进度
@property (nonatomic,strong) UILabel *progressLabel;

- (id)initWithFrame:(CGRect)frame andSection:(SectionModel *)section andItemLabel:(float)itemLabel;
-(void)changeSectionModel:(SectionModel*)section;
@end
