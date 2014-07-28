//
//  Section_GradeViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView_iPhone.h"
#import "CustomTextView.h"
#import "MJRefresh.h"
#import "CommentListInterface.h"
#import "GradeInterface.h"
@interface Section_GradeViewController_iPhone : UIViewController<StarRatingViewDelegate_iPhone,UITableViewDataSource, UITableViewDelegate,UITextViewDelegate,CommentListInterfaceDelegate,GradeInterfaceDelegate,MJRefreshBaseViewDelegate>


- (void)viewDidCurrentView;
@property (nonatomic, strong) CommentListInterface *commentInterface;
@property (nonatomic, strong) GradeInterface *gradeInterface;
@property (nonatomic, strong) NSMutableArray *dataArray;//评论数据,内含CommentModel对象
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) NSInteger isGrade;//0可以打分，1已经打过分
@property (nonatomic, strong) NSString *sectionId;
@property (nonatomic, assign) NSInteger nowPage;//当先评论列表的页码
@property (nonatomic, strong) NSString *lessonId;//
@property (nonatomic, strong) TQStarRatingView_iPhone *starRatingView;
@property (nonatomic, strong) IBOutlet CustomTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *myComment;
@property (nonatomic, strong) IBOutlet UIButton *submitBtn;
@end
