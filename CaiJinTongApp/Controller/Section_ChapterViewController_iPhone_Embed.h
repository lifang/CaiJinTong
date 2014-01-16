//
//  Section_ChapterViewController_iPhone_Embed.h
//  CaiJinTongApp
//
//  Created by apple on 14-1-2.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Section_ChapterViewController_iPhone_Embed : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableViewList;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void)viewDidCurrentView;
@property (nonatomic, assign) BOOL isMovieView;//是否在播放界面显示
@property (nonatomic, strong) NSString *lessonId;
-(void)changeTableFrame:(CGRect)frame;
@end