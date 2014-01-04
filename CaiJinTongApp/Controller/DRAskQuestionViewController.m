//
//  DRAskQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRAskQuestionViewController.h"
#define DROPDOWNMENU_TITLE @"点击选择分类"
static CGRect frame;
static CGRect tableFrame;
static BOOL tableVisible;
@interface DRAskQuestionViewController ()
@property (nonatomic,assign) BOOL dropdownmenuSelected;
@property (nonatomic,strong) DRTreeTableView *categoryTreeTableView;
@end

@implementation DRAskQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.drnavigationBar.navigationRightItem.titleLabel.textColor = [UIColor grayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //设置下拉按钮
    self.dropdownmenuSelected = NO;
    [self.dropDownBt setImageEdgeInsets:UIEdgeInsetsMake(10, 590, 10, 50)];
    [self.dropDownBt setTitleEdgeInsets:UIEdgeInsetsMake(10, 5, 10,15)];
    [self.dropDownBt setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    [self.dropDownBt setTitle:DROPDOWNMENU_TITLE forState:UIControlStateNormal];
    self.questionContentTextView.delegate = self;
    [self.questionContentTextView.layer setCornerRadius:6];
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.submitButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//     [self.selectTableBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateNormal];
    
    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    
    
    self.drnavigationBar.titleLabel.text = @"我要提问";

    //问答分类
//        self.questionCategoryList = [TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]];
    self.questionCategoryList = [NSMutableArray arrayWithArray:[[CaiJinTongManager shared] questionCategoryArr]];
    [self.view addSubview:self.categoryTreeTableView];
    //tableView of 问答分类
    frame = CGRectMake(6, 160, 41, 123);//按钮坐标
    tableFrame = CGRectMake(-229, 100, 235, 370);//table坐标

    tableVisible = NO;
    
}


#pragma mark DRTreeTableViewDelegate
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
    self.selectedQuestionCategoryId = selectedNote.noteContentID;
    [self.dropDownBt setTitle:selectedNote.noteContentName forState:UIControlStateNormal];
    if (selectedNote.childnotes.count <= 0) {
        self.dropdownmenuSelected = !self.dropdownmenuSelected;
    }
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}
#pragma mark --

-(void)drnavigationBarRightItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputBegin:(id)sender {

}

- (IBAction)dropDownMenuBtClicked:(id)sender {
    self.dropdownmenuSelected = !self.dropdownmenuSelected;
}

#pragma mark property

-(void)setDropdownmenuSelected:(BOOL)dropdownmenuSelected{
    _dropdownmenuSelected = dropdownmenuSelected;
    [self.categoryTreeTableView setHidden:!dropdownmenuSelected];
}
-(DRTreeTableView *)categoryTreeTableView{
    if (!_categoryTreeTableView) {
        _categoryTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){CGRectGetMinX(self.dropDownBt.frame),CGRectGetMaxY(self.dropDownBt.frame),550,600} withTreeNodeArr:nil];
        _categoryTreeTableView.delegate = self;
        _categoryTreeTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _categoryTreeTableView;
}

- (IBAction)keyboardFuckOff:(id)sender {
    [self.questionTitleTextField resignFirstResponder];
    [self.questionContentTextView resignFirstResponder];
    [self inputBegin:nil];
}

-(void)setQuestionCategoryList:(NSMutableArray *)questionCategoryList{
    _questionCategoryList = questionCategoryList;
    self.categoryTreeTableView.noteArr = questionCategoryList;
}

#pragma mark --text View delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView{
    [self inputBegin:nil];
    return YES;
}

-(void)submitButtonClicked{
    [self.questionTitleTextField resignFirstResponder];
    [self.questionContentTextView resignFirstResponder];
    NSString *questionTitle = self.questionTitleTextField.text?[self.questionTitleTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]:@"";
    NSString *questionContent = self.questionContentTextView.text?[self.questionContentTextView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]:@"";
    
    if ([questionContent isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return ;
    }
    
//    if ([questionTitle isEqualToString:@""]) {
//        [Utility errorAlert:@"标题不能为空"];
//        return ;
//    }
    
    if (self.selectedQuestionCategoryId != nil && ![self.dropDownBt.titleLabel.text isEqualToString:DROPDOWNMENU_TITLE]){
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AskQuestionInterface *askQuestionInter = [[AskQuestionInterface alloc]init];
            self.askQuestionInterface = askQuestionInter;
            self.askQuestionInterface.delegate = self;
            [self.askQuestionInterface getAskQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.selectedQuestionCategoryId andQuestionName:questionTitle andQuestionContent:questionContent];
        }
    }else{
        [Utility errorAlert:@"请选择一个问题类型!"];
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (self.delegate && [self.delegate respondsToSelector:@selector(askQuestionViewControllerDidAskingSuccess:)]) {
        [self.delegate askQuestionViewControllerDidAskingSuccess:self];
    }
     [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark --

#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            self.questionTitleTextField.text = @"";
            self.questionContentTextView.text = @"";
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
