//
//  CollectionCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionModel.h"
#import "CJTSlider.h"
@interface CollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *nameLab;//视频名称
@property (nonatomic, strong) UIImageView *imageView;//视频封面
@property (nonatomic, strong) CJTSlider *pv; //视频进度
@property (nonatomic, strong) UILabel *progressLabel;
@end
