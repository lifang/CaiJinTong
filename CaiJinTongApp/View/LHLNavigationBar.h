//
//  LHLNavigationBar.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LHLNavigationBar : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *rightItem;
@property (weak, nonatomic) IBOutlet UIButton *leftItem;
@end
