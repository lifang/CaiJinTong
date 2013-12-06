//
//  ForgotPwdViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNavigationBarViewController.h"
#import "FindPassWordInterface.h"
@interface ForgotPwdViewController_iPhone : LHLNavigationBarViewController<FindPassWordInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
- (IBAction)keyboardGoAway:(id)sender;

@property (strong,nonatomic) FindPassWordInterface *fpwInterface;
@end
