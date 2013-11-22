//
//  ForgotPwdViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindPassWordInterface.h"
@interface ForgotPwdViewController : DRNaviGationBarController <FindPassWordInterfaceDelegate>

@property (nonatomic, strong) FindPassWordInterface *fpwInterface;
@end
