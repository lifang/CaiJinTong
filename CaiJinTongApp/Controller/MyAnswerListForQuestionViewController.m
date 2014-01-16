//
//  MyAnswerListForQuestionViewController.m
//  CaiJinTongApp
//
//  Created by david on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyAnswerListForQuestionViewController.h"
@interface MyAnswerListForQuestionViewController ()
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) SubmitAnswerInterface *submitAnswerInterface;//提交回答或者是提交追问
@property (nonatomic,strong)  AnswerPraiseInterface *answerPraiseinterface;//提交赞接口
@property (nonatomic,strong)  AnswerListInterface *answerListInterface;//答案分页加载
@property (nonatomic,strong) NSIndexPath *activeIndexPath;//正在处理中的cell
@property (nonatomic,strong) NSString *searchContent;//搜索关键字
@property (nonatomic,assign) BOOL isSearch;
@end

@implementation MyAnswerListForQuestionViewController

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

-(void)reloadMoreAnswerListForQuestion:(QuestionModel*)question withScope:(QuestionAndAnswerScope)scope{
    self.questionAndAnswerScope = scope;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.questionAndAnswerScope == QuestionAndAnswerALL) {
        [self.headerRefreshView endRefreshing];//instance refresh view
        [self.footerRefreshView endRefreshing];
        //
        //        self.headerRefreshView.isForbidden = YES;
        //        self.footerRefreshView.isForbidden = YES;
    }
    
    [self.tableView registerClass:[QuestionAndAnswerCellHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
    self.drnavigationBar.titleLabel.text = @"我的问答";
    [self.drnavigationBar.navigationRightItem setTitle:@"返回" forState:UIControlStateNormal];
    [self.drnavigationBar.navigationRightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noticeBarImageView.layer setCornerRadius:4];
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
    self.questionModel.isEditing = !self.questionModel.isEditing;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (self.questionModel.isEditing) {
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
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.questionModel.isEditing = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
//        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:ReaskType_None  andAnswerContent:text andQuestionId:self.questionModel.questionId andResultId:@"0"];
        
        AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:ReaskType_None andAnswerContent:text andQuestionId:self.questionModel.questionId andAnswerID:answer.resultId  andResultId:@"0"];
    }
    
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
    //    answer.isPraised = YES;
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
        self.activeIndexPath = path;
        [self.answerPraiseinterface getAnswerPraiseInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andQuestionId:self.questionModel.questionId andResultId:answer.resultId];
    }
}

//追问
-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path withReaskType:(ReaskType)reaskType{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:reaskType andAnswerContent:questionStr andQuestionId:self.questionModel.questionId andResultId:@"1"];
        
        AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:reaskType andAnswerContent:questionStr andQuestionId:self.questionModel.questionId andAnswerID:answer.resultId  andResultId:@"1"];
    }
}

-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{
    AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
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
-(void)questionAndAnswerCell:(QuestionAndAnswerCell *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
    AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.activeIndexPath = path;
        AcceptAnswerInterface *acceptAnswerInter = [[AcceptAnswerInterface alloc]init];
        self.acceptAnswerInterface = acceptAnswerInter;
        self.acceptAnswerInterface.delegate = self;
        [self.acceptAnswerInterface getAcceptAnswerInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andQuestionId:self.questionModel.questionId andAnswerID:answer.answerId andCorrectAnswerID:answer.resultId];
    }
}
#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    QuestionAndAnswerCell *cell = (QuestionAndAnswerCell*)[tableView dequeueReusableCellWithIdentifier:@"questionAndAnswerCell"];
    AnswerModel *answer = [self.questionModel.answerList objectAtIndex:indexPath.row];
    [cell setAnswerModel:answer withQuestion:self.questionModel];
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
    return self.questionModel.answerList != nil ?[self.questionModel.answerList count]:0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    QuestionAndAnswerCellHeaderView *header = (QuestionAndAnswerCellHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    [header setQuestionModel:self.questionModel withQuestionAndAnswerScope:self.questionAndAnswerScope];
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
        [self requestNewPageDataWithLastAnswerID:nil];
    }else{
        self.headerRefreshView.isForbidden = YES;
        AnswerModel *answer = [self.questionModel.answerList lastObject];
        [self requestNewPageDataWithLastAnswerID:answer.resultId];
    }
}

#pragma mark --

#pragma mark action

-(void)requestNewPageDataWithLastAnswerID:(NSString*)lastAnswerID{
//    if (self.questionAndAnswerScope == QuestionAndAnswerALL) {
//    }else
//        if (self.questionAndAnswerScope == QuestionAndAnswerMYANSWER) {
//        }else
//            if (self.questionAndAnswerScope == QuestionAndAnswerMYQUESTION) {
//            }
    [self.answerListInterface getAnswerListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andQuestionId:self.questionModel.questionId andLastAnswerID:lastAnswerID];
}

-(float)getTableViewHeaderHeightWithSection:(NSInteger)section{
    if (self.questionModel.isEditing) {
        return  [Utility getTextSizeWithString:self.questionModel.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONHEARD_VIEW_WIDTH].height + TEXT_HEIGHT + TEXT_PADDING + QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;
    }else{
        return  [Utility getTextSizeWithString:self.questionModel.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+6] withWidth:QUESTIONHEARD_VIEW_WIDTH].height + TEXT_HEIGHT + TEXT_PADDING;
    }
}

-(float)getTableViewRowHeightWithIndexPath:(NSIndexPath*)path{
    if (self.questionModel.answerList == nil || [self.questionModel.answerList count] <= 0) {
        return 0;
    }
    AnswerModel *answer = [self.questionModel.answerList objectAtIndex:path.row];
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
-(AnswerListInterface *)answerListInterface{
    if (!_answerListInterface) {
        _answerListInterface = [[AnswerListInterface alloc] init];
        _answerListInterface.delegate = self;
    }
    return _answerListInterface;
}

-(AnswerPraiseInterface *)answerPraiseinterface{
    if (!_answerPraiseinterface) {
        _answerPraiseinterface = [[AnswerPraiseInterface alloc] init];
        _answerPraiseinterface.delegate = self;
    }
    return _answerPraiseinterface;
}

-(SubmitAnswerInterface *)submitAnswerInterface{
    if (!_submitAnswerInterface) {
        _submitAnswerInterface = [[SubmitAnswerInterface alloc] init];
        _submitAnswerInterface.delegate = self;
    }
    return _submitAnswerInterface;
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

#pragma mark --



- (IBAction)noticeHideBtnClick:(id)sender {
    [self.noticeBarView setHidden:YES];
    CGRect frame = self.tableView.frame;
    [self.tableView setFrame: CGRectMake(frame.origin.x,frame.origin.y - 35,frame.size.width,frame.size.height)];
}

#pragma mark AnswerListInterfaceDelegate回答分页加载
-(void)getAnswerListInfoDidFailed:(NSString *)errorMsg{

}

-(void)getAnswerListInfoDidFinished:(QuestionModel *)result{

}
#pragma mark --

#pragma mark AnswerPraiseInterfaceDelegate 赞回调
-(void)getAnswerPraiseInfoDidFinished:(NSDictionary *)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"赞成功"];
    AnswerModel *answer = [self.questionModel.answerList objectAtIndex:self.activeIndexPath.row];
    answer.answerPraiseCount = [NSString stringWithFormat:@"%d",[answer.answerPraiseCount integerValue]+1];
    answer.isPraised = @"1";
    [self.tableView reloadRowsAtIndexPaths:@[self.activeIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)getAnswerPraiseInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"赞失败"];
}
#pragma mark --

#pragma mark SubmitAnswerInterfaceDelegate 提交回答或者提交追问的代理
-(void)getSubmitAnswerInfoDidFinished:(NSDictionary *)result withReaskType:(ReaskType)reask{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"提交成功"];
}

-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg withReaskType:(ReaskType)reask{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"提交失败"];
}

#pragma mark --

#pragma mark -- AcceptAnswerInterfaceDelegate 采纳答案
-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            AnswerModel *answer = [self.questionModel.answerList objectAtIndex:self.activeIndexPath.row];
            self.questionModel.isAcceptAnswer = @"1";
            answer.IsAnswerAccept = @"1";
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.activeIndexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [Utility errorAlert:@"提交采纳正确回答成功"];
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