//
//  DRPopupController.m
//  CaiJinTongApp
//
//  Created by david on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRPopupController.h"

@interface DRPopupController ()
@property (nonatomic ,strong) void (^dismissBlock)(BOOL dismiss);
@property (nonatomic ,strong) UIViewController *presentingController;
@property (nonatomic ,strong) UIWindow *win;
@end
@implementation DRPopupController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

+(void)popuControllerView:(UIViewController*)controller parentController:(UIViewController*)parent didDismiss:(void (^)(BOOL dismiss))dismissBlock{
    if (parent) {
        DRPopupController *popupController = [[DRPopupController alloc] init];
        popupController.dismissBlock = dismissBlock;
        popupController.presentingController = controller;
        [parent presentViewController:popupController animated:NO completion:^{
            
        }];
    }else{
        DLog(@"parent controller is NULLb");
    }

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

#pragma mark  property
-(UIWindow *)win{
    if (!_win) {
        _win = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [_win setHidden:NO];
        _win.backgroundColor = [UIColor redColor];
    }
    return _win;
}
#pragma mark --

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
