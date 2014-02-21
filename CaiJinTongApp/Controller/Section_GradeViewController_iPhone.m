//
//  Section_GradeViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_GradeViewController_iPhone.h"
#import "Section_GradeCell_iPhoneCell.h"
#import "CommentModel.h"
#define COMMENT_CELL_WIDTH 276
@interface Section_GradeViewController_iPhone ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) MJRefreshFooterView *footerRefreshView;
@property (nonatomic,assign) CGPoint lastContentOffset;
@end

@implementation Section_GradeViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)dealloc{
    [self.footerRefreshView free];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewList.tag = LessonViewTagType_commentTableViewTag;
    self.tableViewList.delegate = self;
    [self.footerRefreshView endRefreshing];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sunsliderScrollWillBeginDragging) name:@"SUNSlideScrollWillDraggingNotification" object:nil];
    [self displayView];
}
- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
    [self displayView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//界面布局
-(void)displayView {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.isGrade == 0) {//有打分界面
            if (!self.starRatingView) {
                TQStarRatingView_iPhone *starRating = [[TQStarRatingView_iPhone alloc] initWithFrame:CGRectMake(22, 0, 276, IP5(44, 34)) numberOfStar:5];
                starRating.delegate = self;
                starRating.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
                [self.view addSubview:starRating];
                self.starRatingView = starRating;
            }
            
            self.textView.frame = CGRectMake(22,CGRectGetMaxY(self.starRatingView.frame), 276,IP5(53, 43));
            
            self.myComment.frame = CGRectMake(22, self.submitBtn.frame.origin.y+40, 100, 30);
            self.tableViewList.frame =  CGRectMake(22, self.myComment.frame.origin.y+40, 276, self.view.frame.size.height-self.submitBtn.frame.origin.y-60);
            [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
            if(!IS_4_INCH){
                [self.submitBtn setFrame:CGRectMake(110, 88, 100, 27)];
            }
            self.textView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        }else {//隐藏打分界面
            NSArray *subViews = [self.view subviews];
            for (UIView *vv in subViews) {
                if ([vv isKindOfClass:[TQStarRatingView_iPhone class]]) {
                    TQStarRatingView_iPhone *vview = (TQStarRatingView_iPhone *)vv;
                    [vview removeFromSuperview];
                }else if ([vv isKindOfClass:[UILabel class]]) {
                    UILabel *lab = (UILabel *)vv;
                    if (lab.tag == 9999) {
                        [lab removeFromSuperview];
                    }
                }else if([vv isKindOfClass:[CustomTextView class]]){
                    CustomTextView *textView = (CustomTextView *)vv;
                    [textView removeFromSuperview];
                }else if([vv isKindOfClass:[UIButton class]]){
                    UIButton *btn = (UIButton *) vv;
                    [btn removeFromSuperview];
                }
            }
            self.myComment.frame = CGRectMake(22, 0, 100, 16);
            self.tableViewList.frame =  CGRectMake(22, self.myComment.frame.origin.y+15, 276,self.view.frame.size.height - 15);
            [self.view layoutSubviews];
            [self.tableViewList reloadData];
        }
    });
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self displayView];
}
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView_iPhone *)view score:(float)score
{
}
#pragma -- 提交
static NSString *timespan = nil;
-(IBAction)submitBtnPressed:(id)sender {
    if (self.textView.text.length==0) {
        [Utility errorAlert:@"说点什么吧..."];
    }else {
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
            if ([networkStatus isEqualToString:@"NotReachable"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [Utility errorAlert:@"暂无网络"];
            }else{
                timespan = [Utility getNowDateFromatAnDate];//提交时间
                GradeInterface *gradeInter = [[GradeInterface alloc]init];
                self.gradeInterface = gradeInter;
                self.gradeInterface.delegate = self;
                [self.gradeInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId
                                                            andSectionId:self.lessonId
                                                                andScore:[NSString stringWithFormat:@"%d",self.starRatingView.score]
                                                              andContent:self.textView.text];
            }
        }];
    }
}

#pragma mark -- UITableView scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset;
    [scrollView setScrollEnabled:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [scrollView setScrollEnabled:YES];
    if (scrollView == self.tableViewList) {
        [self.textView resignFirstResponder];
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    UITableView *parentTableView = (UITableView*)[self.parentViewController.view viewWithTag:LessonViewTagType_lessonRootScrollViewTag];
    if (self.lastContentOffset.y > scrollView.contentOffset.y) {//向下
        if (parentTableView && scrollView.contentOffset.y <= 0) {
            [scrollView setScrollEnabled:NO];
            [parentTableView setContentOffset:(CGPoint){0,0} animated:YES];
        }
    }else{//向上
        if (parentTableView && parentTableView.contentOffset.y <= 0) {
            [scrollView setScrollEnabled:NO];
            [parentTableView setContentOffset:(CGPoint){0,160} animated:YES];
        }
    }
    
}
#pragma mark --

#pragma mark-- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<self.dataArray.count) {
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.commentContent withFont:[UIFont systemFontOfSize:10] withWidth:261];
        return size.height+30;
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
    static NSString *CellIdentifier = @"Section_GradeCell_iPhoneCell";
    Section_GradeCell_iPhoneCell *cell = (Section_GradeCell_iPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.commentContent withFont:[UIFont systemFontOfSize:10] withWidth:261];
        cell.contentLab.layer.borderWidth = 1.0;
        cell.contentLab.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
        cell.contentLab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.contentLab.frame = CGRectMake(7, 15, 261, size.height+10);
        cell.contentLab.font = [UIFont systemFontOfSize:10];
        cell.contentLab.contentInset = UIEdgeInsetsMake(-3, 0, 0, 0);
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
        model.commentAuthorName = user.nickName;
    }
    model.commentCreateDate = [Utility getNowDateFromatAnDate];
    model.commentContent = self.textView.text;
    self.textView.text = @"";
    [self.textView resignFirstResponder];
    [self.dataArray insertObject:model atIndex:0];
    [self.tableViewList reloadData];
    [Utility errorAlert:@"提交评论成功"];
}

#pragma mark MJRefreshBaseViewDelegate 分页加载
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    [self loadMore];
}

//评论的分页加载
-(void)loadMore {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Utility judgeNetWorkStatus:^(NSString *networkStatus) {
        if ([networkStatus isEqualToString:@"NotReachable"]) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [Utility errorAlert:@"暂无网络"];
        }else{
            self.nowPage +=1;
            CommentListInterface *commentList = [[CommentListInterface alloc]init];
            self.commentInterface = commentList;
            self.commentInterface.delegate = self;
            [self.commentInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.lessonId andPageIndex:self.nowPage];
        }
    }];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
    [self.footerRefreshView endRefreshing];
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
            //更新tableview
            [self insertCommitDataInToCommentTable];
        });
    });
}
-(void)getGradeInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark textView delegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    UIView *view = self.view;
    while(view.tag != 33){  //33为SectionViewController_iPhone的view tag
        view = [view superview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [view setFrame:CGRectMake(0, -150, 320, 568)];
    }];
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    UIView *view = self.view;
    while(view.tag != 33){  //33为SectionViewController_iPhone的view tag
        view = [view superview];
    }
    [UIView animateWithDuration:0.3 animations:^{
        [view setFrame:CGRectMake(0, 0, 320, 568)];
    }];
    return YES;
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
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
        [_tipLabel setText:@"暂无评价"];
    }
    return _tipLabel;
}

@end

