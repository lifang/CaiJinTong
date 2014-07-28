//
//  LoginViewController.h
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LogInterface.h"
@interface LoginViewController : UIViewController<LogInterfaceDelegate>
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIView *inputContainerView;

@property (nonatomic,strong) LogInterface *logInterface;
@end
