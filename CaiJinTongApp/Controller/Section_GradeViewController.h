//
//  Section_GradeViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CustomTextView.h"

#import "CommentListInterface.h"
#import "GradeInterface.h"
#import "MJRefresh.h"
@interface Section_GradeViewController : UIViewController<StarRatingViewDelegate,UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,CommentListInterfaceDelegate,GradeInterfaceDelegate,MJRefreshBaseViewDelegate>


- (void)viewDidCurrentView;
@property (nonatomic, strong) CommentListInterface *commentInterface;
@property (nonatomic, strong) GradeInterface *gradeInterface;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) NSInteger isGrade;//0可以打分，1已经打过分
//@property (nonatomic, assign) NSInteger pageCount;//评论的总页数用来判断分页加载
@property (nonatomic, assign) NSInteger nowPage;//当先评论列表的页码
@property (nonatomic, strong) NSString *lessonId;//
@property (strong, nonatomic) TQStarRatingView *starRatingView;
@property (nonatomic, strong) IBOutlet CustomTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *myComment;
@property (weak, nonatomic) IBOutlet UIView *commentBackView;
@property (weak, nonatomic) IBOutlet UIView *commentListBackView;
@property (nonatomic, strong) IBOutlet UIButton *submitBtn;
@end
