//
//  Section_NoteViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_NoteViewController_iPhone : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (void)viewDidCurrentView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@end
