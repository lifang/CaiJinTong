//
//  Section_ChapterViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_ChapterViewController_iPhone.h"
#import "Section_ChapterCell_iPhone.h"
#import "SectionModel.h"
#import "Section.h"

#define CAPTER_CELL_WIDTH 277
@interface Section_ChapterViewController_iPhone ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,assign) CGPoint lastContentOffset;
@end
@implementation Section_ChapterViewController_iPhone

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)changeTableFrame:(CGRect)frame{
    self.tableViewList.frame = frame;
//    self.tableViewList.center = (CGPoint){self.tableViewList.center.x-233,self.tableViewList.center.y};
    [self.tableViewList reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.tableViewList.center = (CGPoint){self.tableViewList.center.x-233,self.tableViewList.center.y};
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableViewList.tag = LessonViewTagType_chapterTableViewTag;
    self.tableViewList.delegate = self;
    [self.tableViewList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
}


- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableView scrollViewDelegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.lastContentOffset = scrollView.contentOffset;
     [scrollView setScrollEnabled:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
     [scrollView setScrollEnabled:YES];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
   
    UITableView *parentTableView = (UITableView*)[self.parentViewController.view viewWithTag:LessonViewTagType_lessonRootScrollViewTag];
    if (self.lastContentOffset.y > scrollView.contentOffset.y) {//向下
        if (parentTableView && scrollView.contentOffset.y <= 0) {
            [scrollView setScrollEnabled:NO];
            [parentTableView setContentOffset:(CGPoint){0,0} animated:YES];
            [scrollView setScrollEnabled:YES];
        }
    }else{//向上
        if (parentTableView && parentTableView.contentOffset.y <= 0) {
            [scrollView setScrollEnabled:NO];
            [parentTableView setContentOffset:(CGPoint){0,160} animated:YES];
            [scrollView setScrollEnabled:YES];
        }
    }

}
#pragma mark --

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [tableView addSubview:self.tipLabel];
    }else{
        [self.tipLabel removeFromSuperview];
    }
    NSInteger number = [self.dataArray count];
    return number;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = ((chapterModel *)self.dataArray[section]).sectionList.count;
    return rows;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15.0;
}

-(UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
    chapterModel *chapter = [self.dataArray objectAtIndex:section];
    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,1,276,15}];
    label.font = [UIFont systemFontOfSize:12];
    label.text = chapter.chapterName;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [ UIColor lightGrayColor];
    [header.contentView addSubview:label];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_ChapterCell_iPhone";
    Section_ChapterCell_iPhone *cell = (Section_ChapterCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    chapterModel *chapter = (chapterModel *)[self.dataArray objectAtIndex:indexPath.section];
    SectionModel *section = [chapter.sectionList objectAtIndex:indexPath.row];
    section.lessonId = self.lessonId;
    cell.nameLab.text = [NSString stringWithFormat:@"【%@】",section.sectionName];
    cell.sid = section.sectionId;

    cell.sectionModel = section;
    cell.isMoviePlayView = self.isMovieView;
    cell.btn.isMovieView = self.isMovieView;
    [cell beginReceiveNotification];
    
    if ([CaiJinTongManager shared].isShowLocalData) {
        cell.playBt.hidden = NO;
        cell.playBt.userInteractionEnabled = YES;
        [cell.playBt setTitle:@"删除" forState:UIControlStateNormal];
        cell.playBt.tag = indexPath.section * 100000 + indexPath.row;
        [cell.playBt addTarget:self action:@selector(deleteSection:) forControlEvents:UIControlEventTouchUpInside];
    }
    [cell continueDownloadFileWithDownloadStatus:cell.sectionModel.sectionMovieFileDownloadStatus];
    return cell;
}

#pragma mark property
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,CAPTER_CELL_WIDTH,self.tableViewList.frame.size.height}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:25];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}

-(SectionModel*)searchSectionModel:(LessonModel*)lesson withSectionId:(NSString*)sectionId{
    if (!lesson || !sectionId) {
        return nil;
    }
    for (chapterModel *chapter in lesson.chapterList) {
        for (SectionModel *section in chapter.sectionList) {
            if ([section.sectionId isEqualToString:sectionId]) {
                return section;
            }
            
        }
    }
    return nil;
}

-(void)setDataArray:(NSMutableArray *)dataArray{
    _dataArray = dataArray;
    if (dataArray && dataArray.count > 0) {
        [DRFMDBDatabaseTool selectLessonTreeDatasWithUserId:[CaiJinTongManager shared].userId withLessonId:[CaiJinTongManager shared].lesson.lessonId withFinished:^(LessonModel *lesson, NSString *errorMsg) {
            if (lesson && lesson.chapterList.count > 0) {
                for (chapterModel *chapter in lesson.chapterList) {
                    for (SectionModel *section in chapter.sectionList) {
                        SectionModel *tempSection = [self searchSectionModel:[CaiJinTongManager shared].lesson withSectionId:section.sectionId];
                        if (tempSection) {
                            [tempSection copySection:section];
                        }
                    }
                }
                [self.tableViewList reloadData];
            }
        }];
    }
}

#pragma mark --

- (void)deleteSection:(id)sender{
    if ([CaiJinTongManager shared].isShowLocalData) {
        NSInteger tag = ((UIButton *)sender).tag;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag % 100000 inSection:tag / 100000];
        chapterModel *chapter = (chapterModel *)[self.dataArray objectAtIndex:indexPath.section];
        SectionModel *section = [chapter.sectionList objectAtIndex:indexPath.row];
        //被"下载资料管理"界面的"删除"按钮调用
        [[NSFileManager defaultManager] removeItemAtPath:section.sectionMovieLocalURL error:nil];
        [DRFMDBDatabaseTool deleteSectionWithUserId:[CaiJinTongManager shared].user.userId
                                      withSectionId:section.sectionId
                                       withFinished:^(BOOL flag) {
                                           dispatch_async(dispatch_get_main_queue(), ^{
                                               [chapter.sectionList removeObject:section]; //删除section
                                               [self.tableViewList deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
                                               dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, .4 * NSEC_PER_SEC);
                                               dispatch_after(delay, dispatch_get_main_queue(), ^{
                                                   if (chapter.sectionList.count == 0) {
                                                       [self.dataArray removeObject:chapter];   //删除chapter
                                                       if (self.dataArray.count == 0) {
                                                           //删除lesson
                                                           [DRFMDBDatabaseTool deleteLessonObjWithUserId:[CaiJinTongManager shared].user.userId withLessonObjId:self.lessonId withFinished:^(BOOL flag) {
                                                               
                                                           }];
                                                       }
                                                   }
                                                   //删除后必须刷新,以保证每个按钮的tag对应正确的indexPath
                                                   [self.tableViewList reloadData];
                                               });
                                           });
                                           
                                           
                                       }];
        return;
    }
}

@end
