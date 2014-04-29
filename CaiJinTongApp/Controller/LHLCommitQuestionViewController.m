//
//  LHLCommitQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLCommitQuestionViewController.h"
@interface LHLCommitQuestionViewController ()
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
//@property (weak, nonatomic) IBOutlet UILabel *categoryTextField;
- (IBAction)screenShotButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *screenShotImageView;
@property (assign,nonatomic) BOOL tableVisible;
@property (strong,nonatomic) DRTreeTableView *treeView;
@property (strong,nonatomic) NSMutableArray *questionList;
@property (assign,nonatomic) CGRect frame; // 按钮初始坐标
@property (assign,nonatomic) CGRect tableFrame;  //table初始坐标
@property (assign,nonatomic) CGRect defaultFrame;
@property (assign,nonatomic) BOOL subViewsMoved;
@property (nonatomic,assign) CGRect normalRect;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation LHLCommitQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.scrollView.contentSize = (CGSize){IP5(516, 435),CGRectGetWidth(self.view.frame)+100};
    self.subViewsMoved = NO;
    self.contentField.delegate = self;
    
//    self.view.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
//    self.titleField.frame = CGRectMake(49, 13,IP5(453, 373), 44);
    [self.titleField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    
    [self.contentField setBackgroundColor:[UIColor colorWithRed:250.0/255.0 green:250.0/255.0 blue:250.0/255.0 alpha:1.0]];
    self.contentField.layer.borderColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0].CGColor;
    self.contentField.layer.borderWidth =0.6;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];
    
    //tableView of 问答分类
    self.frame = self.categoryTextField.frame;//按钮坐标
    self.tableFrame = (CGRect){self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size};//table坐标
    
    [self.selectButton addTarget:self action:@selector(showSelectTable) forControlEvents:UIControlEventTouchUpInside];
    
    //问答分类
    if ([CaiJinTongManager shared].question.count == 0) {
        [self getQuestionInfo];
    }else{
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
        
//        //标记是否选中了
//        self.questionArrSelSection = [[NSMutableArray alloc] init];
//        for (int i =0; i<self.questionList.count; i++) {
//            [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.treeView.noteArr = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
        });
    }
    
    self.treeView.frame = self.tableFrame;
    self.treeView.hidden = YES;
    self.treeView.backgroundColor = [UIColor lightGrayColor];
    [self.treeView.layer setCornerRadius:8];
    [self.treeView.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.treeView.layer setBorderWidth:0.5];
    [self.view bringSubviewToFront:self.treeView];
    self.tableVisible = NO;
    //响应键盘出现/消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//获得分类信息
-(void)getQuestionInfo  {
    if([CaiJinTongManager shared].question.count > 0){
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
    }else{
        
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
}

//键盘消失
- (IBAction)spaceAreaClicked:(id)sender {
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
    if (self.tableVisible) {
        [self showSelectTable];
    }
}

- (IBAction)cancelBtnClicked:(UIButton *)sender {
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerCancel)]) {
        [self.delegate commitQuestionControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
    [self spaceAreaClicked:nil];
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return;
    }
    if (self.titleField.text == nil || [[self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"标题不能为空"];
        return;
    }
    if([[self.categoryTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@"点击选择提问类型"]){
        [Utility errorAlert:@"请先选择一个提问分类!"];
        return;
    }
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionController:didCommitQuestionWithTitle:andText:andQuestionId:)]) {
        [self.delegate commitQuestionController:self didCommitQuestionWithTitle:self.titleField.text andText:self.contentField.text andQuestionId:self.selectedQuestionId];//42为"综合问题"的分类编号
    }
}

#pragma mark 响应键盘出现/消失事件
- (void)keyboardWillShow:(NSNotification *)notification{
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
//    if (self.tableVisible) {
//        [self showSelectTable];
//    }
}

//本view上移,view中所有控件上移
-(void) moveInputBarWithKeyboardHeight:(CGFloat)height withDuration:(NSTimeInterval)animationDuration{
    [UIView animateWithDuration:animationDuration animations:^{
        self.defaultFrame = self.view.frame;
        [self.view setFrame:CGRectMake(CGRectGetMinX(self.view.frame), 0, IP5(516, 435), CGRectGetHeight(self.view.frame))];
        if(self.contentField.isFirstResponder && !self.subViewsMoved){
            NSArray *subViews = [self.view subviews];
            for(UIView *child in subViews){
                CGRect frame = child.frame;
                if([child isKindOfClass:[UITextView class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 65, frame.size.width, 70)];
                }else if([child isKindOfClass:[UIButton class]]){
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 115, frame.size.width, frame.size.height)];
                }else{
                    [child setFrame:CGRectMake(frame.origin.x, frame.origin.y - 75, frame.size.width, frame.size.height)];
                }
            }
            self.subViewsMoved = YES;
        }
    }];
}

-(void) keyboardWillHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.scrollView.contentOffset = (CGPoint){0,0};
//                         self.tableVisible = NO;
                     }
                     completion:^(BOOL finished) {
                         if(finished){
//                             self.treeView.hidden = YES;
                         }
                     }];
}

#pragma mark button methods
//显示/隐藏提问类型table
-(void)showSelectTable{
    [self.titleField resignFirstResponder];
    [self.contentField resignFirstResponder];
    if(!self.tableVisible){
        self.treeView.hidden = NO;
        [self.view setUserInteractionEnabled:NO];
        [self.view bringSubviewToFront:self.treeView];
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            self.treeView.frame = (CGRect){CGRectGetMinX(self.categoryTextField.frame),CGRectGetMaxY(self.categoryTextField.frame),self.view.frame.size.width- CGRectGetMinX(self.categoryTextField.frame)*2,200};
            self.tableVisible = YES;
        }
                         completion:^(BOOL finished) {
                             [self.view setUserInteractionEnabled:YES];
                         }];
    }else{
        [self.view setUserInteractionEnabled:NO];
        [UIView animateWithDuration:0.3 animations:^{
            [self.treeView setHidden:YES];
        } completion:^(BOOL finished) {
            [self.view setUserInteractionEnabled:YES];
            self.tableVisible = NO;
        }];
    }
}

//点击截图
- (IBAction)screenShotButtonClicked:(id)sender {
//    self.isCut = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerDidStartCutScreenButtonClicked:isCut:)]) {
        [self.delegate commitQuestionControllerDidStartCutScreenButtonClicked:self isCut:self.isCut];
    }
}

#pragma mark TreeView
-(DRTreeTableView *)treeView{
    if(!_treeView){
//        _treeView = [[DRTreeTableView alloc] initWithFrame:(CGRect){2,2,2,2} withTreeNodeArr:nil];
        _treeView = [[DRTreeTableView alloc]initWithDropDownMenuFrame:(CGRect){CGRectGetMinX(self.categoryTextField.frame),CGRectGetMaxY(self.categoryTextField.frame),self.view.frame.size.width- CGRectGetMinX(self.categoryTextField.frame)*2,200} withTreeNodeArr:nil];
        _treeView.delegate = self;
        [self.view addSubview:_treeView];
        [_treeView setBackgroundColor:[UIColor lightGrayColor]];
    }
    return _treeView;
}

#pragma mark --

#pragma mark -- DRTreeView Delegate
-(void)drTreeTableView:(DRTreeTableView*)treeView didSelectedTreeNode:(DRTreeNode*)selectedNote{
    self.selectedQuestionId = selectedNote.noteContentID;
    self.categoryTextField.text = selectedNote.noteContentName;
    //点击生效
    [self showSelectTable];
}

-(BOOL)drTreeTableView:(DRTreeTableView*)treeView isExtendChildSelectedTreeNode:(DRTreeNode*)selectedNote {
    return YES;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didExtendChildTreeNode:(DRTreeNode*)extendNote{
//    self.selectedQuestionId = extendNote.noteContentID;
//    self.categoryTextField.text = extendNote.noteContentName;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didCloseChildTreeNode:(DRTreeNode*)extendNote{
    
}

#pragma mark --

#pragma mark QuestionInfoInterfaceDelegate
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //分类的数据
        self.questionList = [NSMutableArray arrayWithArray:questionCategoryArr];
        [CaiJinTongManager shared].question = [NSMutableArray arrayWithArray:questionCategoryArr];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.treeView.noteArr = [NSMutableArray arrayWithArray:questionCategoryArr];
        });
    });
}

-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
    
}

#pragma mark --
#pragma mark property

-(void)setCutImage:(UIImage *)image{
    if(image){
        _cutImage = image;
        self.screenShotImageView.hidden = NO;
        self.screenShotImageView.image = image;
        self.screenShotBtn.hidden = YES;
    }
}

#pragma mark --
#pragma mark TextView Delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView animateWithDuration:0.3 delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:(CGPoint){0,100}];
                     }
                     completion:^(BOOL finished) {
                         if(finished){
                         }
                     }];
}
#pragma mark --

#pragma mark textfieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 delay:0.0
                        options: UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         [self.scrollView setContentOffset:(CGPoint){0,10}];
                     }
                     completion:^(BOOL finished) {
                         if(finished){
                         }
                     }];
}
#pragma mark --

#pragma mark autorotate
- (BOOL)shouldAutorotate {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}
// pre-iOS 6 support
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

#pragma mark --


-(void)dealloc{
    
}
@end
