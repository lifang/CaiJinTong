//
//  MyQuestionAndAnswerViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionAndAnswerViewController_iPhone.h"
@interface MyQuestionAndAnswerViewController_iPhone ()
@property (nonatomic,strong) NSMutableArray *myQuestionArr;
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) QuestionListInterface *questionListInterface;//所有问题的分页加载
@property (nonatomic,strong) GetUserQuestionInterface *userQuestionInterface;//我的回答或者我的提问分页加载
@property (nonatomic,strong) SubmitAnswerInterface *submitAnswerInterface;//提交回答或者是提交追问
@property (nonatomic,strong)  AnswerPraiseInterface *answerPraiseinterface;//提交赞接口
@property (nonatomic,strong) NSIndexPath *activeIndexPath;//正在处理中的cell
@property (nonatomic,assign) BOOL isReaskRefreshing;//判断是追问刷新还是上拉下拉刷新
@property (nonatomic,strong) DRAskQuestionViewController *askQuestionController;
@end

@implementation MyQuestionAndAnswerViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)drnavigationBarRightItemClicked:(id)sender{
    if (!self.askQuestionController) {
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
        self.askQuestionController  = [story instantiateViewControllerWithIdentifier:@"DRAskQuestionViewController"];
        self.askQuestionController.delegate = self;
    }
    
    [self.navigationController pushViewController:self.askQuestionController animated:YES];
    
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
    [self.tableView registerClass:[QuestionAndAnswerCell_iPhoneHeaderView class] forHeaderFooterViewReuseIdentifier:@"header"];
    [self.tableView setFrame: CGRectMake(20,CGRectGetMaxY(self.noticeBarView.frame) + 5,281,IP5(568, 480) - CGRectGetMaxY(self.noticeBarView.frame) - 5 - self.tabBarController.tabBar.frame.size.height)];
    [self.lhlNavigationBar.rightItem setTitle:@"提问" forState:UIControlStateNormal];
    [self.lhlNavigationBar.rightItem setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.noticeBarImageView.layer setCornerRadius:4];
    
    //测试数据
    [self makeTestData];
}

#pragma mark 测试数据

-(void)makeTestData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //此接口property及其代理+回调方法也删掉
    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
    self.getUserQuestionInterface.delegate = self;
    //请求我的回答
    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil];
//    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil];
}

-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
    
}

-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:nil withScope:QuestionAndAnswerMYANSWER];
        });
    });
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

#pragma mark QuestionAndAnswerCell_iPhoneHeaderViewDelegate
//赞问题
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header flowerQuestionAtIndexPath:(NSIndexPath *)path{
    
}
//将要点击回答问题按钮
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header willAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    question.isEditing = !question.isEditing;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (question.isEditing) {
        [self.tableView reloadData];
        CGRect sectionFrame = [self.tableView rectForSection:path.section];
        CGRect lastSectionFrame = [self.tableView rectForSection:self.myQuestionArr.count - 1];
        if(CGRectGetMaxY(lastSectionFrame) - CGRectGetMinY(sectionFrame) < self.tableView.frame.size.height){//如果剩余内容不足一屏,则滑动到屏幕最下方
            [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, (self.tableView.contentSize.height - self.tableView.frame.size.height) > 0 ? (self.tableView.contentSize.height - self.tableView.frame.size.height) : 0)];
        }else{
            //如果内容高度足够,则将本问题置最高处
            [self.tableView setContentOffset:sectionFrame.origin];
        }
    }
}

//提交问题的答案
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header didAnswerQuestionAtIndexPath:(NSIndexPath *)path withAnswer:(NSString *)text{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
        question.isEditing = NO;
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        AnswerModel *answer = [question.answerList objectAtIndex:path.row];
        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:ReaskType_None andAnswerContent:text andQuestionId:question.questionId andAnswerID:answer.resultId  andResultId:@"0"];
    }
}

//开始编辑回答
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    float sectionHeight = [self getTableViewHeaderHeightWithSection:path.section];
    CGRect sectionRect = [self.tableView rectForHeaderInSection:path.section];
    float sectionMinHeight = CGRectGetMinY(sectionRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetHeight(self.tableView.frame) - sectionHeight-155;
    if (sectionMinHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (sectionMinHeight - keyheight)} animated:YES];
    }
    
}
#pragma mark --

#pragma mark QuestionAndAnswerCell_iPhoneDelegate


-(float)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell getCellheightAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    
    NSAttributedString *attriString =  [Utility getTextSizeWithAnswerModel:answer withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONANDANSWER_CELL_WIDTH];
    CGSize size = [Utility getAttributeStringSizeWithWidth:QUESTIONANDANSWER_CELL_WIDTH withAttributeString:attriString];
    return size.height;
}

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath *)path{
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:path];
    float cellmaxHeight = CGRectGetMaxY(cellRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetMaxY(self.tableView.frame) - 200;
    if (cellmaxHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (cellmaxHeight - keyheight)} animated:YES];
    }
}

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell flowerAnswerAtIndexPath:(NSIndexPath *)path{
    //    answer.isPraised = YES;
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
        AnswerModel *answer = [question.answerList objectAtIndex:path.row];
        self.activeIndexPath = path;
        [self.answerPraiseinterface getAnswerPraiseInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andQuestionId:question.questionId andResultId:answer.resultId];
    }
}

//追问
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path withReaskType:(ReaskType)reaskType{
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
        AnswerModel *answer = [question.answerList objectAtIndex:path.row];
        [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:reaskType andAnswerContent:questionStr andQuestionId:question.questionId andAnswerID:answer.resultId  andResultId:@"1"];
    }
}

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{
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
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.activeIndexPath = path;
        AcceptAnswerInterface *acceptAnswerInter = [[AcceptAnswerInterface alloc]init];
        self.acceptAnswerInterface = acceptAnswerInter;
        self.acceptAnswerInterface.delegate = self;
        [self.acceptAnswerInterface getAcceptAnswerInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andQuestionId:question.questionId andAnswerID:answer.answerId andCorrectAnswerID:answer.resultId];
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
    QuestionAndAnswerCell_iPhone *cell = (QuestionAndAnswerCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:@"questionAndAnswerCell"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:indexPath.section];
    AnswerModel *answer = [question.answerList objectAtIndex:indexPath.row];
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
    QuestionAndAnswerCell_iPhoneHeaderView *header = (QuestionAndAnswerCell_iPhoneHeaderView*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    [header setQuestionModel:question withQuestionAndAnswerScope:self.questionAndAnswerScope];
    header.backgroundColor = [UIColor whiteColor];
    header.delegate = self;
    header.path = [NSIndexPath indexPathForRow:0 inSection:section];
    return header;
}


#pragma mark --

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    self.isReaskRefreshing = NO;
    if (self.headerRefreshView == refreshView) {
        self.footerRefreshView.isForbidden = YES;
        [self requestNewPageDataWithLastQuestionID:nil];
    }else{
        self.headerRefreshView.isForbidden = YES;
        QuestionModel *question = [self.myQuestionArr  lastObject];
        [self requestNewPageDataWithLastQuestionID:question.questionId];
    }
}

#pragma mark --

#pragma mark action

-(void)requestNewPageDataWithLastQuestionID:(NSString*)lastQuestionID{
    if (self.questionAndAnswerScope == QuestionAndAnswerALL) {
        [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andChapterQuestionId:self.chapterID andLastQuestionID:lastQuestionID];
    }else
        if (self.questionAndAnswerScope == QuestionAndAnswerMYANSWER) {
            [self.userQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andIsMyselfQuestion:@"1" andLastQuestionID:lastQuestionID];
        }else
            if (self.questionAndAnswerScope == QuestionAndAnswerMYQUESTION) {
                [self.userQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andIsMyselfQuestion:@"0" andLastQuestionID:lastQuestionID];
            }
}

-(float)getTableViewHeaderHeightWithSection:(NSInteger)section{
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:section];
    if (question.isEditing) {
        return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONHEARD_VIEW_WIDTH + TEXT_PADDING * 2].height + TEXT_HEIGHT + QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;
    }else{
        return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONHEARD_VIEW_WIDTH + TEXT_PADDING * 2].height + TEXT_HEIGHT;
    }
}

-(float)getTableViewRowHeightWithIndexPath:(NSIndexPath*)path{
    NSLog(@"%d,%d",path.section,path.row);
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    if (question.answerList == nil || [question.answerList count] <= 0) {
        return 0;
    }
    AnswerModel *answer = [question.answerList objectAtIndex:path.row];
    float questionTextFieldHeight = answer.isEditing?87:0;
    NSAttributedString *attriString =  [Utility getTextSizeWithAnswerModel:answer withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONANDANSWER_CELL_WIDTH];
    CGSize size = [Utility getAttributeStringSizeWithWidth:QUESTIONANDANSWER_CELL_WIDTH withAttributeString:attriString];
    if (platform >= 7.0) {
        return size.height+ TEXT_HEIGHT + TEXT_PADDING*3+ questionTextFieldHeight;
    }else{
        float height = size.height+ TEXT_HEIGHT + TEXT_PADDING+ questionTextFieldHeight;
        return height;
    }
}

#pragma mark --

#pragma mark property
-(void)setQuestionAndAnswerScope:(QuestionAndAnswerScope)questionAndAnswerScope{
    _questionAndAnswerScope = questionAndAnswerScope;
    switch (questionAndAnswerScope) {
        case QuestionAndAnswerALL:
            self.lhlNavigationBar.title.text = @"所有问答";
            break;
        case QuestionAndAnswerMYQUESTION:
            self.lhlNavigationBar.title.text = @"我的提问";
            break;
        default:
            self.lhlNavigationBar.title.text = @"我的回答";
            break;
    }
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

-(GetUserQuestionInterface *)userQuestionInterface{
    if (!_userQuestionInterface) {
        _userQuestionInterface = [[GetUserQuestionInterface alloc] init];
        _userQuestionInterface.delegate = self;
    }
    return _userQuestionInterface;
}

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
    [self.tableView setFrame: CGRectMake(frame.origin.x,self.lhlNavigationBar.frame.size.height + 5,frame.size.width,IP5(568, 480) - self.lhlNavigationBar.frame.size.height - 5 - self.tabBarController.tabBar.frame.size.height)];
}

#pragma mark DRAskQuestionViewControllerDelegate 提问问题成功时回调
-(void)askQuestionViewControllerDidAskingSuccess:(DRAskQuestionViewController *)controller{
    self.isReaskRefreshing = YES;
    [self requestNewPageDataWithLastQuestionID:nil];
}
#pragma mark --

#pragma mark AnswerPraiseInterfaceDelegate 赞回调
-(void)getAnswerPraiseInfoDidFinished:(NSDictionary *)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"赞成功"];
    QuestionModel *question = [self.myQuestionArr  objectAtIndex:self.activeIndexPath.section];
    AnswerModel *answer = [question.answerList objectAtIndex:self.activeIndexPath.row];
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
    self.isReaskRefreshing = YES;
    [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andChapterQuestionId:self.chapterID andLastQuestionID:nil];
}

-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg withReaskType:(ReaskType)reask{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"提交失败"];
}

//#pragma mark --
//#pragma mark GetUserQuestionInterfaceDelegate 加载我的回答或者我的提问新数据
//-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (self.isReaskRefreshing) {
//                self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
//                [self.tableView reloadData];
//            }else{
//                if (self.headerRefreshView.isForbidden) {//加载下一页
//                    [self.myQuestionArr addObjectsFromArray:chapterQuestionList];
//                }else{//重新加载
//                    self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
//                }
//                [self.tableView reloadData];
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [self.headerRefreshView endRefreshing];
//                self.headerRefreshView.isForbidden = NO;
//                [self.footerRefreshView endRefreshing];
//                self.footerRefreshView.isForbidden = NO;
//            }
//        });
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//    });
//}
//
//-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [Utility errorAlert:errorMsg];
//}
#pragma mark --

#pragma mark QuestionListInterfaceDelegate 加载所有问题新数据
-(void)getQuestionListInfoDidFinished:(NSDictionary *)result{
    if (!self.isReaskRefreshing) {
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
    }else{
        if (result) {
            NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
            if (chapterQuestionList && [chapterQuestionList count] > 0) {
                self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    
    
    
}

-(void)getQuestionListInfoDidFailed:(NSString *)errorMsg{
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
    [Utility errorAlert:errorMsg];
}
#pragma mark --


#pragma mark -- AcceptAnswerInterfaceDelegate 采纳答案
-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            QuestionModel *question = [self.myQuestionArr  objectAtIndex:self.activeIndexPath.section];
            AnswerModel *answer = [question.answerList objectAtIndex:self.activeIndexPath.row];
            question.isAcceptAnswer = @"1";
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
    if (self.questionAndAnswerScope == QuestionAndAnswerALL) {
        [self.headerRefreshView free];
        [self.footerRefreshView free];
    }
}

@end
