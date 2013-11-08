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
	TQStarRatingView *starRatingView = [[TQStarRatingView alloc] initWithFrame:CGRectMake(100, 20, 250, 50) numberOfStar:5];
    starRatingView.delegate = self;
    [self.view addSubview:starRatingView];
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
#pragma  -- 打分
-(void)starRatingView:(TQStarRatingView *)view score:(float)score
{
    DLog(@"score = %.2f",score*5);
//    self.scoreLabel.text = [NSString stringWithFormat:@"%0.2f",score*5 ];
}
#pragma -- UITableViewDelegate 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
    CGSize size = [comment.content sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+25;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_GradeCell";
    Section_GradeCell *cell = (Section_GradeCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Section_GradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CommentModel *comment = (CommentModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
    CGSize size = [comment.content sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    cell.contentLab.frame = CGRectMake(25, 25, 500, size.height);
    cell.titleLab.text = comment.nickName;
    cell.contentLab.text = comment.content;
    return cell;
}

@end
