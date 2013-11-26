//
//  MyQuestionAndAnswerViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionAndAnswerViewController.h"
@interface MyQuestionAndAnswerViewController ()
@property (nonatomic,strong) NSMutableArray *myQuestionArr;
@end

@implementation MyQuestionAndAnswerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
    DRAskQuestionViewController *ask = [story instantiateViewControllerWithIdentifier:@"DRAskQuestionViewController"];
    [self.navigationController pushViewController:ask animated:YES];
    
}


-(void)willDismissPopoupController{
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView setContentOffset:offset animated:NO];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[QuestionAndAnswerCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.drnavigationBar.titleLabel.text = @"我的提问";
    [self.drnavigationBar.navigationRightItem setTitle:@"提问" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noticeBarImageView.layer setCornerRadius:4];
}
//数据源
-(void)reloadDataWithDataArray:(NSArray*)data{
    self.myQuestionArr = [NSMutableArray arrayWithArray:data];
    if (self.myQuestionArr.count>0) {
        QuestionModel *question = [self.myQuestionArr  objectAtIndex:self.myQuestionArr.count-1];
        self.question_pageIndex = question.pageIndex;
        self.question_pageCount = question.pageCount;
        AnswerModel *answer = [question.answerList objectAtIndex:question.answerList.count-1];
        self.answer_pageIndex = answer.pageIndex;
        self.answer_pageCount = answer.pageCount;
        dispatch_async ( dispatch_get_main_queue (), ^{
            [self.tableView reloadData];
        });
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark QuestionAndAnswerCellHeaderViewDelegate
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header flowerQuestionAtIndexPath:(NSIndexPath *)path{

}
#pragma mark --

#pragma mark QuestionAndAnswerCellDelegate

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath *)path{
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:path];
    float cellmaxHeight = CGRectGetMaxY(cellRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetMaxY(self.tableView.frame) - 400;
    if (cellmaxHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (cellmaxHeight - keyheight)} animated:YES];
    }
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell flowerAnswerAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.isPraised = YES;
    answer.answerPraiseCount = [NSString stringWithFormat:@"%d",[answer.answerPraiseCount integerValue]+1];;
     [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path{

}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.isEditing = isHiddle;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
 QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    question.isAcceptAnswer = [NSString stringWithFormat:@"YES"];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    answer.IsAnswerAccept = [NSString stringWithFormat:@"YES"];
    answer.resultId = question.questionId;
    [question.answerList removeObjectAtIndex:path.row];
    [question.answerList insertObject:answer atIndex:0];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:path.section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.myQuestionArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionAndAnswerCell *cell = (QuestionAndAnswerCell*)[tableView dequeueReusableCellWithIdentifier:@"questionAndAnswerCell"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:indexPath.section];
    AnswerModel *answer = [question.answerList objectAtIndex:indexPath.row];
    if (question.isAcceptAnswer && [question.isAcceptAnswer isEqualToString:@"YES"]) {
        [cell setAnswerModel:answer isQuestionID:question.questionId];
    } else {
        [cell setAnswerModel:answer isQuestionID:nil];
    }
    
    cell.delegate = self;
    cell.path = indexPath;
    cell.contentView.frame = (CGRect){cell.contentView.frame.origin,CGRectGetWidth(cell.contentView.frame),[self getTableViewRowHeightWithIndexPath:indexPath]};
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self getTableViewHeaderHeightWithSection:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    float height = [self getTableViewRowHeightWithIndexPath:indexPath];
    return height;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    return question.answerList != nil ?[question.answerList count]:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QuestionAndAnswerCellHeaderView *header = (QuestionAndAnswerCellHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    [header setQuestionModel:question];
    header.backgroundColor = [UIColor whiteColor];
    header.delegate = self;
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    return header;
}

#pragma mark --

#pragma mark action
-(float)getTableViewHeaderHeightWithSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONHEARD_VIEW_WIDTH].height + TEXT_HEIGHT + TEXT_PADDING;
}

-(float)getTableViewRowHeightWithIndexPath:(NSIndexPath*)path{
    NSLog(@"%d,%d",path.section,path.row);
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    if (question.answerList == nil || [question.answerList count] <= 0) {
        return 0;
    }
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    float questionTextFieldHeight = answer.isEditing?141:0;

    if (platform >= 7.0) {
        return [Utility getTextSizeWithString:answer.answerContent withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONANDANSWER_CELL_WIDTH].height+ TEXT_HEIGHT + TEXT_PADDING*3+ questionTextFieldHeight;
    }else{
        float height = [Utility getTextSizeWithString:answer.answerContent withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONANDANSWER_CELL_WIDTH].height+ TEXT_HEIGHT + TEXT_PADDING+ questionTextFieldHeight;
        return height;
    }
}
#pragma mark --

#pragma mark property

-(NSMutableArray *)myQuestionArr{
    if (!_myQuestionArr) {
        _myQuestionArr = [NSMutableArray array];
    }
    return _myQuestionArr;
}
#pragma mark --
- (IBAction)noticeHideBtnClick:(id)sender {
    [self.noticeBarView setHidden:YES];
    CGRect frame = self.tableView.frame;
    [self.tableView setFrame: CGRectMake(frame.origin.x,frame.origin.y - 35,frame.size.width,frame.size.height)];
}
@end
