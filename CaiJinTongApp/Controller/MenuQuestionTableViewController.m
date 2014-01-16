//
//  MenuQuestionTableViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MenuQuestionTableViewController.h"
#import "MyQuestionAndAnswerViewController_iPhone.h"
#import "GetUserQuestionInterface.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"
#define QUESTION_CELL_IDENTIFIER @"questionCell"
@interface MenuQuestionTableViewController ()
@property (nonatomic,strong) GetUserQuestionInterface *getUserQuestionInterface;
@end

@implementation MenuQuestionTableViewController

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
    [self.tableView registerClass:[LessonListCell class] forCellReuseIdentifier:QUESTION_CELL_IDENTIFIER];
    [self.tableView registerClass:[LessonListHeaderView_iPhone class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
    
    [self initData];
}

- (void)initData{
    if([CaiJinTongManager shared].question.count > 0){
        self.questionList = [NSMutableArray arrayWithArray:[CaiJinTongManager shared].question];
        //标记是否选中了
        self.questionArrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.questionList.count; i++) {
            [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        [self.tableView reloadData];
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

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section  {
    return 42;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        LessonListHeaderView_iPhone *header = (LessonListHeaderView_iPhone*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
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

-(void)lessonHeaderView:(LessonListHeaderView_iPhone *)header selectedAtIndex:(NSIndexPath *)path{
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
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
    
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
        LessonListCell *cell = [tableView dequeueReusableCellWithIdentifier:QUESTION_CELL_IDENTIFIER];
        if (indexPath.section == 0) {
            cell.textLabel.text=[NSString stringWithFormat:@"%@",[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"questionName"]];
            [cell setIndentationLevel:[[[self.questionList objectAtIndex:indexPath.row] valueForKey:@"level"]intValue]];
        }else{
            if (indexPath.row == 0) {
                cell.textLabel.text = @" 我的提问";
            }else{
                cell.textLabel.text = @" 我的回答";
            }
            [cell setIndentationLevel:2];
        }
        cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.section==0) {
            NSDictionary *d=[self.questionList objectAtIndex:indexPath.row];
            if([d valueForKey:@"questionNode"]) {
                NSArray *ar=[d valueForKey:@"questionNode"];
                if (ar.count == 0) { //判定问题分类到最底层
                    //请求问题分类下详细问题信息
                    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
                        [Utility errorAlert:@"暂无网络!"];
                    }else {
                        [MBProgressHUD showHUDAddedTo:[self.myQAVC view] animated:YES];
                        self.questionAndSwerRequestID = [d valueForKey:@"questionID"];
                        self.questionScope = QuestionAndAnswerALL;
                        
                        //调用问答界面的方法请求问答内容
//                        [self.myQAVC setQuestionAndAnswerScope:self.questionScope];
                        [self.myQAVC setChapterID:self.questionAndSwerRequestID];
                        [self.myQAVC requestNewPageDataWithLastQuestionID:nil];
                        [self.myQAVC rightItemClicked:nil];
                    }
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
      else{
            switch (indexPath.row) {
                case 0:
                {
                    //请求我的提问
                    self.questionScope = QuestionAndAnswerMYQUESTION;
                    break;
                }
                case 1:
                {
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
                    break;
                }
                default:
                    break;
            }
          if([[Utility isExistenceNetwork] isEqualToString:@"NotReachable"]){
              [Utility errorAlert:@"暂无网络!"];
          }else{
              [MBProgressHUD showHUDAddedTo:self.view animated:YES];
              //请求我的问答
              if (self.questionScope == QuestionAndAnswerMYANSWER) {
                  [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andIsMyselfQuestion:@"1" andLastQuestionID:nil withCategoryId:nil];
              }else if (self.questionScope == QuestionAndAnswerMYQUESTION) {
                  [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:nil];
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
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                    [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                    ]
                                  withRowAnimation:UITableViewRowAnimationRight];
		}
	}
}

#pragma mark--QuestionInfoInterfaceDelegate {
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        self.questionList = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
//        [CaiJinTongManager shared].question = [NSMutableArray arrayWithArray:[result valueForKey:@"questionList"]];
        //标记是否选中了
        self.questionArrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.questionList.count; i++) {
            [self.questionArrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark--ChapterQuestionInterfaceDelegate
-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        
        //按问题类型显示问题列表
        
        dispatch_async(dispatch_get_main_queue(),^{
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            [self.myQAVC rightItemClicked:nil];
            [self.myQAVC reloadDataWithDataArray:chapterQuestionList
                           withQuestionChapterID:self.questionAndSwerRequestID
                                       withScope:self.questionScope];
            
        });
    });
}
-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark GetUser QuestionInterface Delegate

-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.myQAVC reloadDataWithDataArray:chapterQuestionList
                           withQuestionChapterID:nil
                                       withScope:self.questionScope];
            [self.myQAVC rightItemClicked:nil];
        });
    });
}

#pragma mark property

-(GetUserQuestionInterface *)getUserQuestionInterface{
    if(!_getUserQuestionInterface){
        _getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
        _getUserQuestionInterface.delegate = self;
    }
    return _getUserQuestionInterface;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
