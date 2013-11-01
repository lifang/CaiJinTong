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
- (IBAction)registerBtClicked:(id)sender;

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
    
    LogInterface *log = [[LogInterface alloc]init];
    self.logInterface = log;
    self.logInterface.delegate = self;
    [CaiJinTongManager sharedInstance].sessionId = [NSString stringWithFormat:@"%@",kLogin];
    [self.logInterface getLogInterfaceDelegateWithName:@"admin" andPassWord:@"123456"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtClicked:(id)sender {
}

- (IBAction)forgotPwdBtClicked:(id)sender {
}

- (IBAction)registerBtClicked:(id)sender {
}

#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    DLog(@"finish = %@",result);
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    DLog(@"error");
}
@end
