//
//  LoginViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LoginViewController_iPhone.h"
#import "StudySummaryViewController_iphone.h"
@implementation LoginViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.center = (CGPoint){self.view.center.x,160};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.view.center = (CGPoint){self.view.center.x,(CGRectGetHeight(self.view.frame))/2};
    } completion:^(BOOL finished) {
        
    }];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *userName = [[NSUserDefaults standardUserDefaults] stringForKey:kUserName];
    NSString *pwd = [[NSUserDefaults standardUserDefaults] stringForKey:kPassword];
    self.accountLabel.text = userName?:@"";
    self.passwordTextField.text = pwd?:@"";
    //压缩图片
    UIImage *bgImage = [[UIImage imageNamed:@"_loginBG.png"] scaleToSize:CGSizeMake(320, SCREEN_HEIGHT)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:bgImage];
    
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"bttn1.png"] forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.findPasswordBtn addTarget:self action:@selector(findPasswordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.registerAccBtn addTarget:self action:@selector(registerAccBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //注册账号btn暂时改为设置
    [self.registerAccBtn setTitle:@"设置" forState:UIControlStateNormal];
 
    UserModel *user = [[UserModel alloc] init];
    [user unarchiverUser];
//    if (user.userId && ![user.userId isEqualToString:@""]) {
//        [CaiJinTongManager shared].user = user;
//        [CaiJinTongManager shared].userId = user.userId;
//        StudySummaryViewController_iphone *studySummaryController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudySummaryViewController_iphone"];
//        self.loginNaviController = nil;
//        self.loginNaviController = [[UINavigationController alloc] initWithRootViewController:studySummaryController];
//        [self.loginNaviController setNavigationBarHidden:YES];
//        [self.loginNaviController setHidesBottomBarWhenPushed:YES];
//        [self presentViewController:self.loginNaviController animated:NO completion:^{
//            
//        }];
//    }
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
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        LogInterface *log = [[LogInterface alloc]init];
        self.logInterface = log;
        self.logInterface.delegate = self;
        [self.logInterface getLogInterfaceDelegateWithName:self.accountLabel.text andPassWord:self.passwordTextField.text];
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
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController_iPhone"] animated:YES];
}

#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UserModel *user = [[UserModel alloc] init];
        user.userId = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
        //        if ([self.userNameTextField.text isEqualToString:@"18621607181"]) {
        //            user.userId = @"17082";
        //            [CaiJinTongManager shared].userId = @"17082";
        //        }else{
        //            user.userId = @"18676";
        //            [CaiJinTongManager shared].userId = @"18676";
        //        }
        user.userName = [NSString stringWithFormat:@"%@",[result objectForKey:@"name"]];
        user.email = [NSString stringWithFormat:@"%@",[result objectForKey:@"email"]];
        user.mobile = [NSString stringWithFormat:@"%@",[result objectForKey:@"mobile"]];
        user.birthday = [NSString stringWithFormat:@"%@",[result objectForKey:@"birthday"]];
        user.sex = [NSString stringWithFormat:@"%@",[result objectForKey:@"sex"]];
        user.address = [NSString stringWithFormat:@"%@",[result objectForKey:@"address"]];
        user.userImg = [NSString stringWithFormat:@"%@",[result objectForKey:@"userImg"]];
        user.nickName = [NSString stringWithFormat:@"%@",[result objectForKey:@"nickname"]];
        [user archiverUser];
        [CaiJinTongManager shared].user = user;
        [[CaiJinTongManager shared] setUserId:user.userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [[NSUserDefaults standardUserDefaults] setValue:self.accountLabel.text forKey:kUserName];
            [[NSUserDefaults standardUserDefaults] setValue:self.passwordTextField.text forKey:kPassword];

            StudySummaryViewController_iphone *studySummaryController = [self.storyboard instantiateViewControllerWithIdentifier:@"StudySummaryViewController_iphone"];
            self.loginNaviController = nil;
            self.loginNaviController = [[UINavigationController alloc] initWithRootViewController:studySummaryController];
            [self.loginNaviController setNavigationBarHidden:YES];
            [self.loginNaviController setHidesBottomBarWhenPushed:YES];
            [self presentViewController:self.loginNaviController animated:YES completion:^{
                
            }];
        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}


@end
