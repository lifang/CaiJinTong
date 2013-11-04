//
//  ForgotPwdViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ForgotPwdViewController.h"

@interface ForgotPwdViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
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

- (void)viewDidLoad
{
   
    [super viewDidLoad];
    self.userNameTextField.layer.cornerRadius = 5;
    self.userNameTextField.layer.borderWidth = 1;
    self.userNameTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.emailTextField.layer.cornerRadius = 5;
    self.emailTextField.layer.borderWidth = 1;
    self.emailTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
	// Do any additional setup after loading the view.
}

-(void)drnavigationBarRightItemClicked:(id)sender{
// [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    [app.popupedController dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideLeftRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendEmailBtClicked:(id)sender {
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.userNameTextField.text]) {
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            FindPassWordInterface *fpw = [[FindPassWordInterface alloc]init];
            self.fpwInterface = fpw;
            self.fpwInterface.delegate = self;
            [self.fpwInterface getFindPassWordInterfaceDelegateWithName:self.userNameTextField.text];
        }
    }else {
        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
    }
}
@end
