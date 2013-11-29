//
//  Section_GradeViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
#import "CustomTextView.h"

#import "CommentListInterface.h"
#import "GradeInterface.h"
@interface Section_GradeViewController_iPhone : UIViewController<StarRatingViewDelegate,UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,CommentListInterfaceDelegate,GradeInterfaceDelegate>


- (void)viewDidCurrentView;
@property (nonatomic, strong) CommentListInterface *commentInterface;
@property (nonatomic, strong) GradeInterface *gradeInterface;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) NSInteger isGrade;//0可以打分，1已经打过分
@property (nonatomic, assign) NSInteger pageCount;//评论的总页数用来判断分页加载
@property (nonatomic, assign) NSInteger nowPage;//当先评论列表的页码
@property (nonatomic, strong) NSString *sectionId;//
@property (nonatomic, strong) TQStarRatingView *starRatingView;
@property (nonatomic, strong) IBOutlet CustomTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *myComment;
@property (nonatomic, strong) IBOutlet UIButton *submitBtn;
@end
