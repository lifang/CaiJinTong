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
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/AssetsLibrary.h>
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

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.title = @"我的资料";
    
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
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(textEdited:)];
    self.editButton = rightBar;
    
    UIBarButtonItem *rightBar2 = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(saveinfo:)];
    self.saveButton = rightBar2;
    
    self.navigationItem.rightBarButtonItem = self.editButton;
    
    imagePicker
    = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    
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
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [SVProgressHUD showWithStatus:@"玩命加载中..."];

        EditInfoInterface *chapterInter = [[EditInfoInterface alloc]init];
        self.editInfoInterface = chapterInter;
        self.editInfoInterface.delegate = self;
        
        NSData *imgData = [NSData data];
        if (UIImagePNGRepresentation(self.userImage.image) == nil) {
            imgData = UIImageJPEGRepresentation(self.userImage.image, 1);
        } else {
            imgData = UIImagePNGRepresentation(self.userImage.image);
        }
    
        [self.editInfoInterface getEditInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andBirthday:self.textField2.text andSex:self.sexStr andAddress:self.textField4.text andImage:imgData withNickName:self.textField1.text];
    }
}

-(void)textEdited:(id)sender {
    [self.textField1 setEnabled:YES];
    [self.sexSelectedView setUserInteractionEnabled:YES];
    self.textField4.userInteractionEnabled = YES;
    self.pickerBtn.hidden = NO;

//    self.navigationItem.leftBarButtonItem = self.albumButton;
    self.pickView.hidden = NO;
    self.navigationItem.rightBarButtonItem = self.saveButton;
}
- (IBAction)openAlbum:(id)sender {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]){
            [Utility errorAlert:@"PhotoLibrary is not supportted in this device."];
            return;
        }
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        if(!popover){
            popover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            [popover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }else{
            [popover dismissPopoverAnimated:YES];
             popover = nil;
        }
    }
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
        [SVProgressHUD dismissWithSuccess:@"资料更新成功!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            UserModel *user = [[CaiJinTongManager shared] user];
            user.userName = self.textField1.text;
            user.birthday = self.textField2.text;
            user.sex = self.sexStr;
            user.address = self.textField4.text;
        });
    });
}
-(void)getEditInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    self.navigationItem.leftBarButtonItem = nil;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [popover dismissPopoverAnimated:NO];
    self.navigationItem.leftBarButtonItem = nil;
    NSLog(@"imageview.image=image start");
    UIImage *image = (UIImage*)[info objectForKey:UIImagePickerControllerOriginalImage];
    self.userImage.image = image;
}

@end
