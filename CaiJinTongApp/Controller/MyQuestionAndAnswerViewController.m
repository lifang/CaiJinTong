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
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) QuestionListInterface *questionListInterface;
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
    
    [self.headerRefreshView endRefreshing];//instance refresh view
    [self.footerRefreshView endRefreshing];
    
    self.headerRefreshView.isForbidden = YES;
    self.footerRefreshView.isForbidden = YES;
    [self.tableView registerClass:[QuestionAndAnswerCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.drnavigationBar.titleLabel.text = @"我的提问";
    [self.drnavigationBar.navigationRightItem setTitle:@"提问" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noticeBarImageView.layer setCornerRadius:4];
}
//数据源
-(void)reloadDataWithDataArray:(NSArray*)data withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope{
    self.questionAndAnswerScope = scope;
    self.chapterID = chapterID;
    self.myQuestionArr = [NSMutableArray arrayWithArray:data];
    if (self.myQuestionArr.count>0) {
        QuestionModel *question = [self.myQuestionArr  objectAtIndex:self.myQuestionArr.count-1];
        self.question_pageIndex = question.pageIndex;
        self.question_pageCount = question.pageCount;
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
//赞问题
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header flowerQuestionAtIndexPath:(NSIndexPath *)path{

}
//将要点击回答问题按钮
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header willAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    question.isEditing = !question.isEditing;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (question.isEditing) {
        float sectionHeight = [self getTableViewHeaderHeightWithSection:path.section];
        CGRect sectionRect = [self.tableView rectForHeaderInSection:path.section];
        float sectionMinHeight = CGRectGetMinY(sectionRect) - self.tableView.contentOffset.y;
        float keyheight = CGRectGetMaxY(self.tableView.frame) - sectionHeight-300;
        if (sectionMinHeight > keyheight) {
            [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (sectionMinHeight - keyheight)} animated:YES];
        }
    }

}

//提交问题的答案
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header didAnswerQuestionAtIndexPath:(NSIndexPath *)path withAnswer:(NSString *)text{
QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    question.isEditing = NO;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

//开始编辑回答
-(void)questionAndAnswerCellHeaderView:(QuestionAndAnswerCellHeaderView *)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    float sectionHeight = [self getTableViewHeaderHeightWithSection:path.section];
    CGRect sectionRect = [self.tableView rectForHeaderInSection:path.section];
    float sectionMinHeight = CGRectGetMinY(sectionRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetMaxY(self.tableView.frame) - sectionHeight-400;
    if (sectionMinHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (sectionMinHeight - keyheight)} animated:YES];
    }

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
//    answer.isPraised = YES;
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
    if (answer.isEditing) {
        float cellHeight = [self getTableViewRowHeightWithIndexPath:path];
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:path];
        float cellmaxHeight = CGRectGetMaxY(cellRect) - self.tableView.contentOffset.y;
        float keyheight = CGRectGetMaxY(self.tableView.frame) - cellHeight-20;
        if (cellmaxHeight > keyheight) {
            [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (cellmaxHeight - keyheight)} animated:YES];
        }
    }
    
}
#pragma mark -- 采纳答案
static NSIndexPath *indexPath = nil;
-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        indexPath = path;
        AcceptAnswerInterface *acceptAnswerInter = [[AcceptAnswerInterface alloc]init];
        self.acceptAnswerInterface = acceptAnswerInter;
        self.acceptAnswerInterface.delegate = self;
        [self.acceptAnswerInterface getAcceptAnswerInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andQuestionId:question.questionId andResultId:answer.resultId];
    }
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
    if ([[CaiJinTongManager shared] userId] && [[[CaiJinTongManager shared] userId] isEqualToString:question.askerId]) {
        answer.isEditing = YES;
    }else{
     answer.isEditing = NO;
    }
     [cell setAnswerModel:answer withQuestion:question];
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

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        [self requestNewPageDataWithPageIndex:0];
    }else{
        self.headerRefreshView.isForbidden = YES;
        [self requestNewPageDataWithPageIndex:self.question_pageIndex+1];
    }
}

#pragma mark --

#pragma mark action

-(void)requestNewPageDataWithPageIndex:(int)currentIndex{
    if (self.questionAndAnswerScope == QuestionAndAnswerALL) {
        [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andChapterQuestionId:self.chapterID andPageIndex:currentIndex andIsMyself:nil];
    }else
        if (self.questionAndAnswerScope == QuestionAndAnswerMYANSWER) {
            [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andChapterQuestionId:self.chapterID andPageIndex:currentIndex andIsMyself:@"0"];
        }else
            if (self.questionAndAnswerScope == QuestionAndAnswerMYQUESTION) {
                [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andChapterQuestionId:nil andPageIndex:currentIndex andIsMyself:@"1"];
            }
}

-(float)getTableViewHeaderHeightWithSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    if (question.isEditing) {
        return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONHEARD_VIEW_WIDTH].height + TEXT_HEIGHT + TEXT_PADDING + QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;
    }else{
    return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONHEARD_VIEW_WIDTH].height + TEXT_HEIGHT + TEXT_PADDING;
    }
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

-(QuestionListInterface *)questionListInterface{
    if (!_questionListInterface) {
        _questionListInterface = [[QuestionListInterface alloc] init];
        _questionListInterface.delegate = self;
    }
    return _questionListInterface;
}

-(MJRefreshHeaderView *)headerRefreshView{
    if (!_headerRefreshView) {
        _headerRefreshView = [[MJRefreshHeaderView alloc] init];
        _headerRefreshView.scrollView = self.tableView;
        _headerRefreshView.delegate = self;
    }
    return _headerRefreshView;
}

-(MJRefreshFooterView *)footerRefreshView{
    if (!_footerRefreshView) {
        _footerRefreshView = [[MJRefreshFooterView alloc] init];
        _footerRefreshView.delegate = self;
        _footerRefreshView.scrollView = self.tableView;
        
    }
    return _footerRefreshView;
}

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


#pragma mark QuestionListInterfaceDelegate 加载新数据
-(void)getQuestionListInfoDidFinished:(NSDictionary *)result{
    
    if (result) {
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        if (chapterQuestionList && [chapterQuestionList count] > 0) {
            if (self.headerRefreshView.isForbidden) {//加载下一页
                [self.myQuestionArr addObjectsFromArray:chapterQuestionList];
            }else{//重新加载
                self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
            }
            QuestionModel *question = [self.myQuestionArr  lastObject];
            self.question_pageIndex = question.pageIndex;
            self.question_pageCount = question.pageCount;
            [self.tableView reloadData];
        }else{
            [Utility errorAlert:@"数据为空"];
        }
    }else{
        [Utility errorAlert:@"数据为空"];
    }
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;

}

-(void)getQuestionListInfoDidFailed:(NSString *)errorMsg{
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
    [Utility errorAlert:errorMsg];
}
#pragma mark --


#pragma mark -- AcceptAnswerInterfaceDelegate 
-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            QuestionModel *question = [self.myQuestionArr  objectAtIndex:indexPath.section];
            AnswerModel *answer = [question.answerList objectAtIndex:indexPath.row];
            question.isAcceptAnswer = @"1";
            answer.IsAnswerAccept = @"1";
            [self.tableView reloadData];
        });
    });
}
-(void)getAcceptAnswerInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

-(void)dealloc{
    [self.headerRefreshView free];
    [self.footerRefreshView free];
}

@end
