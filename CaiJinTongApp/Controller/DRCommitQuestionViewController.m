//
//  DRCommitQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRCommitQuestionViewController.h"
#define DROPDOWNMENU_TITLE @"点击选择分类"
static CGRect frame;
static CGRect tableFrame;
@interface DRCommitQuestionViewController ()
@property (nonatomic,assign) BOOL dropdownmenuSelected;
@property (nonatomic,strong) DRTreeTableView *categoryTreeTableView;
@property (weak, nonatomic) IBOutlet UIImageView *cutImageView;
@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;//获取所有问答分类
@end

@implementation DRCommitQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)keyBoardWillHide:(id)sender{
    CGRect selfRect = self.view.frame;
    self.view.frame = (CGRect){selfRect.origin.x,100,selfRect.size};
}

-(void)keyBoardWillShow:(id)sender{
    CGRect selfRect = self.view.frame;
    self.view.frame = (CGRect){selfRect.origin.x,10,selfRect.size};
}

-(void)popouViewFinishedFrameRect:(id)sender{
    NSArray *questionCategoryArr = [[CaiJinTongManager shared] questionCategoryArr];
    if (questionCategoryArr && questionCategoryArr.count > 0) {
         [self.titleField becomeFirstResponder];
    }
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.cutImageView.image = nil;
    [self.cutImageView setHidden:NO];
    self.dropdownmenuSelected = NO;
    [self.dropDownBt setImageEdgeInsets:UIEdgeInsetsMake(10, 400, 10, 50)];
    [self.dropDownBt setTitleEdgeInsets:UIEdgeInsetsMake(10, 5, 10,15)];
    [self.dropDownBt setImage:[UIImage imageNamed:@"open.png"] forState:UIControlStateNormal];
    [self.dropDownBt setTitle:DROPDOWNMENU_TITLE forState:UIControlStateNormal];
    
    
    self.contentField.delegate = self;
    self.commitTimeLabel.text = [Utility getNowDateFromatAnDate];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    
    self.contentField.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentField.layer.borderWidth =1.0;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];

    //问答分类
    //        self.questionCategoryList = [TestModelData getTreeNodeArrayFromArray:[TestModelData loadJSON]];
    NSArray *questionCategoryArr = [[CaiJinTongManager shared] questionCategoryArr];
    if (!questionCategoryArr || questionCategoryArr.count <= 0) {
        [self getQuestionInfo];
    }else{
        self.questionCategoryList = [NSMutableArray arrayWithArray:questionCategoryArr];
    }
    
    [self.view addSubview:self.categoryTreeTableView];
    
    frame = CGRectMake(6, 151, 41, 80);//按钮坐标
    tableFrame = CGRectMake(-229, 30, 235, 300);//table坐标
}

//获取所有问答分类信息
-(void)getQuestionInfo  {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
            self.questionInfoInterface = questionInfoInter;
            self.questionInfoInterface.delegate = self;
            [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)spaceAreaClicked:(id)sender {
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerCancel)]) {
        [self.delegate commitQuestionControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender{
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
    NSString *questionTitle = self.titleField.text?[self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]:@"";
    NSString *questionContent = self.contentField.text?[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]:@"";
    
    if ([questionContent isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return ;
    }
    
    if ([questionTitle isEqualToString:@""]) {
        [Utility errorAlert:@"标题不能为空"];
        return ;
    }
    
    if (self.selectedQuestionCategoryId != nil && ![self.dropDownBt.titleLabel.text isEqualToString:DROPDOWNMENU_TITLE]){
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionController:didCommitQuestionWithTitle:andText:andQuestionId:)]) {
            [self.delegate commitQuestionController:self didCommitQuestionWithTitle:self.titleField.text andText:self.contentField.text andQuestionId:self.selectedQuestionCategoryId];
        }
    }else{
        [Utility errorAlert:@"请选择一个问题类型!"];
    }
}

- (IBAction)inputBegin:(id)sender {

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

-(void)drTreeTableView:(DRTreeTableView *)treeView didCloseChildTreeNode:(DRTreeNode *)extendNote{
    
}

-(void)drTreeTableView:(DRTreeTableView *)treeView didExtendChildTreeNode:(DRTreeNode *)extendNote{
}

#pragma mark --

#pragma mark--QuestionInfoInterfaceDelegate 获取所有问答分类信息
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [[CaiJinTongManager shared] setQuestionCategoryArr:questionCategoryArr] ;
        self.categoryTreeTableView.noteArr = [NSMutableArray arrayWithArray:questionCategoryArr];
         [self.titleField becomeFirstResponder];
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });

}


#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            self.titleField.text = @"";
            self.contentField.text = @"";
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}

- (IBAction)dropDownMenuBtClicked:(id)sender {
    self.dropdownmenuSelected = !self.dropdownmenuSelected;
}

//点击截图
- (IBAction)scanScreenBtClicked:(id)sender {
    self.isCut = YES;
    self.cutImage = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerDidStartCutScreenButtonClicked:)]) {
        
        self.cutImage = [self.delegate commitQuestionControllerDidStartCutScreenButtonClicked:self];
        self.cutImageView.image = self.cutImage;
        if (self.cutImageView.image) {
            [sender setHidden:YES];
        }else{
            MBProgressHUD *progress = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            progress.labelText = @"无法截取视频，请查看播放的视频是否正确";
            progress.mode = MBProgressHUDModeText;
            progress.removeFromSuperViewOnHide = YES;
            [progress hide:YES afterDelay:2.0];
        }
    }
}

#pragma mark property

-(void)setDropdownmenuSelected:(BOOL)dropdownmenuSelected{
    _dropdownmenuSelected = dropdownmenuSelected;
    [self.categoryTreeTableView setHidden:!dropdownmenuSelected];
}
-(DRTreeTableView *)categoryTreeTableView{
    if (!_categoryTreeTableView) {
        _categoryTreeTableView = [[DRTreeTableView alloc] initWithFrame:(CGRect){CGRectGetMinX(self.dropDownBt.frame),CGRectGetMaxY(self.dropDownBt.frame),470,300} withTreeNodeArr:nil];
        _categoryTreeTableView.delegate = self;
        _categoryTreeTableView.backgroundColor = [UIColor lightGrayColor];
    }
    return _categoryTreeTableView;
}

-(void)setQuestionCategoryList:(NSMutableArray *)questionCategoryList{
    _questionCategoryList = questionCategoryList;
    self.categoryTreeTableView.noteArr = questionCategoryList;
}

#pragma mark --
#pragma mark textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}

@end
