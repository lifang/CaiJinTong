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
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBt;
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
    self.inputView.layer.borderWidth = 2;
    self.inputView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    NSString *text = @"找回密码";
     [self.forgotPwdBt setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.forgotPwdBt setTitle:text forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name: UIKeyboardWillHideNotification object:nil];
//    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
//    [attri addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, text.length)];
//    [attri addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange(0, text.length)];
//    self.forgotPwdBt.titleLabel.attributedText = attri;

}

-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputContainerView.frame = (CGRect){0,768-251-370,1024,289};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputContainerView.frame = (CGRect){0,768-251,1024,289};
    } completion:^(BOOL finished) {
        
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtClicked:(id)sender {
    [self getLogInfoDidFinished:nil];
    return;
//    NSString *regexCall = @"(\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*)|(1[0-9]{10})";
//    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
//    if ([predicateCall evaluateWithObject:self.userNameTextField.text]) {
//        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//            [Utility errorAlert:@"暂无网络!"];
//        }else {
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            LogInterface *log = [[LogInterface alloc]init];
//            self.logInterface = log;
//            self.logInterface.delegate = self;
//            [self.logInterface getLogInterfaceDelegateWithName:self.userNameTextField.text andPassWord:self.pwdTextField.text];
//        }
//    }else {
//        [Utility errorAlert:@"请输入正确的手机号码或邮箱!"];
//    }
    if (self.userNameTextField.text && ![[self.userNameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        if (self.pwdTextField.text && ![[self.pwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
//            if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//                [Utility errorAlert:@"暂无网络!"];
//            }else {
                [MBProgressHUD showHUDAddedTo:self.view animated:YES];
                LogInterface *log = [[LogInterface alloc]init];
                self.logInterface = log;
                self.logInterface.delegate = self;
                [self.logInterface getLogInterfaceDelegateWithName:self.userNameTextField.text andPassWord:self.pwdTextField.text];
//            }
        }else{
            [Utility errorAlert:@"密码不能为空"];
        }
    }else{
        [Utility errorAlert:@"用户名不能为空"];
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
        UserModel *user = [[UserModel alloc] init];
        user.userName = [NSString stringWithFormat:@"%@",[result objectForKey:@"userId"]];
        
        if ([self.userNameTextField.text isEqualToString:@"18621607181"]) {
            user.userId = @"17082";
            [CaiJinTongManager shared].userId = @"17082";
        }else{
            user.userId = @"18676";
            [CaiJinTongManager shared].userId = @"18676";
        }
        user.birthday = [NSString stringWithFormat:@"%@",[result objectForKey:@"birthday"]];
        user.sex = [NSString stringWithFormat:@"%@",[result objectForKey:@"sex"]];
        user.address = [NSString stringWithFormat:@"%@",[result objectForKey:@"address"]];
        user.userImg = [NSString stringWithFormat:@"%@",[result objectForKey:@"userImg"]];
        user.nickName = [NSString stringWithFormat:@"%@",[result objectForKey:@"nickname"]];
        [CaiJinTongManager shared].user = user;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
            LessonViewController *lessonView = [story instantiateViewControllerWithIdentifier:@"LessonViewController"];
            [self.navigationController pushViewController:lessonView animated:YES];
            AppDelegate* appDelegate = [AppDelegate sharedInstance];
            appDelegate.lessonViewCtrol = lessonView;

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
