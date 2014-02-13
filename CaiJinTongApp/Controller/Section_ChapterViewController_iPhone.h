//
//  Section_ChapterViewController_iPhone.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_ChapterViewController_iPhone : UIViewController<UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)viewDidCurrentView;
@property (nonatomic, assign) BOOL isMovieView;//是否在播放界面显示
@property (nonatomic, strong) NSString *lessonId;
-(void)changeTableFrame:(CGRect)frame;
@end
