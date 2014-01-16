//
//  DRNavigationBar.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRSearchBar.h"
@interface DRNavigationBar : UIView
@property (strong, nonatomic)  UILabel *titleLabel;
@property (strong, nonatomic)  UIButton *navigationRightItem;
@property (strong, nonatomic)  DRSearchBar *searchBar;
@property (strong, nonatomic) UIButton *hiddenBtn;
-(void)hiddleBackButton:(BOOL)isHidden;
@end
