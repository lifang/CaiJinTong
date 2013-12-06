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
@property (nonatomic,strong) UILabel *progressLabel;

@property (strong,nonatomic) NSString *sectionId;//保存,用于点击时接口参数

- (id)initWithFrame:(CGRect)frame andSection:(SectionModel *)section andItemLabel:(float)itemLabel;

//修改赋值
- (void)refreshDataWithSection:(SectionModel *)section;
@end
