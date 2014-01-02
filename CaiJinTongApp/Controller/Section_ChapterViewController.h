//
//  Section_ChapterViewController.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section_chapterModel.h"
#import "CommentModel.h"
@interface Section_ChapterViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) IBOutlet UITableView *tableViewList;
@property (nonatomic, assign) BOOL isMovieView;//是否在播放界面显示
@property (nonatomic, strong) NSString *lessonId;
- (void)viewDidCurrentView;
@end
