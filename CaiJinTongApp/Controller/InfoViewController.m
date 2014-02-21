//
//  InfoViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "InfoViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "SexRadioView.h"
@interface InfoViewController ()
@property (nonatomic,strong) SexRadioView *sexRadio;
@property (nonatomic,strong)  NSString *sexStr;
@end
#define kPickerAnimationDuration 0.40
@implementation InfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)drnavigationBarRightItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)returnBackBtClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
//    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
//    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    self.drnavigationBar.titleLabel.text = @"我的资料";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[CaiJinTongManager shared].user.userImg]];
    [self.userImage setImageWithURL:url placeholderImage:Image(@"loginBgImage_v.png")];
    self.textField2.text = [CaiJinTongManager shared].user.birthday;
    NSString *sex =  [[CaiJinTongManager shared].user.sex isEqualToString:@"1"]?@"man":@"female";
    self.sexRadio = [SexRadioView defaultSexRadioViewWithFrame:(CGRect){0,0,self.sexSelectedView.frame.size} withDefaultSex:sex selectedSex:^(NSString *sexText) {
        self.sexStr = [sex isEqualToString:@"男"]?@"1":@"0";
    }];
    [self.sexSelectedView addSubview:self.sexRadio];
    self.textField1.text = [CaiJinTongManager shared].user.userName;
    self.textField4.text = [CaiJinTongManager shared].user.address;
    
    self.textField4.layer.masksToBounds = YES;
    self.textField4.layer.cornerRadius = 6;
    [self.textField4 setKeyboardType:UIKeyboardTypeDefault];
    
    self.textField1.tag = 1;
    self.textField2.tag = 2;
    self.sexSelectedView.tag = 3;
    self.textField4.tag = 4;
    
    [self.textField1 setEnabled:NO];
    [self.textField2 setEnabled:NO];
    [self.sexSelectedView setUserInteractionEnabled:NO];
    self.textField4.userInteractionEnabled = NO;
    
    self.pickerBtn.hidden = YES;
    self.pickView.hidden = YES;
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
//    self.drnavigationBar.hiddenBtn.hidden = YES;
//    [self.drnavigationBar.hiddenBtn setTitle:@"编辑" forState:UIControlStateNormal];
//    [self.drnavigationBar.hiddenBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [self.drnavigationBar.hiddenBtn addTarget:self action:@selector(textEdited:) forControlEvents:UIControlEventTouchUpInside];
//    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShowing:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHideing:) name: UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)saveinfo:(id)sender {
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField4 resignFirstResponder];
    self.navigationItem.leftBarButtonItem = nil;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{            
            EditInfoInterface *chapterInter = [[EditInfoInterface alloc]init];
            self.editInfoInterface = chapterInter;
            self.editInfoInterface.delegate = self;
            [self.editInfoInterface getEditInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andBirthday:self.textField2.text andSex:self.sexStr andAddress:self.textField4.text withNickName:self.textField1.text];
        }
    }];
}

-(void)textEdited:(id)sender {
    [self.textField1 setEnabled:YES];
    [self.sexSelectedView setUserInteractionEnabled:YES];
    self.textField4.userInteractionEnabled = YES;
    self.pickerBtn.hidden = NO;

    self.pickView.hidden = NO;
    
//    [self.drnavigationBar.hiddenBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [self.drnavigationBar.hiddenBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    [self.drnavigationBar.hiddenBtn addTarget:self action:@selector(saveinfo:) forControlEvents:UIControlEventTouchUpInside];
//    [self.drnavigationBar.hiddenBtn setHidden:YES];
}

-(IBAction)showPicker:(id)sender {
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];
    [self.textField4 resignFirstResponder];
    
    //初识状态
    if(self.textField2.text.length >0) {
        self.pickerView.date = [self.dateFormatter dateFromString:self.textField2.text];
    }else {
        self.pickerView.date = [NSDate date];
    }
    if ([CaiJinTongManager shared].tagOfBtn == 0) {
        CGRect startFrame = self.pickView.frame;
        CGRect endFrame = self.pickView.frame;
        startFrame.origin.y = self.view.frame.size.height;
        endFrame.origin.y = startFrame.origin.y - endFrame.size.height;
        self.pickView.frame = startFrame;
        [self.view addSubview:self.pickView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:kPickerAnimationDuration];
        self.pickView.frame = endFrame;
        [UIView commitAnimations];
        [CaiJinTongManager shared].tagOfBtn = 1;
    }
    
}
- (void)slideDownDidStop
{
	[self.pickView removeFromSuperview];
}
-(IBAction)pickerViewDown:(id)sender {
    CGRect pickerFrame = self.pickView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickView.frame = pickerFrame;
    [UIView commitAnimations];
    [CaiJinTongManager shared].tagOfBtn = 0;
}

- (void)keyBoardWillShowing:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect pickerFrame = self.pickView.frame;
    pickerFrame.origin.y = self.view.frame.size.height;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:kPickerAnimationDuration];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(slideDownDidStop)];
    self.pickView.frame = pickerFrame;
    [UIView commitAnimations];
    [CaiJinTongManager shared].tagOfBtn = 0;
}

- (void)keyBoardWillHideing:(id)sender{
    [UIView beginAnimations:nil context:nil];

    [UIView commitAnimations];
}
- (IBAction)dateAction:(id)sender
{
	self.textField2.text = [self.dateFormatter stringFromDate:self.pickerView.date];
}

#pragma mark -- EditInfoInterfaceDelegate

-(void)getEditInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.navigationController popViewControllerAnimated:YES];
            UserModel *user = [[CaiJinTongManager shared] user];
            user.userName = self.textField1.text;
            user.birthday = self.textField2.text;
            user.sex = self.sexStr;
            user.address = self.textField4.text;

        });
    });
}
-(void)getEditInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}


@end
