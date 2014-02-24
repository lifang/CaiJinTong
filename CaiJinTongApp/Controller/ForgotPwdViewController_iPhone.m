//
//  ForgotPwdViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ForgotPwdViewController_iPhone.h"

@implementation ForgotPwdViewController_iPhone

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
    [self.lhlNavigationBar.rightItem setHidden:YES];
    self.lhlNavigationBar.title.text = @"找回密码";
    [self.lhlNavigationBar.rightItem setHidden:YES];
    
    [self.commitBtn addTarget:self action:@selector(commitBtnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Action Methods

- (IBAction)keyboardGoAway:(id)sender {
    [self.email resignFirstResponder];
}

-(void)commitBtnClicked{
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.email.text]) {        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:@"暂无网络"];
            }else{
                FindPassWordInterface *fpw = [[FindPassWordInterface alloc]init];
                self.fpwInterface = fpw;
                self.fpwInterface.delegate = self;
                [self.fpwInterface getFindPassWordInterfaceDelegateWithName:self.email.text];
            }
        }];
        
    }else {
        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
    }
}

#pragma mark delegate
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

-(void)leftItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
