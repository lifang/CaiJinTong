//
//  ForgotPwdViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ForgotPwdViewController.h"

@interface ForgotPwdViewController ()

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
- (IBAction)sendEmailBtClicked:(id)sender;

@end

@implementation ForgotPwdViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)backBtClicked:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.textFieldBackView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.textFieldBackView.layer.borderWidth = 1.0;
    self.textFieldBackView.layer.cornerRadius = 5;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmailBtClicked:(id)sender {
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.emailTextField.text]) {
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            FindPassWordInterface *fpw = [[FindPassWordInterface alloc]init];
            self.fpwInterface = fpw;
            self.fpwInterface.delegate = self;
            [self.fpwInterface getFindPassWordInterfaceDelegateWithName:self.emailTextField.text];
        }
    }else {
        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
    }
}

#pragma  -- delegate
-(void)getFindPassWordInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
        });
    });
}
-(void)getFindPassWordInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}

@end
