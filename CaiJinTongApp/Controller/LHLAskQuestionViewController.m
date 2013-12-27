//
//  LHLAskQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LHLAskQuestionViewController.h"

static CGRect frame;
static CGRect tableFrame;
static BOOL tableVisible;
@interface LHLAskQuestionViewController ()
@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;
@end

@implementation LHLAskQuestionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
//获得分类信息
-(void)getQuestionInfo  {
    if([CaiJinTongManager shared].question.count > 0){
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
    }else{
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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectTableBtn.frame = frame;//按钮坐标
    self.selectTable.frame = tableFrame;//table坐标;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.questionTitleTextField setFrame:CGRectMake(62, 118, 238, 43)];
    [self.questionTitleTextField setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
    
    self.questionContentTextView.delegate = self;
    [self.questionContentTextView.layer setCornerRadius:6];
    
    self.backgroundTextField.frame = CGRectMake(self.questionContentTextView.frame.origin.x, self.questionContentTextView.frame.origin.y - 2, self.questionContentTextView.frame.size.width, self.questionContentTextView.frame.size.height + 4);
    [self.backgroundTextField setBackgroundColor:[UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0]];
    self.backgroundTextField.borderStyle = UITextBorderStyleRoundedRect;
    self.backgroundTextField.enabled = NO;
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.submitButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    self.lhlNavigationBar.title.text = @"我要提问";
    
    //问答分类
    self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
    //标记是否选中了
    self.questionArrSelSection = [[NSMutableArray alloc] init];
    for (int i =0; i<self.questionList.count; i++) {
        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //tableView of 问答分类
    frame = self.selectedQuestionName.frame;//按钮坐标
    tableFrame = (CGRect){frame.origin.x, frame.origin.y + frame.size.height, frame.size};//table坐标
    
    [self.selectTableBtn addTarget:self action:@selector(showSelectTable) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectTable.frame = tableFrame;
    self.selectTable.hidden = YES;
    self.selectTable.backgroundColor = [UIColor lightGrayColor];
    [self.selectTable.layer setCornerRadius:8];
    [self.selectTable.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.selectTable.layer setBorderWidth:0.5];
    self.selectTable.separatorStyle = NO;
    tableVisible = NO;
    
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
}


-(void)drnavigationBarRightItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)inputBegin:(id)sender {
    if(tableVisible){
        [self showSelectTable];
    }
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
            //点击生效
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

- (IBAction)keyboardFuckOff:(id)sender {
    [self.questionTitleTextField resignFirstResponder];
    [self.questionContentTextView resignFirstResponder];
    [self inputBegin:nil];
}

#pragma mark button methods
//显示/隐藏提问类型table
-(void)showSelectTable{
    if(!tableVisible){
        [self.questionContentTextView resignFirstResponder];//便于触发点击事件
        [self.selectTable reloadData];
        self.selectTable.hidden = NO;
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.selectTable setFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height + 250)];
            tableVisible = YES;
        }
                         completion:NULL];
    }else{
        [UIView animateWithDuration:0.3 delay:0.0
                            options: UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
            [self.selectTable setFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
            tableVisible = NO;
        }
                         completion:^(BOOL finished) {
                             if(finished){
                                 self.selectTable.hidden = YES;
                             }
                         }];
    }
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
    
    if (self.selectedQuestionId != nil && ![questionContent isEqualToString:@""] && ![questionTitle isEqualToString:@""]&& ![self.selectedQuestionName.text isEqualToString:@"点击按钮选择一个类型:"]){
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            AskQuestionInterface *askQuestionInter = [[AskQuestionInterface alloc]init];
            self.askQuestionInterface = askQuestionInter;
            self.askQuestionInterface.delegate = self;
            [self.askQuestionInterface getAskQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.selectedQuestionId andQuestionName:questionTitle andQuestionContent:questionContent];
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

#pragma mark QuestionInfoInterfaceDelegate
-(void)getQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //分类的数据
        self.questionList = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
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
#pragma mark --

#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"数据提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}
@end
