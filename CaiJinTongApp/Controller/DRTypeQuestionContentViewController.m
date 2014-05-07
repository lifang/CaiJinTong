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
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardUP:) name:UIKeyboardWillShowNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDOWN:) name: UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)leftItemClicked:(id)sender{
    [self.inputTextView resignFirstResponder];
 [self dismissViewControllerAnimated:YES completion:^{
     
 }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.inputTextView.layer.cornerRadius = 5;
    [self.lhlNavigationBar.rightItem setHidden:YES];
    self.inputTextView.backgroundColor = [Utility colorWithHex:0xf8f8f8];
    self.inputTextView.layer.borderWidth = 1;
    self.inputTextView.layer.borderColor = [Utility colorWithHex:0xe6e6e6].CGColor;
    self.submitBt.layer.borderWidth = 1;
    self.submitBt.layer.borderColor = [Utility colorWithHex:0xa3cff8].CGColor;
    [self.submitBt setBackgroundColor:[Utility colorWithHex:0xe0f0ff]];
    [self.submitBt setTitleColor:[Utility colorWithHex:0x1d7cba] forState:UIControlStateNormal];
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
        case ReaskType_Reask:
        case ReaskType_ModifyReask:
        case ReaskType_ModifyAnswer:
        case ReaskType_ModifyReaskAnswer:
        case ReaskType_AnswerForReasking:
        case ReaskType_Answer:
        {
            QuestionModel *question = [CaiJinTongManager shared].questionModel;
            __weak DRTypeQuestionContentViewController *weakSelf = self;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [QuestionRequestDataInterface submitAnswerWithUserId:[CaiJinTongManager shared].user.userId andReaskTyep:[CaiJinTongManager shared].reaskType andAnswerContent:self.inputTextView.text andQuestionModel:question andAnswerID:[CaiJinTongManager shared].answerModel?[CaiJinTongManager shared].answerModel.answerId:nil withSuccess:^(NSArray *answerModelArray) {
                for (AnswerModel *answer in answerModelArray) {
                    QuestionModel *questionM = answer.questionModel;
                    if ([questionM.isAcceptAnswer isEqualToString:@"1"]) {
                        break;
                    }else{
                        if ([answer.answerIsCorrect isEqualToString:@"1"]) {
                            questionM.isAcceptAnswer = answer.answerIsCorrect;
                        }
                    }
                }
                DRTypeQuestionContentViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                    [tempSelf dismissViewControllerAnimated:YES completion:^{
                        if (tempSelf.submitFinishedBlock) {
                            tempSelf.submitFinishedBlock(answerModelArray,nil);
                        }
                    }];
                }
            } withError:^(NSError *error) {
                DRTypeQuestionContentViewController *tempSelf = weakSelf;
                if (tempSelf) {
                    [Utility errorAlert:[error.userInfo objectForKey:@"msg"]];
                    [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (IBAction)backViewBtClicked:(id)sender {
    [self.inputTextView resignFirstResponder];
}


-(void)keyBoardUP:(NSNotification*)notification{
    NSTimeInterval animationDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:animationDuration animations:^{
        self.inputBackView.frame = (CGRect){0,70,self.inputBackView.frame.size};
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
