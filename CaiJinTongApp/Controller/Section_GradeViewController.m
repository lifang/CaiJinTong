//
//  Section_GradeViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_GradeViewController.h"
#import "Section_GradeCell.h"
#import "CommentModel.h"
#define COMMENT_CELL_WIDTH 650
@interface Section_GradeViewController ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@end

@implementation Section_GradeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.footerRefreshView endRefreshing];
    if (!self.starRatingView) {
        self.starRatingView = [[TQStarRatingView alloc] initWithFrame:(CGRect){29,6,COMMENT_CELL_WIDTH+5,51} numberOfStar:5];
        self.starRatingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self.commentBackView addSubview:self.starRatingView];
    }
    [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
    self.textView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
    self.starRatingView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sunsliderScrollWillBeginDragging) name:@"SUNSlideScrollWillDraggingNotification" object:nil];
}
- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
    [self displayView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)displayView {
    CGRect listRect = self.commentListBackView.frame;
    if (self.isGrade == 0) {//有打分界面
        [self.commentBackView setHidden:NO];
        self.commentListBackView.frame = (CGRect){listRect.origin.x,CGRectGetMaxY(self.commentBackView.frame),listRect.size};
    }else {//隐藏打分界面
        [self.commentBackView setHidden:YES];
        self.commentListBackView.frame = (CGRect){listRect.origin.x,CGRectGetMinY(self.commentBackView.frame),listRect.size.width,380};
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self displayView];
}
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    
}
#pragma -- 提交
static NSString *timespan = nil;
-(IBAction)submitBtnPressed:(id)sender {
    if (self.textView.text.length==0) {
        [Utility errorAlert:@"说点什么吧..."];
    }else {
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            timespan = [Utility getNowDateFromatAnDate];//提交时间
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            GradeInterface *gradeInter = [[GradeInterface alloc]init];
            self.gradeInterface = gradeInter;
            self.gradeInterface.delegate = self;
            [self.gradeInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.lessonId andScore:[NSString stringWithFormat:@"%d",self.starRatingView.score]andContent:self.textView.text];
        }
    }
}
#pragma mark-- UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<self.dataArray.count) {
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.commentContent withFont:[UIFont systemFontOfSize:15] withWidth:COMMENT_CELL_WIDTH];
        return size.height+20+35;
    }
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [tableView addSubview:self.tipLabel];
    }else{
        [self.tipLabel removeFromSuperview];
    }
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_GradeCell";
    Section_GradeCell *cell = (Section_GradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
    CGSize size = [Utility getTextSizeWithString:comment.commentContent withFont:[UIFont systemFontOfSize:15] withWidth:COMMENT_CELL_WIDTH];
    cell.contentLab.layer.borderWidth = 2.0;
    cell.contentLab.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    cell.contentLab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    cell.contentLab.frame = CGRectMake(25, 25, COMMENT_CELL_WIDTH, size.height+10);
    cell.contentLab.font = [UIFont systemFontOfSize:15];
    cell.alpha = 0.5;
    cell.contentLab.text = [comment.commentContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    cell.titleLab.text = [NSString stringWithFormat:@"%@发表于%@",comment.commentAuthorName,comment.commentCreateDate];
    
    return cell;
}
//提交评论成功后加入到评论列表
-(void)insertCommitDataInToCommentTable{
    CommentModel *model = [[CommentModel alloc] init];
    UserModel *user = [[CaiJinTongManager shared] user];
    if (user) {
        model.nickName = user.nickName;
    }
    model.time = [Utility getNowDateFromatAnDate];
    model.content = self.textView.text;
    self.textView.text = @"";
    [self.textView resignFirstResponder];
    [self.dataArray insertObject:model atIndex:0];
    [self.tableViewList reloadData];
    [Utility errorAlert:@"提交评论成功"];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableViewList) {
        [self.textView resignFirstResponder];
    }
}

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self loadMore];
}


//评论的分页加载
-(void)loadMore {
    if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
        [Utility errorAlert:@"暂无网络!"];
    }else {
        self.nowPage +=1;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        CommentListInterface *commentList = [[CommentListInterface alloc]init];
        self.commentInterface = commentList;
        self.commentInterface.delegate = self;
        [self.commentInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.lessonId andPageIndex:self.nowPage];
    }
}

#pragma mark Notification
-(void)sunsliderScrollWillBeginDragging{
    [self.textView resignFirstResponder];
}
#pragma mark --

#pragma  mark --CommentListInterfaceDelegate
-(void)getCommentListInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (result.commentList.count>0) {
            [self.dataArray addObjectsFromArray:result.commentList];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableViewList reloadData];
            [self.footerRefreshView endRefreshing];
        });
    });
}
-(void)getCommentListInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
        [self.footerRefreshView endRefreshing];
    });

}

#pragma  mark --GradeInterfaceDelegate
-(void)getGradeInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSMutableDictionary *resultDic = [NSMutableDictionary dictionaryWithDictionary:result];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refeshScore" object:resultDic userInfo:nil];
            //隐藏打分栏，只出现评论框
            self.isGrade = 1;
            [self displayView];
            [self insertCommitDataInToCommentTable];
        });
    });
}
-(void)getGradeInfoDidFailed:(NSString *)errorMsg {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [Utility errorAlert:errorMsg];
    });

}

#pragma mark property

-(MJRefreshFooterView *)footerRefreshView{
    if (!_footerRefreshView) {
        _footerRefreshView = [[MJRefreshFooterView alloc] init];
        _footerRefreshView.delegate = self;
        _footerRefreshView.scrollView = self.tableViewList;
        
    }
    return _footerRefreshView;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,COMMENT_CELL_WIDTH,self.tableViewList.frame.size.height}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:30];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}
#pragma mark --
@end
