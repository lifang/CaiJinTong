//
//  SexRadioView.h
//  CaiJinTongApp
//
//  Created by david on 13-11-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SexRadioView : UIView
//sex:man is "man",female is "female"
+(SexRadioView*)defaultSexRadioViewWithFrame:(CGRect)frame  withDefaultSex:(NSString*)sex selectedSex:(void (^)(NSString *sexText))sexBlock;

//sex:man is "man",female is "female"
-(void)setSelectedSex:(NSString*)sex;
@end
