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
@interface Section_GradeViewController ()
@property (nonatomic,strong) UILabel *tipLabel;
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
    if (self.isGrade == 0) {//有打分界面
        if (!self.starRatingView) {
            TQStarRatingView *starRating = [[TQStarRatingView alloc] initWithFrame:CGRectMake(25, 7, 520, 50) numberOfStar:5];
            starRating.delegate = self;
            starRating.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
            [self.view addSubview:starRating];
            self.starRatingView = starRating;
        }
        
        self.textView.frame = CGRectMake(25, self.starRatingView.frame.origin.y+55, 520, 70);
        self.submitBtn.frame =CGRectMake(240, self.textView.frame.origin.y+80, 90, 30);

        self.myComment.frame = CGRectMake(25, self.submitBtn.frame.origin.y+40, 100, 30);
        self.tableViewList.frame =  CGRectMake(0, self.myComment.frame.origin.y+40, 768, self.view.frame.size.height-self.submitBtn.frame.origin.y-60);
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
        
        self.textView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
        
    }else {//隐藏打分界面
        NSArray *subViews = [self.view subviews];
        for (UIView *vv in subViews) {
            if ([vv isKindOfClass:[TQStarRatingView class]]) {
                TQStarRatingView *vview = (TQStarRatingView *)vv;
                [vview removeFromSuperview];
            }else if ([vv isKindOfClass:[UILabel class]]) {
                UILabel *lab = (UILabel *)vv;
                if (lab.tag == 9999) {
                    [lab removeFromSuperview];
                }
            }
        }
        self.textView.frame = CGRectMake(25, 3, 520, 70);
        self.submitBtn.frame =CGRectMake(240, self.textView.frame.origin.y+80, 90, 30);
 
        self.myComment.frame = CGRectMake(25, self.submitBtn.frame.origin.y+40, 100, 30);
        self.tableViewList.frame =  CGRectMake(0, self.myComment.frame.origin.y+40, 768, self.view.frame.size.height-self.submitBtn.frame.origin.y-60);
        [self.submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitBtn setBackgroundImage:[UIImage imageNamed:@"btn0.png"] forState:UIControlStateNormal];
        
        self.textView.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];

    }
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

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
            [self.gradeInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andScore:[NSString stringWithFormat:@"%d",self.starRatingView.score]andContent:self.textView.text];
        }
    }
}
#pragma mark-- UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<self.dataArray.count) {
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.content withFont:[UIFont systemFontOfSize:15] withWidth:500];
        return size.height+20+35;
    }
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [self.tableViewList addSubview:self.tipLabel];
        
    }
    return self.dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_GradeCell";
    Section_GradeCell *cell = (Section_GradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row<self.dataArray.count) { // 正常的cell
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.content withFont:[UIFont systemFontOfSize:15] withWidth:500];
        cell.contentLab.layer.borderWidth = 2.0;
        cell.contentLab.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
        cell.contentLab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.contentLab.frame = CGRectMake(25, 25, 500, size.height+10);
        cell.contentLab.font = [UIFont systemFontOfSize:15];
        cell.alpha = 0.5;
        cell.contentLab.text = [comment.content stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        cell.titleLab.text = [NSString stringWithFormat:@"%@发表于%@",comment.nickName,comment.time];
    }else {
        if (self.nowPage < self.pageCount) {
            cell.titleLab.text = @"正在加载..."; //最后一行 触发下载更新代码
            [self performSelector:@selector(loadMore) withObject:nil afterDelay:3];
        }else {
            cell.titleLab.text = @"已全部加载完毕";
        }
        cell.contentLab.text = @"";
    }

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

//评论的分页加载
-(void)loadMore {
    if (self.nowPage < self.pageCount) {//还有评论
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            self.nowPage +=1;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            CommentListInterface *commentList = [[CommentListInterface alloc]init];
            self.commentInterface = commentList;
            self.commentInterface.delegate = self;
            [self.commentInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andPageIndex:self.nowPage];
        }
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
        });
    });
}
-(void)getCommentListInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark property
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,self.tableViewList.frame.size}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:30];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}
#pragma mark --
@end
