//
//  DRNavigationBar.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DRNavigationBar : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIButton *navigationRightItem;
@property (strong, nonatomic) UIButton *hiddenBtn;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
