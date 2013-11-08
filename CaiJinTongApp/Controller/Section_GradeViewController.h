//
//  Section_GradeViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TQStarRatingView.h"
@interface Section_GradeViewController : UIViewController<StarRatingViewDelegate,UITableViewDataSource, UITableViewDelegate>


- (void)viewDidCurrentView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) NSInteger pageCount;
@end
