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

- (void)viewDidLoad
{
    [super viewDidLoad];
//	TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(100, 20, 350, 50) numberOfStar:5];
//    starRatingView.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1.0];
//    starRatingView.delegate = self;
//    [self.view addSubview:starRatingView];
}
- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.isGrade == 0) {//有打分界面
        TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(100, 3, 250, 50) numberOfStar:5];
        starRatingView.delegate = self;
        [self.view addSubview:starRatingView];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(370, 3, 60, 50)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:16];
        label.textColor = [UIColor grayColor];
        label.text = @"0分";
        self.pointLab = label;
        [self.view addSubview:self.pointLab];
        label = nil;
        
        self.textView.frame = CGRectMake(25, starRatingView.frame.origin.y+55, 520, 70);
        self.submitBtn.frame =CGRectMake(240, self.textView.frame.origin.y+80, 90, 30);
        self.tableViewList.frame =CGRectMake(0, self.submitBtn.frame.origin.y+40, 768, self.view.frame.size.height-self.submitBtn.frame.origin.y-60);
    }else {//隐藏打分界面
        self.textView.frame = CGRectMake(25, 3, 520, 70);
        self.submitBtn.frame =CGRectMake(240, self.textView.frame.origin.y+80, 90, 30);
        self.tableViewList.frame =CGRectMake(0, self.submitBtn.frame.origin.y+40, 768, self.view.frame.size.height-self.submitBtn.frame.origin.y-60);
    }
   
}
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    DLog(@"score = %.2f",score*5);
    self.pointLab.text = [NSString stringWithFormat:@" %.2f分",score*5];
}
#pragma -- 提交
-(IBAction)submitBtnPressed:(id)sender {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"4.93",@"score", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refeshScore" object:dic userInfo:nil];
}
#pragma mark-- UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row<self.dataArray.count) {
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
        CGSize size = [comment.content sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        return size.height+25;
    }
    return 35;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_GradeCell";
    Section_GradeCell *cell = (Section_GradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Section_GradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row<self.dataArray.count) { // 正常的cell
        CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
        UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
        CGSize size = [comment.content sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
        cell.contentLab.frame = CGRectMake(25, 25, 500, size.height);
        cell.titleLab.text = [NSString stringWithFormat:@"%@发表于%@",comment.nickName,comment.time];
        cell.contentLab.text = comment.content;
    }else {
        DLog(@"%d,,%d",self.nowPage,self.pageCount);
        if (self.nowPage < self.pageCount) {
            cell.titleLab.text = @"正在加载..."; //最后一行 触发下载更新代码
            [self performSelector:@selector(loadMore) withObject:nil afterDelay:3];
        }else {
            cell.titleLab.text = @"已全部加载完毕"; //最后一行 触发下载更新代码
        }
        cell.contentLab.text = @"";
    }
    
    return cell;
}
-(void)scrollViewDidScroll:(UITableView *)scrollView {
    [self.textView resignFirstResponder];
}

//评论的分页加载
-(void)loadMore {
    if (self.nowPage < self.pageCount) {//还有评论
        self.nowPage =2;
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            NSDictionary *dictionary = [Utility initWithJSONFile:@"commentList"];
            NSDictionary *dic = [dictionary objectForKey:@"ReturnObject"];
            if (dic.count>0) {
                NSArray *array = [dic objectForKey:@"commentList"];
                if (array.count>0) {
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic_comment = [array objectAtIndex:i];
                        CommentModel *comment = [[CommentModel alloc]init];
                        comment.nickName = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"nickName"]];
                        comment.time = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"time"]];
                        comment.content = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"content"]];
                        comment.pageIndex = [[dic_comment objectForKey:@"pageIndex"]intValue];
                        comment.pageCount = [[dic_comment objectForKey:@"pageCount"]intValue];
                        [self.dataArray addObject:comment];
                    }
                }
                dispatch_async ( dispatch_get_main_queue (), ^{
                    [self.tableViewList reloadData];
                });
            }
            /*
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            CommentListInterface *commentList = [[CommentListInterface alloc]init];
            self.commentInterface = commentList;
            self.commentInterface.delegate = self;
            [self.commentInterface getGradeInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.sectionId andPageIndex:self.nowPage];
             */
        }
    }else {//加载完毕
        
    }
}

#pragma  mark --CommentListInterfaceDelegate
-(void)getCommentListInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"获取数据成功!"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
        });
    });
}
-(void)getCommentListInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}

@end
