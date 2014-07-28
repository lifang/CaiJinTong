//
//  LHLNavigationBar.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LHLNavigationBarDelegate <NSObject>
@optional
-(void)rightItemClicked;
@end

@interface LHLNavigationBar : UIView
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UIButton *rightItem;
@property (strong, nonatomic) IBOutlet UIButton *leftItem;

@property (strong, nonatomic) id<LHLNavigationBarDelegate> delegate;
@end

