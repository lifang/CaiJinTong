//
//  DRTypeQuestionContentViewController.m
//  CaiJinTongApp
//
//  Created by david on 14-4-25.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRTypeQuestionContentViewController.h"
#import "QuestionRequestDataInterface.h"
@interface DRTypeQuestionContentViewController ()

@end

@implementation DRTypeQuestionContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)submitBtClicked:(id)sender {
    if ([self.inputTextView.text isEqualToString:@""]) {
        [Utility errorAlert:@"输入字符不能为空"];
        return;
    }
    switch ([CaiJinTongManager shared].reaskType) {
        case ReaskType_Answer:
        {
            QuestionModel *question = [CaiJinTongManager shared].questionModel;
            __weak DRTypeQuestionContentViewController *weakSelf = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [QuestionRequestDataInterface submitAnswerWithUserId:[CaiJinTongManager shared].user.userId andReaskTyep:[CaiJinTongManager shared].reaskType andAnswerContent:self.inputTextView.text andQuestionModel:question andAnswerID:nil withSuccess:^(NSArray *answerModelArray) {
                DRTypeQuestionContentViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                    if (tempSelf.submitFinishedBlock) {
                        tempSelf.submitFinishedBlock(answerModelArray,nil);
                    }
                    [tempSelf dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            } withError:^(NSError *error) {
                DRTypeQuestionContentViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            }];
        }
            break;
            
        default:
            break;
    }
}


-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,20,self.inputBackView.frame.size};
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)keyBoardDOWN:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,70,self.inputBackView.frame.size};
    } completion:^(BOOL finished) {
        
    }];
}
@end
