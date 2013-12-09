//
//  Section_ChapterViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_ChapterViewController_iPhone : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)viewDidCurrentView;
@end
