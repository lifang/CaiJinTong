//
//  DRCommitQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-15.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRCommitQuestionViewController.h"

static CGRect frame;
static CGRect tableFrame;
static BOOL tableVisible;
@interface DRCommitQuestionViewController ()

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
-(void)getQuestionInfo  {
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
        self.questionInfoInterface = questionInfoInter;
        self.questionInfoInterface.delegate = self;
        [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
    }
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
    [self.titleField becomeFirstResponder];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.contentField.delegate = self;
    self.commitTimeLabel.text = [Utility getNowDateFromatAnDate];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn1.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.cancelBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.cancelBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.commitBtn setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.commitBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.selectTableBtn setBackgroundImage:btnImageHighlighted forState:UIControlStateNormal];
    
    self.contentField.layer.borderColor = [UIColor grayColor].CGColor;
    self.contentField.layer.borderWidth =1.0;
    self.contentField.layer.cornerRadius =5.0;
    
    [self.view.layer setCornerRadius:6];
    [self.view.layer setMasksToBounds:YES];
    
    [self.selectTableBtn.titleLabel setFrame:self.selectTableBtn.frame];
    
    [self.selectTableBtn.titleLabel setNumberOfLines:6];
    [self.selectTableBtn setTitle:@"选\n择\n问\n题\n类\n型" forState:UIControlStateNormal];
    
    [self.selectTableBtn addTarget:self action:@selector(showSelectTable) forControlEvents:UIControlEventTouchUpInside];
    
    //tableView of 问答分类
    self.selectTable.backgroundColor = [UIColor lightGrayColor];
    [self.selectTable.layer setCornerRadius:8];
    [self.selectTable.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.selectTable.layer setBorderWidth:2];
    self.selectTable.separatorStyle = NO;
    
    frame = CGRectMake(6, 151, 41, 80);//按钮坐标
    tableFrame = CGRectMake(-229, 30, 235, 300);//table坐标
    
    //问答分类
    if ([CaiJinTongManager shared].question.count == 0) {
        [self getQuestionInfo];
    }else{
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];

        //标记是否选中了
        self.questionArrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.questionList.count; i++) {
            [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.selectTable reloadData];
        });
    }
    
    NSLog(@"%@第三方斯蒂芬斯蒂芬苏打",self.questionList);
    
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
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionControllerCancel)]) {
        [self.delegate commitQuestionControllerCancel];
    }
}

- (IBAction)commitBtnClicked:(UIButton *)sender {
   
    if (self.contentField.text == nil || [[self.contentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"内容不能为空"];
        return;
    }
    
    if (!self.titleField.text || [[self.titleField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
        [Utility errorAlert:@"标题不能为空"];
        return;
    }
    
    if ([self.selectedQuestionName.text isEqualToString:@"请选择问题分类!"]) {
        [Utility errorAlert:@"点击左边按钮选择一个问题分类"];
        return;
    }
     [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationSlideTopTop];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commitQuestionController:didCommitQuestionWithTitle:andText:andQuestionId:)]) {
        [self.delegate commitQuestionController:self didCommitQuestionWithTitle:self.titleField.text andText:self.contentField.text andQuestionId:self.selectedQuestionId];
    }
}

- (IBAction)inputBegin:(id)sender {
    if(tableVisible){
        [self showSelectTable];
    }
}

#pragma mark--QuestionInfoInterfaceDelegate {
-(void)getQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //分类的数据
        self.questionList = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
        NSLog(@"%@ 斯蒂芬",self.questionList);
        [CaiJinTongManager shared].question = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
        dispatch_async(dispatch_get_main_queue(), ^{
            //标记是否选中了
            self.questionArrSelSection = [[NSMutableArray alloc] init];
            for (int i =0; i<self.questionList.count; i++) {
                [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.selectTable reloadData];
        });
    });
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark --TableView Delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questionList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    cell.textLabel.text=[NSString stringWithFormat:@"%@",[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"questionName"]];
    [cell setIndentationLevel:[[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"level"]intValue]];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *d=[self.questionList objectAtIndex:indexPath.row];
    if([d valueForKey:@"questionNode"]) {
        NSArray *ar=[d valueForKey:@"questionNode"];
        if (ar.count == 0) {
            self.selectedQuestionId = [d valueForKey:@"questionID"];
            self.selectedQuestionName.text = [d valueForKey:@"questionName"];
            [self showSelectTable];
        }else {
            BOOL isAlreadyInserted=NO;
            
            for(NSDictionary *dInner in ar ){
                NSInteger index=[self.questionList indexOfObjectIdenticalTo:dInner];
                isAlreadyInserted=(index>0 && index!=NSIntegerMax);
                if(isAlreadyInserted) break;
            }
            
            if(isAlreadyInserted) {
                [self miniMizeThisRows:ar];
            } else {
                NSUInteger count=indexPath.row+1;
                NSMutableArray *arCells=[NSMutableArray array];
                for(NSDictionary *dInner in ar ) {
                    [arCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                    [self.questionList insertObject:dInner atIndex:count++];
                }
                [tableView insertRowsAtIndexPaths:arCells withRowAnimation:UITableViewRowAnimationLeft];
            }
        }
    }
}

-(void)miniMizeThisRows:(NSArray*)ar{
	for(NSDictionary *dInner in ar ) {
		NSUInteger indexToRemove=[self.questionList indexOfObjectIdenticalTo:dInner];
		NSArray *arInner=[dInner valueForKey:@"questionNode"];
		if(arInner && [arInner count]>0){
			[self miniMizeThisRows:arInner];
		}
		
		if([self.questionList indexOfObjectIdenticalTo:dInner]!=NSNotFound) {
			[self.questionList removeObjectIdenticalTo:dInner];
			[self.selectTable deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}



#pragma mark property
-(NSMutableArray *)questionArrSelSection{
    if (!_questionArrSelSection) {
        _questionArrSelSection = [NSMutableArray array];
    }
    return _questionArrSelSection;
}

#pragma mark textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    return YES;
}


#pragma mark button methods
-(void)showSelectTable{
    if(!tableVisible){
        [self.contentField resignFirstResponder];//table出现时使textView失去焦点,以便触发其点击事件
        [self.selectTable reloadData];
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.selectTableBtn setFrame:CGRectMake(frame.origin.x + 235, frame.origin.y, frame.size.width, frame.size.height)];
            [self.selectTable setFrame:CGRectMake(tableFrame.origin.x + 235, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
            tableVisible = YES;
        }
                         completion:NULL];
    }else{
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.selectTableBtn setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
            [self.selectTable setFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
            tableVisible = NO;
        }
                         completion:NULL];
    }
    
}
@end
