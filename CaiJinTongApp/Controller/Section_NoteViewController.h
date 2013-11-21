//
//  Section_NoteViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_NoteViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
- (void)viewDidCurrentView;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@end
