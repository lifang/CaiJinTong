//
//  CJTMainToolbar.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//


@class CJTMainToolbar;

@protocol CJTMainToolbarDelegate <NSObject>
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar recentButton:(UIButton *)button;
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar progressButton:(UIButton *)button;
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar nameButton:(UIButton *)button;
@end

@interface CJTMainToolbar : UIView

@property (nonatomic, assign) id <CJTMainToolbarDelegate> delegate;

- (void)hideToolbar;
- (void)showToolbar;

@end
