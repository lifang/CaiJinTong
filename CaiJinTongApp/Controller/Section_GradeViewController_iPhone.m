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
@interface Section_GradeViewController_iPhone ()

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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView_iPhone *)view score:(float)score
{
}
#pragma -- 提交
static NSString *timespan = nil;
-(IBAction)submitBtnPressed:(id)sender {
    if (self.starRatingView.score==0 && self.textView.text.length==0) {
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
        CGSize size = [Utility getTextSizeWithString:comment.content withFont:[UIFont systemFontOfSize:10] withWidth:261];
        return size.height+30;
    }
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_GradeCell_iPhoneCell";
    Section_GradeCell_iPhoneCell *cell = (Section_GradeCell_iPhoneCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (indexPath.row<self.dataArray.count) { // 正常的cell
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        CGSize size = [Utility getTextSizeWithString:comment.content withFont:[UIFont systemFontOfSize:10] withWidth:261];
        cell.contentLab.layer.borderWidth = 1.0;
        cell.contentLab.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
        cell.contentLab.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        cell.contentLab.frame = CGRectMake(7, 15, 261, size.height+10);
        cell.contentLab.font = [UIFont systemFontOfSize:10];
        cell.contentLab.contentInset = UIEdgeInsetsMake(-3, 0, 0, 0);
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
        model.nickName = user.userName;
    }
    model.time = [Utility getNowDateFromatAnDate];
    model.content = self.textView.text;
    [self.dataArray addObject:model];
    [self.tableViewList reloadData];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableViewList) {
        [self.textView resignFirstResponder];
    }
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
        [self.commentInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andPageIndex:self.nowPage];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refeshScore" object:result userInfo:nil];
            //隐藏打分栏，只出现评论框
            self.isGrade = 1;
            [self performSelectorOnMainThread:@selector(displayView) withObject:nil waitUntilDone:YES];
            if (self.nowPage == self.pageCount) {
                //更新tableview
                [self insertCommitDataInToCommentTable];
                
            }
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
@end

