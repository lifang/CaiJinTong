//
//  CJTMainToolbar.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CJTToolbarView.h"

@class CJTMainToolbar;

@protocol CJTMainToolbarDelegate <NSObject>
- (void)tappedInToolbar:(CJTMainToolbar *)toolbar doneButton:(UIButton *)button;
@end

@interface CJTMainToolbar : CJTToolbarShadow

@property (nonatomic, assign) id <CJTMainToolbarDelegate> delegate;

- (void)hideToolbar;
- (void)showToolbar;

@end
