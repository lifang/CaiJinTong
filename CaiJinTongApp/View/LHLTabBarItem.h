//
//  LHLTabBarItem.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-11.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHLTabBarItem : UIView
@property (strong,nonatomic) UIImageView *imageView;
@property (strong,nonatomic) UILabel *titleLabel;
@property (assign,nonatomic) BOOL selected;

-(LHLTabBarItem *) initWithTitle:(NSString *) title andImage:(UIImage *) image;
@end
