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
    
//    self.questionContentTextView.layer.borderWidth = 1;
//    self.questionContentTextView.layer.borderColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1].CGColor;
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
    if ([CaiJinTongManager shared].question.count == 0) {
        [self getQuestionInfo];
    }else{
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    }
    
    //tableView of 问答分类
    frame = CGRectMake(532, 60, 30, 30);//按钮坐标
    [self.selectTableBtn.titleLabel setNumberOfLines:6];
    [self.selectTableBtn.layer setBorderColor:[UIColor blackColor].CGColor];
    [self.selectTableBtn.layer setBorderWidth:1];
    [self.selectTableBtn.layer setCornerRadius:3];
//    [self.selectTableBtn setTitle:@"选\n择\n问\n题\n类\n型" forState:UIControlStateNormal];
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
    
    //标记是否选中了
    self.questionArrSelSection = [[NSMutableArray alloc] init];
    for (int i =0; i<self.questionList.count; i++) {
        [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
    }
    NSLog(@"%@第三方斯蒂芬斯蒂芬苏打",self.questionList);
    
}

-(void)getQuestionInfo  {
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [SVProgressHUD showWithStatus:@"玩命加载中..."];
        QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
        self.questionInfoInterface = questionInfoInter;
        self.questionInfoInterface.delegate = self;
        [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 50;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    LessonListHeaderView *header = (LessonListHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
    header.delegate = self;
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    if (section == 0) {
        header.lessonTextLabel.text = @"所有问答";
    }else {
        header.lessonTextLabel.text = @"我的问答";
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
    if (section == 0) {
        return self.questionList.count;
    }else{
        return 2;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell"];
    if(!cell){
        cell = [[UITableViewCell alloc] init];
    }
    if (indexPath.section == 0) {
        NSDictionary *d=[self.questionList objectAtIndex:indexPath.row];
        NSArray *ar=[d valueForKey:@"questionNode"];
        if (ar.count>0) {
            cell.backgroundView =  [[UIView alloc] initWithFrame:cell.frame];
            cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:Image(@"headview_cell_background_selected.png")];
            cell.selectedBackgroundView =  [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:Image(@"headview_cell_background_selected.png")];
        }else {
            cell.backgroundView =  [[UIView alloc] initWithFrame:cell.frame];
            cell.backgroundView.backgroundColor = [UIColor colorWithPatternImage:Image(@"headview_cell_background.png")];
            cell.selectedBackgroundView =  [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = [UIColor colorWithPatternImage:Image(@"headview_cell_background.png")];
        }
        cell.textLabel.text=[NSString stringWithFormat:@"  %@",[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"questionName"]];
    }else{
        if (indexPath.row == 0) {
            cell.textLabel.text = @"  我的提问";
        }else{
            cell.textLabel.text = @"  我的回答";
        }
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
                NSLog(@"%@%@斯蒂芬斯蒂芬",self.selectedQuestionName.text,self.selectedQuestionId);
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


#pragma mark--QuestionInfoInterfaceDelegate {
-(void)getQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismiss];
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
                [self.selectTable reloadData];
            });
        });
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
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
    if(![self.selectedQuestionName.text isEqualToString:@"点击按钮选择一个类型:"] && (self.selectedQuestionName.text != nil) && (self.selectedQuestionId != nil)){
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请选择一个问题类型!" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
    }
}

@end
