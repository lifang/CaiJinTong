//
//  CustomButton.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SectionModel.h"
@interface CustomButton : UIButton<UIAlertViewDelegate>
@property (nonatomic, assign) BOOL isMovieView;//是否在播放界面显示
@property (nonatomic, strong) SectionModel *buttonModel;
@end
