//
//  CollectionCell.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-6.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LessonModel.h"
#import "CJTSlider.h"
@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIView *imageBackView;
@property (weak, nonatomic) IBOutlet UIImageView *lessonImageView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *progressTrackImageView;
@property (weak, nonatomic) IBOutlet UILabel *lessonNameLabel;

-(void)changeLessonModel:(LessonModel*)lessonModel;
@end
