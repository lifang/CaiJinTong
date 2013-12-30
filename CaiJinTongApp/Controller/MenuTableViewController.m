//
//  MenuTableViewController.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MenuTableViewController.h"
#define LESSON_HEADER_IDENTIFIER @"lessonHeader"
static NSString  *CellIdentifier = @"lessonCell";
static NSString *chapterName;
@implementation MenuTableViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView registerClass:[MenuTableCell class] forCellReuseIdentifier:CellIdentifier];
    [self.tableView registerClass:[LessonListHeaderView_iPhone class] forHeaderFooterViewReuseIdentifier:LESSON_HEADER_IDENTIFIER];
    [self.tableView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
    [self initData];
}

//获取数据
-(void)initData{

}

#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
        if (section != self.lessonList.count-1) {
            LessonListHeaderView_iPhone *header = (LessonListHeaderView_iPhone*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
            LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
            header.lessonTextLabel.font = [UIFont systemFontOfSize:15];
            header.lessonDetailLabel.font = [UIFont systemFontOfSize:15];
            
            header.lessonTextLabel.text = lesson.lessonName;
            header.lessonDetailLabel.text = [NSString stringWithFormat:@"%d",[lesson.chapterList count]];
            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
            header.delegate = self;
            BOOL isSelSection = NO;
            for (int i = 0; i < self.arrSelSection.count; i++) {
                NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
                NSInteger selSection = strSection.integerValue;
                if (section == selSection) {
                    isSelSection = YES;
                    break;
                }
            }
            header.isSelected = isSelSection;
            return header;
        }else {
            LessonListHeaderView_iPhone *header = (LessonListHeaderView_iPhone*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:LESSON_HEADER_IDENTIFIER];
            header.flagImageView.image = Image(@"backgroundStar.png");
            header.lessonTextLabel.text = @"本地下载";
            header.path = [NSIndexPath indexPathForRow:0 inSection:section];
            header.delegate = self;
            return header;
        }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.lessonList.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        NSInteger count = 0;
        for (int i = 0; i < self.arrSelSection.count; i++) {
            NSString *strSection = [NSString stringWithFormat:@"%@",[self.arrSelSection objectAtIndex:i]];
            NSInteger selSection = strSection.integerValue;
            if (section == selSection) {
                return 0;
            }
        }
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:section];
        count = lesson.chapterList.count;
        return count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MenuTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
    chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
    chapterName = [NSString stringWithFormat:@"%@",chapter.chapterName];
    NSURL *imgURL = [NSURL URLWithString:chapter.chapterImg];
    ASIHTTPRequest *httpRequest = [ASIHTTPRequest requestWithURL:imgURL];
    [httpRequest startSynchronous];
    cell.imageViews.image = [UIImage imageWithData:[httpRequest responseData]];
    cell.textLabels.text = chapter.chapterName;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
        AppDelegate *app = [AppDelegate sharedInstance];
        app.isLocal = NO;
        //根据chapterId获取章下面视频信息
        LessonModel *lesson = (LessonModel *)[self.lessonList objectAtIndex:indexPath.section];
        chapterModel *chapter = (chapterModel *)[lesson.chapterList objectAtIndex:indexPath.row];
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            ChapterInfoInterface *chapterInter = [[ChapterInfoInterface alloc]init];
            self.chapterInterface = chapterInter;
            self.chapterInterface.delegate = self;
            [self.chapterInterface getChapterInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andChapterId:chapter.chapterId];
        }
}

#pragma mark-- LessonInfoInterfaceDelegate
-(void)getLessonInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        self.lessonList = [NSMutableArray arrayWithArray:[result objectForKey:@"lessonList"]];
        [self.lessonList  addObject:@"本地下载"];
        
        //建立标记数组,用于标记是否选中
        self.arrSelSection = [[NSMutableArray alloc] init];
        for (int i =0; i<self.lessonList.count; i++) {
            [self.arrSelSection addObject:[NSString stringWithFormat:@"%d",i]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [self.tableView reloadData];
        });
    });
}

-(void)getLessonInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

#pragma mark -- ChapterInfoInterfaceDelegate
-(void)getChapterInfoDidFinished:(NSDictionary *)result {  //章节信息查询完毕,显示章节界面
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
        });
    });
}

-(void)getChapterInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [Utility errorAlert:errorMsg];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end