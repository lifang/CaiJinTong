//
//  ForgotPwdViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FindPassWordInterface.h"
@interface ForgotPwdViewController : UIViewController <FindPassWordInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UIView *textFieldBackView;

@property (nonatomic, strong) FindPassWordInterface *fpwInterface;
@end
