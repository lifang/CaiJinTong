//
//  MyQuestionAndAnswerViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionAndAnswerViewController_iPhone.h"
#import "IndexPathModel.h"
@interface MyQuestionAndAnswerViewController_iPhone ()
@property (nonatomic,strong) NSMutableArray *myQuestionArr;
@property (nonatomic,strong) NSMutableArray *questionIndexesArray;//问题序号数组 ,储存所有Header的row值
@property (nonatomic,strong) MJRefreshHeaderView *headerRefreshView;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,strong) QuestionListInterface *questionListInterface;//所有问题的分页加载
@property (nonatomic,strong) GetUserQuestionInterface *userQuestionInterface;//我的回答或者我的提问分页加载
@property (nonatomic,strong) SubmitAnswerInterface *submitAnswerInterface;//提交回答或者是提交追问
@property (nonatomic,strong) NSIndexPath *activeIndexPath;//正在处理中的cell
@property (nonatomic,assign) BOOL isReaskRefreshing;//判断是追问刷新还是上拉下拉刷新
@property (nonatomic,strong) LHLAskQuestionViewController *askQuestionController;
@property (nonatomic,strong) UIButton *askQuestionBtn;  //我要提问button
@property (nonatomic,strong) DRTreeTableView *drTreeTableView;
@property (nonatomic, strong) QuestionInfoInterface *questionInfoInterface;//获取所有问答分类
@property (nonatomic, strong) MyQuestionCategatoryInterface *myQuestionCategatoryInterface;//获取我的提问分类
@property (nonatomic, strong) MyQuestionCategatoryInterface *myAnswerCategatoryInterface;//获取我的回答分类
@property (nonatomic, strong) NSArray *allQuestionCategoryArr;//所有问答分类信息
@property (nonatomic, strong) NSArray *myQuestionCategoryArr;//我的提问分类信息
@property (nonatomic, strong) NSArray *myAnswerCategoryArr;//我的回答分类信息
@property (nonatomic,strong) NSString *questionAndSwerRequestID;//请求问题列表ID
//@property (nonatomic, strong) ChapterQuestionInterface *chapterQuestionInterface;//点击列表之后请求问答信息的接口
@property (nonatomic,strong) SearchQuestionInterface *searchQuestionInterface;//搜索问答接口
@property (nonatomic,strong) UIViewController *modelController; //点击图片显示的VC
@property (nonatomic,strong) ChapterSearchBar_iPhone *searchBar;//搜索栏+按钮
@property (nonatomic,strong) UIButton *showSearchBarBtn; //显示/隐藏搜索栏
@property (assign,nonatomic) BOOL isClickOrSearching; //如果用户点击列表,或者搜索按钮,则出结果之后tableView要滚动到顶部
@property (assign,nonatomic) BOOL isRequesting; //为YES表示正在请求接口,还没有得到回复
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

//-(void)viewWillAppear:(BOOL)animated{
//    if(!self.isRequesting){
//        [self makeNewData];
//    }
//}

-(void)willDismissPopoupController{
    CGPoint offset = self.tableView.contentOffset;
    [self.tableView setContentOffset:offset animated:NO];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.lhlNavigationBar.leftItem.hidden = YES;
    //临时,搜索按钮
    CGPoint center = self.lhlNavigationBar.leftItem.center;
    self.showSearchBarBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
    self.showSearchBarBtn.frame = (CGRect){0,0,40,40};
//    self.showSearchBarBtn.center = (CGPoint){center.x + 205,center.y};
    self.showSearchBarBtn.center = (CGPoint){center.x + 45,center.y};
    [self.showSearchBarBtn setImage:[UIImage imageNamed:@"_magnifying_glass.png"] forState:UIControlStateNormal];
//    [self.showSearchBarBtn setTitle:@"搜" forState:UIControlStateNormal];
//    [self.showSearchBarBtn.titleLabel setFont:[UIFont systemFontOfSize:19.0]];
//    [self.showSearchBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.showSearchBarBtn addTarget:self action:@selector(showSearchBar) forControlEvents:UIControlEventTouchUpInside];
//    [self.showSearchBarBtn.layer setBorderColor:[UIColor whiteColor].CGColor];
//    [self.showSearchBarBtn.layer setBorderWidth:1.5];
//    [self.showSearchBarBtn.layer setCornerRadius:4.0];
//    [self.lhlNavigationBar addSubview:self.showSearchBarBtn];
    
    [self.headerRefreshView endRefreshing];//instance refresh view
    [self.footerRefreshView endRefreshing];
    [self.tableView registerClass:[QuestionAndAnswerCell_iPhoneHeaderView class] forCellReuseIdentifier:@"header"];
//    [self.tableView setFrame: CGRectMake(20,CGRectGetMaxY(self.noticeBarView.frame) + 5,281,IP5(568, 480) - CGRectGetMaxY(self.noticeBarView.frame) - 5 - self.tabBarController.tabBar.frame.size.height)];
    
    //提问按钮
    if(!self.askQuestionBtn){
        self.askQuestionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.askQuestionBtn setFrame:(CGRect){0,0,40,40}];
        self.askQuestionBtn.center = (CGPoint){self.showSearchBarBtn.center.x + 180,self.showSearchBarBtn.center.y};
        [self.askQuestionBtn setBackgroundColor:[UIColor clearColor]];
        [self.askQuestionBtn setImage:[UIImage imageNamed:@"_question_mark.png"] forState:UIControlStateNormal];
        [self.askQuestionBtn addTarget:self action:@selector(askQuestionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.lhlNavigationBar addSubview:self.askQuestionBtn];
    }
    [self.noticeBarImageView.layer setCornerRadius:4];
    
    self.questionIndexesArray = [NSMutableArray arrayWithCapacity:5];
    
    //数据
    [self makeNewData];
    
    [self.view addSubview:self.searchBar];
    
    if (platform >= 7.0) {
        self.tableView.frame = CGRectMake(10,100, 320,IP5(400, 330) ) ;
    }else{
        self.tableView.frame = CGRectMake(10,100, 320,IP5(400, 330) ) ;
    }
    
}

//获取问题tableView所需的数据
-(void)getQuestionCategoryNodes{
    [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionInfoInterface *questionInfoInter = [[QuestionInfoInterface alloc]init];
            self.questionInfoInterface = questionInfoInter;
            self.questionInfoInterface.delegate = self;
            [self.questionInfoInterface getQuestionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId];
            
            UserModel *user = [[CaiJinTongManager shared] user];
            [MBProgressHUD showHUDAddedToTopView:self.view animated:YES];
            [self.myQuestionCategatoryInterface downloadMyQuestionCategoryDataWithUserId:user.userId];
        }
    }];
    
}

#pragma mark 数据

-(void)makeNewData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //此接口property及其代理+回调方法也删掉
    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
    self.getUserQuestionInterface.delegate = self;
    self.questionScope = QuestionAndAnswerMYQUESTION;
    //请求我的回答
    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:nil];
    self.isRequesting = YES;
}



#pragma mark --

//数据源
-(void)reloadDataWithDataArray:(NSArray*)data withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope{
    self.questionScope = scope;
    self.chapterID = chapterID;
    self.myQuestionArr = [NSMutableArray arrayWithArray:data];
    if (self.myQuestionArr.count>0) {
        QuestionModel *question = [self.myQuestionArr  lastObject];
        self.question_pageIndex = question.pageIndex;
        self.question_pageCount = question.pageCount;
        dispatch_async ( dispatch_get_main_queue (), ^{
            [self.tableView reloadData];
        });
    }
}

//数据源
-(void)nextPageDataWithDataArray:(NSArray*)data withQuestionChapterID:(NSString*)chapterID withScope:(QuestionAndAnswerScope)scope{
    self.questionScope = scope;
    self.chapterID = chapterID;
    [self.myQuestionArr addObjectsFromArray:data];
    self.headerRefreshView.isForbidden = NO;
    self.footerRefreshView.isForbidden = NO;
    [self.headerRefreshView endRefreshing];
    [self.footerRefreshView endRefreshing];
    
    
    if (self.myQuestionArr.count>0) {
        [self.tableView reloadData];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark DRAttributeStringViewDelegate用户点击图片内容时调用
-(void)drAttributeStringView:(DRAttributeStringView *)attriView clickedFileURL:(NSURL *)url withFileType:(DRURLFileType)fileType{
    if (fileType == DRURLFileType_OTHER) {
        [Utility errorAlert:@"无法打开文件，请到电脑上查看"];
        return;
    }
    if (!self.modelController) {
        self.modelController = [[UIViewController alloc] init];
    }
    for (UIView *subView in self.modelController.view.subviews) {
        [subView removeFromSuperview];
    }
    UIWebView *webView = [[UIWebView alloc] init];
    [self.modelController.view addSubview:webView];
    self.modelController.view.frame = (CGRect){0,0,300,IP5(548, 460)};
    webView.frame = (CGRect){0,0,300,IP5(548, 460)};
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self presentPopupViewController:self.modelController animationType:MJPopupViewAnimationSlideTopTop isAlignmentCenter:YES dismissed:^{
        
    }];
}

-(void)scanImageFromImageUrl:(NSURL*)imageURL{
    if (!self.modelController) {
        self.modelController = [[UIViewController alloc] init];
    }
    for (UIView *subView in self.modelController.view.subviews) {
        [subView removeFromSuperview];
    }
    UIWebView *webView = [[UIWebView alloc] init];
    [self.modelController.view addSubview:webView];
    self.modelController.view.frame = (CGRect){0,0,300,225};
    webView.frame = (CGRect){0,0,300,225};
    webView.scalesPageToFit = YES;
    [webView loadRequest:[NSURLRequest requestWithURL:imageURL]];
    [self presentPopupViewController:self.modelController animationType:MJPopupViewAnimationSlideTopTop isAlignmentCenter:YES dismissed:^{
        
    }];
}

#pragma mark QuestionAndAnswerCell_iPhoneHeaderViewDelegate
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header scanAttachmentFileAtIndexPath:(NSIndexPath *)path{
//    QuestionModel *question = [self.myQuestionArr  objectAtIndex:path.section];
    QuestionModel *question = [self questionForIndexPath:path];
    NSString *extension = [[question.attachmentFileUrl pathExtension] lowercaseString];
    if ([extension isEqualToString:@"png"]
        || [extension isEqualToString:@"jpg"]
        || [extension isEqualToString:@"jpeg"]
        || [extension isEqualToString:@"pdf"]
        || [extension isEqualToString:@"doc"]
        || [extension isEqualToString:@"docx"]
        || [extension isEqualToString:@"txt"]
        || [extension isEqualToString:@"ppt"]
        || [extension isEqualToString:@"gif"]) {
        [self scanImageFromImageUrl:[NSURL URLWithString:question.attachmentFileUrl]];
    }else{
        [Utility errorAlert:@"无法打开，请到电脑上打开使用"];
    }
}
-(float)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header headerHeightAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self questionForIndexPath:path];
    CGRect rect = [DRAttributeStringView boundsRectWithQuestion:question withWidth:kQUESTIONHEARD_VIEW_WIDTH-6];
    return rect.size.height;
}

//赞问题
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header flowerQuestionAtIndexPath:(NSIndexPath *)path{
    
}
//将要点击回答问题按钮
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header willAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self questionForIndexPath:path];
    question.isEditing = !question.isEditing;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (question.isEditing) {
        //把输入框textView移动到合适的位置
        [self closeOtherTextFieldsExcepteThisOne:path withType:YES];
        CGPoint offset = self.tableView.contentOffset;//当前窗口的偏移值
        CGRect rowFrame = [self.tableView rectForRowAtIndexPath:path];//当前row的位置
        CGFloat rowHeight = rowFrame.size.height;//row高度,其中回答模块高度87
        CGFloat aY = CGRectGetMaxY(rowFrame) - kQUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;//回答模块的上沿坐标
        CGFloat aHeight = kQUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT + 246.0 - IP5(63, 50);//上沿坐标的理想高度(相对tableView下沿)
        CGFloat bHeight = self.tableView.frame.size.height - (rowFrame.origin.y - offset.y + rowHeight - kQUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT);//当前上沿的高度(相对tableView下沿)
        CGFloat toOffsetY = offset.y + (aHeight - bHeight);//理想高度时的窗口Y偏移值
        [UIView animateWithDuration:0.5 animations:^{
            if(self.tableView.contentSize.height > self.tableView.frame.size.height){
                if(aHeight > self.tableView.contentSize.height - aY){//如果aY以下内容不足呈现理想位置,则滑动到内容最下方
                    [self.tableView setContentOffset:(CGPoint){rowFrame.origin.x, self.tableView.contentSize.height - self.tableView.frame.size.height}];
                }else if(aHeight > bHeight){
                    //如果剩余内容高度足够,且ay比理想位置低,则移动到理想位置
                    [self.tableView setContentOffset:(CGPoint){offset.x,toOffsetY}];
                }
            }
        } completion:^(BOOL finished) {
            //上移结束之后 ,弹出键盘
            if (question.isEditing) {
                QuestionAndAnswerCell_iPhoneHeaderView *cell = (QuestionAndAnswerCell_iPhoneHeaderView *)[self.tableView cellForRowAtIndexPath:path];
                [cell.answerQuestionTextField becomeFirstResponder];
            }
        }];
    }
}

//提交问题的答案
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header didAnswerQuestionAtIndexPath:(NSIndexPath *)path withAnswer:(NSString *)text{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionModel *question = [self questionForIndexPath:path];
            question.isEditing = NO;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:path.section] withRowAnimation:UITableViewRowAnimationAutomatic];
            [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:ReaskType_None andAnswerContent:text andQuestionId:question.questionId andAnswerID:0  andResultId:@"0" andIndexPath:[IndexPathModel initWithRow:path.row withSection:path.section]];
        }
    }];
}

//开始编辑回答
-(void)questionAndAnswerCell_iPhoneHeaderView:(QuestionAndAnswerCell_iPhoneHeaderView *)header willBeginTypeAnswerQuestionAtIndexPath:(NSIndexPath *)path{
    float sectionHeight = [self getTableViewRowHeightWithIndexPath:path];
    CGRect sectionRect = [self.tableView rectForRowAtIndexPath:path];
    float sectionMinHeight = CGRectGetMinY(sectionRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetHeight(self.tableView.frame) - sectionHeight-IP5(188, 200);
    if (sectionMinHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (sectionMinHeight - keyheight)} animated:YES];
    }
}
#pragma mark --

#pragma mark QuestionAndAnswerCell_iPhoneDelegate


-(float)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell getCellheightAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self questionForIndexPath:path];
    AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
    
    CGRect rect = [DRAttributeStringView boundsRectWithAnswer:answer withWidth:lQUESTIONANDANSWER_CELL_WIDTH];
    return rect.size.height;
}

//键盘弹出
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell willBeginTypeQuestionTextFieldAtIndexPath:(NSIndexPath *)path{
    float sectionHeight = [self getTableViewRowHeightWithIndexPath:path];
    CGRect sectionRect = [self.tableView rectForRowAtIndexPath:path];
    float sectionMinHeight = CGRectGetMinY(sectionRect) - self.tableView.contentOffset.y;
    float keyheight = CGRectGetHeight(self.tableView.frame) - sectionHeight-IP5(188, 200);
    if (sectionMinHeight > keyheight) {
        [self.tableView setContentOffset:(CGPoint){self.tableView.contentOffset.x,self.tableView.contentOffset.y+ (sectionMinHeight - keyheight)} animated:YES];
    }
}

-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell flowerAnswerAtIndexPath:(NSIndexPath *)path{
    //    answer.isPraised = YES;
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionModel *question = [self questionForIndexPath:path];
            AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
            self.activeIndexPath = path;
            [self.answerPraiseinterface getAnswerPraiseInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andQuestionId:question.questionId andResultId:answer.resultId];
        }
    }];
}

//追问
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell summitQuestion:(NSString *)questionStr atIndexPath:(NSIndexPath *)path withReaskType:(ReaskType)reaskType{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            QuestionModel *question = [self questionForIndexPath:path];
            AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
            [self.submitAnswerInterface getSubmitAnswerInterfaceDelegateWithUserId:[[CaiJinTongManager shared] userId] andReaskTyep:reaskType andAnswerContent:questionStr andQuestionId:question.questionId andAnswerID:answer.resultId  andResultId:@"1" andIndexPath:[IndexPathModel initWithRow:path.row withSection:path.section]];
        }
    }];
}
//点击cell触发
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell isHiddleQuestionView:(BOOL)isHiddle atIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self questionForIndexPath:path];
    AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
    answer.isEditing = isHiddle;
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    if (answer.isEditing) {
        //把输入框textView移动到合适的位置
        [self closeOtherTextFieldsExcepteThisOne:path withType:NO];
        CGPoint offset = self.tableView.contentOffset;//当前窗口的偏移值
        CGRect rowFrame = [self.tableView rectForRowAtIndexPath:path];//当前row的位置
        CGFloat rowHeight = rowFrame.size.height;//row高度,其中回答模块高度87
        CGFloat aY = CGRectGetMaxY(rowFrame) - 87;//回答模块的上沿坐标
        CGFloat aHeight = 87 + 246.0 - IP5(63, 50);//上沿坐标的理想高度(相对tableView下沿)
        CGFloat bHeight = self.tableView.frame.size.height - (rowFrame.origin.y - offset.y + rowHeight -87);//当前上沿的高度(相对tableView下沿)
        CGFloat toOffsetY = offset.y + (aHeight - bHeight);//理想高度时的窗口Y偏移值
        [UIView animateWithDuration:0.5 animations:^{
            if(self.tableView.contentSize.height > self.tableView.frame.size.height){
                if(aHeight > self.tableView.contentSize.height - aY){//如果aY以下内容不足呈现理想位置,则滑动到内容最下方
                    [self.tableView setContentOffset:(CGPoint){rowFrame.origin.x, self.tableView.contentSize.height - self.tableView.frame.size.height}];
                }else if(aHeight > bHeight){
                    //如果剩余内容高度足够,且ay比理想位置低,则移动到理想位置
                    [self.tableView setContentOffset:(CGPoint){offset.x,toOffsetY}];
                }
            }
        } completion:^(BOOL finished) {
            //上移结束之后 ,弹出键盘
            if (answer.isEditing) {
                QuestionAndAnswerCell_iPhone *cell = (QuestionAndAnswerCell_iPhone *)[self.tableView cellForRowAtIndexPath:path];
                [cell.questionTextField becomeFirstResponder];
            }
        }];
    }
    
}
//采纳答案
-(void)QuestionAndAnswerCell_iPhone:(QuestionAndAnswerCell_iPhone *)cell acceptAnswerAtIndexPath:(NSIndexPath *)path{
    QuestionModel *question = [self questionForIndexPath:path];
    AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            self.activeIndexPath = path;
            AcceptAnswerInterface *acceptAnswerInter = [[AcceptAnswerInterface alloc]init];
            self.acceptAnswerInterface = acceptAnswerInter;
            self.acceptAnswerInterface.delegate = self;
            [self.acceptAnswerInterface getAcceptAnswerInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andQuestionId:question.questionId andAnswerID:answer.answerId andCorrectAnswerID:answer.resultId];
        }
    }];
}
#pragma mark --

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self keyboardDismiss];
    self.menuVisible = NO;
//    if(self.searchBar.alpha > 0.999){
//        [self showSearchBar];
//    }
}

#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

//直接从self.myQuestionArr中刷新新的数据
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger index = 0;
    if(!self.questionIndexesArray){
        [Utility errorAlert:@"self.questionIndexesArray错误!"];
    }else{
        [self.questionIndexesArray removeAllObjects];
        for(QuestionModel *question in self.myQuestionArr){
            [self.questionIndexesArray addObject:[NSString stringWithFormat:@"%i",index]];
            index ++;
            if(question.answerList.count > 0){
                index += question.answerList.count;
            }
        }
    }
    return index;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getTableViewRowHeightWithIndexPath:indexPath];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if([self cellIsHeader:indexPath.row]){
        QuestionAndAnswerCell_iPhoneHeaderView *cell = (QuestionAndAnswerCell_iPhoneHeaderView *)[tableView dequeueReusableCellWithIdentifier:@"header"];
        QuestionModel *question = [self questionForIndexPath:indexPath];
        [cell setQuestionModel:question withQuestionAndAnswerScope:self.questionScope];
        cell.backgroundColor = [UIColor whiteColor];
        cell.delegate = self;
        cell.questionContentAttributeView.delegate = self;
        cell.path = indexPath;
        return cell;
    }else{
        QuestionAndAnswerCell_iPhone *cell = (QuestionAndAnswerCell_iPhone*)[tableView dequeueReusableCellWithIdentifier:@"questionAndAnswerCell"];
        QuestionModel *question = [self questionForIndexPath:indexPath];
        AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:indexPath]];
        [cell setAnswerModel:answer withQuestion:question];
        cell.delegate = self;
        cell.path = indexPath;
        cell.answerAttributeTextView.delegate = self;
        cell.contentView.frame = (CGRect){cell.contentView.frame.origin,CGRectGetWidth(cell.contentView.frame),[self getTableViewRowHeightWithIndexPath:indexPath]};
        return cell;
    }
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

#pragma mark action  动作
//显示/隐藏搜索栏
-(void)showSearchBar{
    return;
    if(self.searchBar.hidden){
        if(self.menuVisible){
            self.menuVisible = NO;
        }
        [self.searchBar setHidden:NO];
        [UIView animateWithDuration:0.5
                         animations:^{
//                             [self.searchBar setFrame:CGRectMake(19, IP5(65, 55), 282, 34)];
                             [self.searchBar setAlpha:1.0];
                         }
                         completion:nil];
    }else{
        [UIView animateWithDuration:0.5
                         animations:^{
                             [self.searchBar setAlpha:0.0];
//                             [self.searchBar setFrame:CGRectMake(19, IP5(65, 55), 1, 1)];
                         }
                         completion:^ void (BOOL completed){
                             if(completed){
                                 [self.searchBar setHidden:!self.searchBar.hidden];
                             }
                         }];
    }
}

-(void)rightItemClicked:(id)sender{
    [self.searchBar.searchTextField resignFirstResponder];
    
    if((!self.drTreeTableView || self.drTreeTableView.noteArr.count < 1) && self.menuVisible != YES){
        _drTreeTableView = [[DRTreeTableView alloc] initWithFrame:CGRectMake(120,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55)) withTreeNodeArr:nil];
        _drTreeTableView.delegate = self;
        [self.view addSubview:_drTreeTableView];
        [self.drTreeTableView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
        [self getQuestionCategoryNodes];  //获取tree所需数据
        self.menuVisible = YES;
    }else{
        self.menuVisible = !self.menuVisible;
    }
}

-(void)leftItemClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)askQuestionBtnClicked:(id)sender{
    LHLAskQuestionViewController * askQuestionController  = [self.storyboard instantiateViewControllerWithIdentifier:@"LHLAskQuestionViewController"];
        askQuestionController.delegate = self;
    
    [self.navigationController pushViewController:askQuestionController animated:YES];
    
}

-(void)setMenuVisible:(BOOL)menuVisible{
    _menuVisible = menuVisible;
    [UIView animateWithDuration:0.3 animations:^{
        if(menuVisible){
//            if(self.searchBar.hidden == NO){
//                [self showSearchBar];
//            }
            [self keyboardDismiss];
            self.drTreeTableView.frame = CGRectMake(120,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }else{
            self.drTreeTableView.frame = CGRectMake(320,IP5(65, 55), 200, SCREEN_HEIGHT - IP5(63, 50) - IP5(65, 55));
        }
    }];
}

-(void)keyboardDismiss{
    [self.searchBar.searchTextField resignFirstResponder];
    
    //暴力遍历所有cell
    for(int i = 0; i < self.tableView.visibleCells.count;i ++ ){
        if([self.tableView.visibleCells[i] isKindOfClass:[QuestionAndAnswerCell_iPhone class]]){
            QuestionAndAnswerCell_iPhone *cell = self.tableView.visibleCells[i];
            for(UIView *view in cell.contentView.subviews){
                if(view.isFirstResponder){
                    [view resignFirstResponder];return;
                }
                for(UIView *view2 in view.subviews){
                    if(view2.isFirstResponder){
                        [view2 resignFirstResponder];return;
                    }
                    for(UIView *view3 in view2.subviews){
                        if(view3.isFirstResponder){
                            [view3 resignFirstResponder];return;
                        }
                        for(UIView *view4 in view3.subviews){
                            if(view4.isFirstResponder){
                                [view4 resignFirstResponder];return;
                            }
                        }
                    }
                }
            }
        }else if([self.tableView.visibleCells[i] isKindOfClass:[QuestionAndAnswerCell_iPhoneHeaderView class]]){
            QuestionAndAnswerCell_iPhoneHeaderView *cell = self.tableView.visibleCells[i];
            for(UIView *view in cell.subviews){
                if(view.isFirstResponder){
                    [view resignFirstResponder];return;
                }
                for(UIView *view2 in view.subviews){
                    if(view2.isFirstResponder){
                        [view2 resignFirstResponder];return;
                    }
                    for(UIView *view3 in view2.subviews){
                        if(view3.isFirstResponder){
                            [view3 resignFirstResponder];return;
                        }
                        for(UIView *view4 in view3.subviews){
                            if(view4.isFirstResponder){
                                [view4 resignFirstResponder];return;
                            }
                        }
                    }
                }
            }
        }
    }
}

-(void)closeOtherTextFieldsExcepteThisOne:(NSIndexPath *)path withType:(BOOL) isQuestion{
    //关闭除指定path之外所有可输入的textView,改变其cell状态
    if(isQuestion){
        QuestionModel *currentQuestion = [self questionForIndexPath:path];
        for(QuestionModel *q in self.myQuestionArr){
            if(q.questionId != currentQuestion.questionId){
                q.isEditing = NO;
            }
            for(AnswerModel *a in q.answerList){
                a.isEditing = NO;
            }
        }
    }else{
        NSInteger answerIndex = [self answerForCellIndexPath:path];
        AnswerModel *currentAnswer = [self questionForIndexPath:path].answerList[answerIndex];
        for(QuestionModel *q in self.myQuestionArr){
            q.isEditing = NO;
            for(AnswerModel *a in q.answerList){
                if(a.answerId != currentAnswer.answerId){
                    a.isEditing = NO;
                }
            }
        }
    }
    [self.tableView reloadData];
}

-(void)requestNewPageDataWithLastQuestionID:(NSString*)lastQuestionID{
    UserModel *user = [[CaiJinTongManager shared] user];
    if (self.questionScope == QuestionAndAnswerALL) {
        [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:user.userId andChapterQuestionId:self.chapterID andLastQuestionID:lastQuestionID];
    }else
        if (self.questionScope == QuestionAndAnswerMYANSWER) {
            [self.userQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:user.userId andIsMyselfQuestion:@"1" andLastQuestionID:lastQuestionID withCategoryId:self.chapterID];
        }else
            if (self.questionScope == QuestionAndAnswerMYQUESTION) {
                [self.userQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:user.userId andIsMyselfQuestion:@"0" andLastQuestionID:lastQuestionID withCategoryId:self.chapterID];
            }else if (self.questionScope == QuestionAndAnswerSearchQuestion){
                QuestionModel *question = [self.myQuestionArr lastObject];
                [self.searchQuestionInterface getSearchQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchBar.searchTextField.text withLastQuestionId:question.questionId];
            }
}

-(float)getTableViewRowHeightWithIndexPath:(NSIndexPath*)path{
    QuestionModel *question = [self questionForIndexPath:path];
    if([self cellIsHeader:path.row]){  //如果是问题本身(header)
        CGRect rect;
        if (question.isEditing) {
            rect = [DRAttributeStringView boundsRectWithQuestion:question withWidth:kQUESTIONHEARD_VIEW_WIDTH-6];
            return rect.size.height + kHEADER_TEXT_HEIGHT + kTEXT_PADDING + kQUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;
        }else{
            rect = [DRAttributeStringView boundsRectWithQuestion:question withWidth:kQUESTIONHEARD_VIEW_WIDTH-6] ;
            return rect.size.height + kHEADER_TEXT_HEIGHT + kTEXT_PADDING ;
        }
//        if (question.isEditing) {
//            return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONHEARD_VIEW_WIDTH + TEXT_PADDING * 2].height + TEXT_HEIGHT + QUESTIONHEARD_VIEW_ANSWER_BACK_VIEW_HEIGHT;
//        }else{
//            return  [Utility getTextSizeWithString:question.questionName withFont:[UIFont systemFontOfSize:TEXT_FONT_SIZE+4] withWidth:QUESTIONHEARD_VIEW_WIDTH + TEXT_PADDING * 2].height + TEXT_HEIGHT;
//        }
    }
    if (question.answerList == nil || [question.answerList count] <= 0) {
        return 0;
    }
    AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:path]];
    float questionTextFieldHeight = answer.isEditing?87:0;
    CGRect rect = [DRAttributeStringView boundsRectWithAnswer:answer withWidth:lQUESTIONANDANSWER_CELL_WIDTH];
    if (platform >= 7.0) {
        return rect.size.height + lTEXT_PADDING*5+ questionTextFieldHeight;
    }else{
        return rect.size.height + lTEXT_PADDING*5+ questionTextFieldHeight;
    }
}

#pragma mark --

#pragma mark headerCell索引数组管理

-(BOOL)cellIsHeader:(NSInteger)row{  //根据row判断一个cell是不是header
    for(NSString *index in self.questionIndexesArray){
        if(row == index.integerValue){
            return YES;
        }
    }
    return NO;
}

-(QuestionModel *)questionForIndexPath:(NSIndexPath *) indexPath{ //根据indexPath获得其相应的question对象
    if(self.myQuestionArr.count == 1){
        return self.myQuestionArr[0];
    }
    for(int i = 1 ; i < self.questionIndexesArray.count;i ++){
        NSString *index = self.questionIndexesArray[i];
        if(index.integerValue > indexPath.row){
            return self.myQuestionArr[i - 1];
        }
        if(i == self.questionIndexesArray.count - 1){
            return self.myQuestionArr[i];
        }
    }
    return nil;
}

//根据cell的indexPath返回其在AnswerArray中的索引号
-(NSInteger)answerForCellIndexPath:(NSIndexPath *)indexPath{
    NSString *index;
    //1,计算其所属的问题索引
    //2,计算其与问题索引的偏差值,并以此作为从AnswerArray取出answer对象的依据
    for(int i = 1; i < self.questionIndexesArray.count; i ++ ){
        index = self.questionIndexesArray[i];
        if(index.integerValue > indexPath.row){
            NSString *headerIndex = self.questionIndexesArray[i - 1];
            return indexPath.row - headerIndex.integerValue - 1;
        }
    }
    return indexPath.row - index.integerValue - 1;
}

#pragma mark --

#pragma mark property
-(ChapterSearchBar_iPhone *)searchBar{
    if(!_searchBar){
        _searchBar = [[ChapterSearchBar_iPhone alloc] initWithFrame:CGRectMake(19, IP5(63, 63), 282, 34)];
        _searchBar.delegate = self;
//        [_searchBar setHidden:YES];
//        [_searchBar setAlpha:0.0];
        [_searchBar.searchTextField setPlaceholder:@"搜索问题"];
//        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}

-(SearchQuestionInterface *)searchQuestionInterface{
    if (!_searchQuestionInterface) {
        _searchQuestionInterface = [[SearchQuestionInterface alloc] init];
        _searchQuestionInterface.delegate = self;
    }
    return _searchQuestionInterface;
}

-(MyQuestionCategatoryInterface *)myQuestionCategatoryInterface{
    if (!_myQuestionCategatoryInterface) {
        _myQuestionCategatoryInterface = [[MyQuestionCategatoryInterface alloc] init];
        _myQuestionCategatoryInterface.delegate = self;
    }
    return _myQuestionCategatoryInterface;
}

-(MyQuestionCategatoryInterface *)myAnswerCategatoryInterface{
    if (!_myAnswerCategatoryInterface) {
        _myAnswerCategatoryInterface = [[MyQuestionCategatoryInterface alloc] init];
        _myAnswerCategatoryInterface.delegate = self;
    }
    return _myAnswerCategatoryInterface;
}


-(void)setQuestionScope:(QuestionAndAnswerScope)questionScope{
    _questionScope = questionScope;
    switch (_questionScope) {
        case QuestionAndAnswerALL:
            self.lhlNavigationBar.title.text = @"所有问答";
            break;
        case QuestionAndAnswerMYQUESTION:
            self.lhlNavigationBar.title.text = @"我的提问";
            break;
        case QuestionAndAnswerSearchQuestion:
            self.lhlNavigationBar.title.text = @"搜索";
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

#pragma mark
-(void)reLoadQuestionWithQuestionScope:(QuestionAndAnswerScope)scope withTreeNode:(DRTreeNode*)node{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            self.questionAndSwerRequestID = node.noteContentID;
            switch (scope) {
                case QuestionAndAnswerALL:
                {
                    QuestionListInterface *chapterInter = [[QuestionListInterface alloc]init];
                    self.questionListInterface = chapterInter;
                    self.questionListInterface.delegate = self;
                    self.questionAndSwerRequestID = node.noteContentID;
                    self.chapterID = node.noteContentID;
                    self.questionScope = QuestionAndAnswerALL;
                    [self.questionListInterface getQuestionListInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterQuestionId:self.chapterID andLastQuestionID:nil];
                }
                    break;
                case QuestionAndAnswerMYQUESTION:
                {
                    //请求我的提问
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    self.questionScope = QuestionAndAnswerMYQUESTION;
                    self.chapterID = node.noteContentID;
                    //                    NSMutableArray *array = [TestModelData getQuestion];
                    //                    [self.myQAVC reloadDataWithDataArray:array withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"0" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                case QuestionAndAnswerMYANSWER:
                {
                    self.getUserQuestionInterface = [[GetUserQuestionInterface alloc] init];
                    self.getUserQuestionInterface.delegate = self;
                    //请求我的回答
                    self.questionScope = QuestionAndAnswerMYANSWER;
                    self.chapterID = node.noteContentID;
                    [self.getUserQuestionInterface getGetUserQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andIsMyselfQuestion:@"1" andLastQuestionID:nil withCategoryId:node.noteContentID];
                }
                    break;
                default:
                    break;
            }
        }
    }];
}

//组合所有问答分类，我的提问问答分类，我的回答分类
-(NSMutableArray*)togetherAllQuestionCategorys{
    //我的提问列表
    DRTreeNode *myQuestion = [[DRTreeNode alloc] init];
    myQuestion.noteContentID = @"-1";
    myQuestion.noteContentName = @"我的提问";
    myQuestion.childnotes = self.myQuestionCategoryArr;
    myQuestion.noteLevel = 1;
    //所有问答列表
    DRTreeNode *question = [[DRTreeNode alloc] init];
    question.noteContentID = @"-2";
    question.noteContentName = @"所有问答";
    question.childnotes = self.allQuestionCategoryArr;
    question.noteLevel = 0;
    //我的回答列表
    DRTreeNode *myAnswer = [[DRTreeNode alloc] init];
    myAnswer.noteContentID = @"-3";
    myAnswer.noteContentName = @"我的回答";
    myAnswer.childnotes = self.myAnswerCategoryArr;
    myAnswer.noteLevel = 1;
    //我的问答
    DRTreeNode *my = [[DRTreeNode alloc] init];
    my.noteContentID = @"-4";
    my.noteContentName = @"我的问答";
    my.childnotes = @[myQuestion,myAnswer];
    my.noteLevel = 0;
    return [NSMutableArray arrayWithArray:@[question,my]];
}

#pragma mark DRTreeTableViewDelegate //选择一个分类
-(void)drTreeTableView:(DRTreeTableView *)treeView didSelectedTreeNode:(DRTreeNode *)selectedNote{
        switch ([selectedNote.noteRootContentID integerValue]) {
            case -2://所有问答
            {
                self.questionScope = QuestionAndAnswerALL;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -1://我的提问
            {
                self.questionScope = QuestionAndAnswerMYQUESTION;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -3://我的回答
            {
                self.questionScope = QuestionAndAnswerMYANSWER;
                [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:selectedNote];
            }
                break;
            case -4://我的问答
            {
            }
                break;
            default:{
                
            }
                break;
        }
    self.menuVisible = NO;
    self.searchBar.searchTextField.text = nil;
}

-(BOOL)drTreeTableView:(DRTreeTableView *)treeView isExtendChildSelectedTreeNode:(DRTreeNode *)selectedNote{
    return YES;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didExtendChildTreeNode:(DRTreeNode*)extendNote{
    switch ([extendNote.noteRootContentID integerValue]) {
        case -2://所有问答
        {
            self.questionScope = QuestionAndAnswerALL;
            [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:extendNote];
        }
            break;
        case -1://我的提问
        {
            self.questionScope = QuestionAndAnswerMYQUESTION;
            [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:extendNote];
        }
            break;
        case -3://我的回答
        {
            self.questionScope = QuestionAndAnswerMYANSWER;
            [self reLoadQuestionWithQuestionScope:self.questionScope withTreeNode:extendNote];
        }
            break;
        case -4://我的问答
        {
        }
            break;
        default:{
            
        }
            break;
    }
    self.searchBar.searchTextField.text = nil;
}

-(void)drTreeTableView:(DRTreeTableView*)treeView didCloseChildTreeNode:(DRTreeNode*)extendNote{
    
}

#pragma mark DRAskQuestionViewControllerDelegate 提问问题成功时回调
-(void)askQuestionViewControllerDidAskingSuccess:(LHLAskQuestionViewController *)controller{
    self.isReaskRefreshing = YES;
    [self requestNewPageDataWithLastQuestionID:nil];
}
#pragma mark --

#pragma mark AnswerPraiseInterfaceDelegate 赞回调
-(void)getAnswerPraiseInfoDidFinished:(NSDictionary *)result{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"赞成功"];
    QuestionModel *question = [self questionForIndexPath:self.activeIndexPath];
    AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:self.activeIndexPath]];
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
-(void)getSubmitAnswerInfoDidFinished:(NSMutableArray *)result withReaskType:(ReaskType)reask andIndexPath:(IndexPathModel *)path{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
     [Utility errorAlert:@"提交成功"];
    
    QuestionModel *question = [self questionForIndexPath:[NSIndexPath indexPathForRow:path.row inSection:path.section]];
    question.answerList = result;
    question.isEditing = NO;
    if(![self cellIsHeader:path.row]){
        AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:[NSIndexPath indexPathForRow:path.row inSection:path.section]]];
        answer.isEditing = NO;
    }
//    [self changeQuestionIndexPathToAnswerIndexPath:self.myQuestionArr];
//    int row = [self convertIndexpathToRow:path];
//    NSMutableArray *indexPathArr = [NSMutableArray array];
//    for (int index = 1; index <= result.count; index++) {
//        [indexPathArr addObject:[NSIndexPath indexPathForRow:row+index inSection:0]];
//    }
//    NSArray *indexPathArr = [NSArray arrayWithObject:path];
//    [self.tableView reloadRowsAtIndexPaths:indexPathArr withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView reloadData];
}

-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg withReaskType:(ReaskType)reask{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:@"提交失败"];
}




#pragma mark --

#pragma mark --MyQuestionCategatoryInterfaceDelegate 获取我的问答分类接口  ---有效接口1
-(void)getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:(NSArray *)myAnswerCategoryNotes withMyQuestionCategorynodes:(NSArray *)myQuestionCategoryNotes{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        self.myAnswerCategoryArr = myAnswerCategoryNotes;
        self.myQuestionCategoryArr = myQuestionCategoryNotes;
        self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
        
    });
}

-(void)getMyQuestionCategoryDataFailure:(NSString *)errorMsg{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --QuestionInfoInterfaceDelegate 获取所有问答分类信息     ---有效接口2
-(void)getQuestionInfoDidFinished:(NSArray *)questionCategoryArr {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        self.allQuestionCategoryArr = questionCategoryArr;
        [[CaiJinTongManager shared] setQuestionCategoryArr:questionCategoryArr] ;
        self.drTreeTableView.noteArr = [self togetherAllQuestionCategorys];
    });
}
-(void)getQuestionInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDFromTopViewForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });
}

#pragma mark --
#pragma mark --GetUserQuestionInterfaceDelegate 加载我的回答或者我的提问新数据   --有效接口
-(void)getUserQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!chapterQuestionList || chapterQuestionList.count < 1){
                [Utility errorAlert:@"已经到最后一页了!"];
            }
            if (self.isReaskRefreshing) {
                self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
                [self.tableView reloadData];
            }else{
                if (self.headerRefreshView.isForbidden) {//加载下一页
                    [self.myQuestionArr addObjectsFromArray:chapterQuestionList];
                }else{//重新加载
                    self.myQuestionArr = [NSMutableArray arrayWithArray:chapterQuestionList];
                }
                [self.tableView reloadData];
                
            }
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.headerRefreshView endRefreshing];
            self.headerRefreshView.isForbidden = NO;
            [self.footerRefreshView endRefreshing];
            self.footerRefreshView.isForbidden = NO;
            self.isRequesting = NO;
        });
    });
}

-(void)getUserQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
    self.isRequesting = NO;
}

//#pragma mark--ChapterQuestionInterfaceDelegate所有问答数据   --无效接口?? 点击tree的时候触发
//-(void)getChapterQuestionInfoDidFinished:(NSDictionary *)result {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [self reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.questionAndSwerRequestID withScope:self.questionScope];
//        });
//    });
//}
//-(void)getChapterQuestionInfoDidFailed:(NSString *)errorMsg {
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    [Utility errorAlert:errorMsg];
//}

#pragma mark --

#pragma mark QuestionListInterfaceDelegate 加载所有问题新数据    --- refresh的时候触发
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark --


#pragma mark SearchQuestionInterfaceDelegate搜索问答回调   --有效接口
-(void)getSearchQuestionInfoDidFailed:(NSString *)errorMsg{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
    self.searchBar.searchTextField.text = nil;
    [self.headerRefreshView endRefreshing];
    self.headerRefreshView.isForbidden = NO;
    [self.footerRefreshView endRefreshing];
    self.footerRefreshView.isForbidden = NO;
}

-(void)getSearchQuestionInfoDidFinished:(NSDictionary *)result{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.questionScope = QuestionAndAnswerSearchQuestion;
        NSArray *chapterQuestionList = [result objectForKey:@"chapterQuestionList"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(!chapterQuestionList || chapterQuestionList.count < 1){
                [Utility errorAlert:@"已经到最后一页了!"];
            }
//            self.lhlNavigationBar.title.text = [NSString stringWithFormat:@"搜索:%@",self.searchBar.searchTextField.text];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.question_pageIndex = self.question_pageIndex+1;
            if (self.headerRefreshView.isForbidden) {//加载下一页
                [self nextPageDataWithDataArray:chapterQuestionList withQuestionChapterID:self.chapterID withScope:QuestionAndAnswerSearchQuestion];
            }else{//重新加载
                [self reloadDataWithDataArray:chapterQuestionList withQuestionChapterID:self.chapterID withScope:QuestionAndAnswerSearchQuestion];
            }
            [self.headerRefreshView endRefreshing];
            self.headerRefreshView.isForbidden = NO;
            [self.footerRefreshView endRefreshing];
            self.footerRefreshView.isForbidden = NO;
        });
    });
}

#pragma mark --

#pragma mark -- AcceptAnswerInterfaceDelegate 采纳答案
-(void)getAcceptAnswerInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            QuestionModel *question = [self questionForIndexPath:self.activeIndexPath];
            AnswerModel *answer = [question.answerList objectAtIndex:[self answerForCellIndexPath:self.activeIndexPath]];
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

#pragma mark --

#pragma mark -- SearchBarDelegate
-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone*)searchBar beginningSearchString:(NSString*)searchText{
    if (self.searchBar.searchTextField.text.length == 0) {
        [Utility errorAlert:@"请输入搜索内容!"];
    }else {
        [self.searchBar.searchTextField resignFirstResponder];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:@"暂无网络"];
            }else{
                //            self.isSearching = YES;
                [self showSearchBar];
                [self.searchQuestionInterface getSearchQuestionInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andText:self.searchBar.searchTextField.text withLastQuestionId:nil];//@"0"
            }
        }];
    }
}

-(void)chapterSeachBar_iPhone:(ChapterSearchBar_iPhone *)searchBar clearSearchString:(NSString *)searchText{
    //留空
}

-(void)dealloc{
    [self.headerRefreshView free];
    [self.footerRefreshView free];
}

@end
