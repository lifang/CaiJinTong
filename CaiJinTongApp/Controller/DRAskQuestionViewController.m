//
//  DRAskQuestionViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRAskQuestionViewController.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"
static CGRect frame;
static CGRect tableFrame;
static BOOL tableVisible;
@interface DRAskQuestionViewController ()

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.questionContentTextView.delegate = self;
    self.backgroundTextField.frame = self.questionContentTextView.frame;
    self.backgroundTextField.borderStyle = UITextBorderStyleRoundedRect;

    self.backgroundTextField.enabled = NO;

    [self.questionContentTextView.layer setCornerRadius:6];
    
    UIImage *btnImageHighlighted = [[UIImage imageNamed:@"btn.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    UIImage *btnImageNormal = [[UIImage imageNamed:@"btn0.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(6, 6, 6, 6) resizingMode:UIImageResizingModeStretch];
    [self.submitButton setBackgroundImage:btnImageHighlighted forState:UIControlStateHighlighted];
    [self.submitButton setBackgroundImage:btnImageNormal forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
    [self.submitButton addTarget:self action:@selector(submitButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    self.drnavigationBar.navigationRightItem.titleLabel.textColor = [UIColor grayColor];
    
    self.drnavigationBar.titleLabel.text = @"我要提问";
    
    
    
    
    
    //问答分类

        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
    //标记是否选中了
    self.questionArrSelSection = [[NSMutableArray alloc] init];
    for (int i =0; i<self.questionList.count; i++) {
        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
    }
    //tableView of 问答分类
    frame = CGRectMake(532, 60, 30, 30);//按钮坐标
    [self.selectTableBtn.titleLabel setNumberOfLines:6];
    [self.selectTableBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.selectTableBtn.layer setBorderWidth:1];
    [self.selectTableBtn.layer setCornerRadius:3];

    [self.selectTableBtn addTarget:self action:@selector(showSelectTable) forControlEvents:UIControlEventTouchUpInside];
    [self.selectTableBtn.titleLabel setFrame: self.selectTableBtn.frame];
    self.selectTableBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.selectTable registerClass:[LessonListHeaderView class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    tableFrame = CGRectMake(560, 60, 235, 370);
    self.selectTable.frame = tableFrame;
    self.selectTable.backgroundColor = [UIColor lightGrayColor];
    [self.selectTable.layer setCornerRadius:8];
    [self.selectTable.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.selectTable.layer setBorderWidth:2];
    self.selectTable.separatorStyle = NO;
    tableVisible = NO;
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
    header.delegate = self;
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    if (section == 0) {
        header.lessonTextLabel.text = @"所有问答";
    }
    BOOL isSelSection = NO;
    for (int i = 0; i < self.questionArrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            isSelSection = YES;
            break;
        }
    }
    header.isSelected = isSelSection;
    return header;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    for (int i = 0; i < self.questionArrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (section == selSection) {
            return 0;
        }
    }

    return self.questionList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    if (indexPath.section == 0) {
        cell.textLabel.text=[NSString stringWithFormat:@"  %@",[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"questionName"]];
        [cell setIndentationLevel:[[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"level"]intValue]];
    }
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
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
    }else{
        switch (indexPath.row) {
            case 0:
                //请求我的提问
                break;
            case 1:
                //请求我的回答
                break;
                
            default:
                break;
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


#pragma mark LessonListHeaderViewDelegate
-(void)lessonHeaderView:(LessonListHeaderView *)header selectedAtIndex:(NSIndexPath *)path{
    BOOL isSelSection = NO;
    _questionTmpSection = path.section;
    for (int i = 0; i < self.questionArrSelSection.count; i++) {
        NSString *strSection = [NSString stringWithFormat:@"%@",[self.questionArrSelSection objectAtIndex:i]];
        NSInteger selSection = strSection.integerValue;
        if (_questionTmpSection == selSection) {
            isSelSection = YES;
            [self.questionArrSelSection removeObjectAtIndex:i];
            break;
        }
    }
    if (!isSelSection) {
        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%i",_questionTmpSection]];
    }
    [self.selectTable reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark button methods
//显示/隐藏提问类型table
-(void)showSelectTable{
    if(!tableVisible){
        [self.questionContentTextView resignFirstResponder];//便于触发点击事件
        [self.selectTable reloadData];
        [self.selectTableBtn setBackgroundImage:[UIImage imageNamed:@"lhl2.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.selectTableBtn setFrame:CGRectMake(frame.origin.x - 235, frame.origin.y, frame.size.width, frame.size.height)];
                [self.selectTable setFrame:CGRectMake(tableFrame.origin.x - 235, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
                tableVisible = YES;
            }
            completion:NULL];
    }else{
        [self.selectTableBtn setBackgroundImage:[UIImage imageNamed:@"lhl1.png"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.selectTableBtn setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height)];
            [self.selectTable setFrame:CGRectMake(tableFrame.origin.x, tableFrame.origin.y, tableFrame.size.width, tableFrame.size.height)];
            tableVisible = NO;
        }
                         completion:NULL];
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
    if(![self.selectedQuestionName.text isEqualToString:@"点击按钮选择一个类型:"] && (self.selectedQuestionName.text != nil) && (self.selectedQuestionId != nil)){
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            AskQuestionInterface *askQuestionInter = [[AskQuestionInterface alloc]init];
            self.askQuestionInterface = askQuestionInter;
            self.askQuestionInterface.delegate = self;
            [self.askQuestionInterface getAskQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.selectedQuestionId andQuestionName:self.questionTitleTextField.text andQuestionContent:self.questionContentTextView.text];
        }
    }else{
        [Utility errorAlert:@"请选择一个问题类型!"];
    }
}
#pragma mark -- AskQuestionInterfaceDelegate
-(void)getAskQuestionInfoDidFinished {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"提问成功!"];
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}
-(void)getAskQuestionDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
@end
