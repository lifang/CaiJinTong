//
//  DRAskQuestionViewController.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRNaviGationBarController.h"
#import "AskQuestionInterface.h"
#import "DRTreeTableView.h"
@protocol DRAskQuestionViewControllerDelegate;
@interface DRAskQuestionViewController : DRNaviGationBarController<UITextViewDelegate,AskQuestionInterfaceDelegate,UIAlertViewDelegate,DRTreeTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *dropDownBt;
@property (weak, nonatomic) IBOutlet UITextField *questionTitleTextField;
@property (weak, nonatomic) IBOutlet UITextView *questionContentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (nonatomic, strong) NSMutableArray *questionCategoryList;
@property (nonatomic, strong) AskQuestionInterface *askQuestionInterface;
@property (weak,nonatomic) id<DRAskQuestionViewControllerDelegate> delegate;

@property (nonatomic,strong) NSString *selectedQuestionCategoryId;
- (IBAction)keyboardFuckOff:(id)sender;
- (IBAction)inputBegin:(id)sender;
- (IBAction)dropDownMenuBtClicked:(id)sender;
@end

@protocol DRAskQuestionViewControllerDelegate <NSObject>

-(void)askQuestionViewControllerDidAskingSuccess:(DRAskQuestionViewController*)controller;

@end