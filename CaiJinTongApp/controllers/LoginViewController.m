//
//  LoginViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "LessonViewController.h"
#import "ForgotPwdViewController.h"
#import "UserModel.h"

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
    [Utility setBackgroungWithView:self.view andImage6:@"login_bg_7.png" andImage7:@"login_bg_7.png"];
    [Utility setBackgroungWithView:self.inputView andImage6:@"login_07" andImage7:@"login_07"];

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
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
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
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    ForgotPwdViewController *fpwView = [story instantiateViewControllerWithIdentifier:@"ForgotPwdViewController"];
    [self.navigationController pushViewController:fpwView animated:YES];
}

#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"登录成功!"];
        [CaiJinTongManager shared].userId = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
        
        UserModel *user = [[UserModel alloc] init];
        user.userName = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
        user.userId = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
        user.birthday = [NSString stringWithFormat:@"%@",[result objectForKey:@"birthday"]];
        user.sex = [NSString stringWithFormat:@"%@",[result objectForKey:@"sex"]];
        user.address = [NSString stringWithFormat:@"%@",[result objectForKey:@"address"]];
        user.userImg = [NSString stringWithFormat:@"%@",[result objectForKey:@"userImg"]];
        [CaiJinTongManager shared].user = user;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            LessonViewController *lessonView = [story instantiateViewControllerWithIdentifier:@"LessonViewController"];
            [self.navigationController pushViewController:lessonView animated:YES];
            AppDelegate* appDelegate = [AppDelegate sharedInstance];
            appDelegate.lessonViewCtrol = lessonView;

        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}

@end
