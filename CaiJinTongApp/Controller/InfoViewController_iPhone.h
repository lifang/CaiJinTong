//
//  InfoViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-10.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditInfoInterface.h"
#import "LHLNavigationBarViewController.h"
@interface InfoViewController_iPhone : LHLNavigationBarViewController<UITextFieldDelegate,UITextViewDelegate,UIPickerViewDelegate,EditInfoInterfaceDelegate>


@property (nonatomic, strong) EditInfoInterface *editInfoInterface;

@property (nonatomic, strong) IBOutlet UIImageView *userImage;
@property (nonatomic, strong) IBOutlet UITextField *textField1;
@property (nonatomic, strong) IBOutlet UITextField *textField2;
@property (nonatomic, strong) IBOutlet UITextView *textField4;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) IBOutlet UIView *pickView;
@property (nonatomic, strong) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIView *sexSelectedView;


@end