//
//  LoginViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LoginViewController_iPhone.h"

@interface LoginViewController_iPhone ()

@end

@implementation LoginViewController_iPhone

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
    //背景
//    [Utility setBackgroungWithView:self.view andImage6:@"login_bg_7.png" andImage7:@"login_bg_7.png"];
    //压缩图片
    UIImage *bgImage = [[UIImage imageNamed:@"login_bg_7.png"] scaleToSize:CGSizeMake(320, 568)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    UIImage *loginBtnImage = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6)];
    [self.loginBtn setBackgroundImage:loginBtnImage forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.findPasswordBtn addTarget:self action:@selector(findPasswordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.registerAccBtn addTarget:self action:@selector(registerAccBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 动作方法
- (IBAction)hideKeyboard:(id)sender {
    [self.accountLabel resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)loginBtnClicked{
    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.accountLabel.text]) {
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            LogInterface *log = [[LogInterface alloc]init];
            self.logInterface = log;
            self.logInterface.delegate = self;
            [self.logInterface getLogInterfaceDelegateWithName:self.accountLabel.text andPassWord:self.passwordTextField.text];
        }
    }else {
        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
    }
}

-(void)findPasswordBtnClicked{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    ForgotPwdViewController_iPhone *forgot = [story instantiateViewControllerWithIdentifier:@"ForgotPwdViewController_iPhone"];
    [self.navigationController pushViewController:forgot animated:YES];
}

-(void)registerAccBtnClicked{
    
}

#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
            LessonViewController *lessonView = [story instantiateViewControllerWithIdentifier:@"TabBarController"];
            [self.navigationController pushViewController:lessonView animated:YES];
            AppDelegate* appDelegate = [AppDelegate sharedInstance];
            appDelegate.lessonViewCtrol = lessonView;
            
        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}


@end