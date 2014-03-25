//
//  CJTMainToolbar_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-26.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CJTMainToolbar_iPhone;

@protocol CJTMainToolbar_iPhoneDelegate <NSObject>
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar recentButton:(UIButton *)button;
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar progressButton:(UIButton *)button;
- (void)tappedInToolbar:(CJTMainToolbar_iPhone *)toolbar nameButton:(UIButton *)button;
@end

@interface CJTMainToolbar_iPhone : UIView
@property (strong,nonatomic) UIButton *recentBt;
@property (strong,nonatomic) UIButton *progressBt;
@property (strong,nonatomic) UIButton *nameBt;
@property (nonatomic, assign) id <CJTMainToolbar_iPhoneDelegate> delegate;

- (void)hideToolbar;
- (void)showToolbar;

@end

