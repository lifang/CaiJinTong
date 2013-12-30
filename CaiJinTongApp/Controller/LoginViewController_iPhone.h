//
//  LoginViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+Scale.h"
#import "ForgotPwdViewController_iPhone.h"

@interface LoginViewController_iPhone : UIViewController<LogInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *findPasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerAccBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountLabel;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
- (IBAction)hideKeyboard:(id)sender;

@property (nonatomic,strong) LogInterface *logInterface;
@property (nonatomic,strong) LessonViewController *lessonView;
@end
