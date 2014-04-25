//
//  DRTypeQuestionContentViewController.h
//  CaiJinTongApp
//
//  Created by david on 14-4-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
/** DRTypeQuestionContentViewController
 *
 * 问答输入界面
 */
@interface DRTypeQuestionContentViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *inputBackView;
@property (weak, nonatomic) IBOutlet UITextView *inputTextView;
@property (strong,nonatomic) void (^submitFinishedBlock)(NSArray *dataArray ,NSString *errorMsg);

- (IBAction)submitBtClicked:(id)sender;


@end
