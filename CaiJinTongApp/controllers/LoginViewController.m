//
//  LoginViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
- (IBAction)loginBtClicked:(id)sender;
- (IBAction)forgotPwdBtClicked:(id)sender;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtClicked:(id)sender {
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.userNameTextField.text]) {
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            LogInterface *log = [[LogInterface alloc]init];
            self.logInterface = log;
            self.logInterface.delegate = self;
            [self.logInterface getLogInterfaceDelegateWithName:self.userNameTextField.text andPassWord:self.pwdTextField.text];
        }
    }else {
        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
    }
}

- (IBAction)forgotPwdBtClicked:(id)sender {
}

#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    DLog(@"finish = %@",result);
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    DLog(@"error");
}
@end
