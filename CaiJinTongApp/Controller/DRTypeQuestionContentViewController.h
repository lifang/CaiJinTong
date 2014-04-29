//
//  DRTypeQuestionContentViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-4-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LHLNavigationBarViewController.h"
/** DRTypeQuestionContentViewController
 *
 * 问答输入界面
 */
@interface DRTypeQuestionContentViewController : LHLNavigationBarViewController
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong,nonatomic) void (^submitFinishedBlock)(NSArray *dataArray ,NSString *errorMsg);
@property (weak, nonatomic) IBOutlet UIButton *submitBt;

- (IBAction)submitBtClicked:(id)sender;

- (IBAction)backViewBtClicked:(id)sender;

@end
