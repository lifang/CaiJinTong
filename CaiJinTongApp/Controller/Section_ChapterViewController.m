//
//  Section_ChapterViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_ChapterViewController.h"
#import "Section_ChapterCell.h"
#import "SectionModel.h"
#import "AMProgressView.h"
#import "Section.h"

#define CAPTER_CELL_WIDTH 650
@interface Section_ChapterViewController ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,strong) NSIndexPath *indexPathOfDeletingCell;  //正在被删除的indexPath
@end
@implementation Section_ChapterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
#pragma mark -- tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    chapterModel *chapter = [self.dataArray objectAtIndex:section];
    return chapter.sectionList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [tableView addSubview:self.tipLabel];
    }else{
        [self.tipLabel removeFromSuperview];
    }
    return [self.dataArray count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    chapterModel *chapter = [self.dataArray objectAtIndex:section];
    header.textLabel.text = chapter.chapterName;
    header.textLabel.font = [UIFont systemFontOfSize:18];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Section_ChapterCell";
    Section_ChapterCell *cell = (Section_ChapterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    chapterModel *chapter = (chapterModel *)[self.dataArray objectAtIndex:indexPath.section];
    SectionModel *section = [chapter.sectionList objectAtIndex:indexPath.row];
    section.lessonId = self.lessonId;
    cell.nameLab.text = [NSString stringWithFormat:@"【%@】",section.sectionName];
    cell.sid = section.sectionId;
    
    cell.sectionModel = section;
    cell.isMoviePlayView = self.isMovieView;
    if (self.isMovieView && indexPath.row == 0) {
        DLog(@"章节列表bug : self.dataArray.count = %d ,\n chapter.sectionList.count = %d ,\n shared.lesson.chapterList.count = %d ,\n",self.dataArray.count,chapter.sectionList.count,[CaiJinTongManager shared].lesson.chapterList.count);
    }
    cell.btn.isMovieView = self.isMovieView;
    [cell beginReceiveNotification];
    if ([CaiJinTongManager shared].isShowLocalData) {
        [cell.playBt setTitle:@"删除" forState:UIControlStateNormal];
        cell.playBt.hidden = NO;
        cell.playBt.userInteractionEnabled = YES;
        cell.playBt.tag = indexPath.section * 100000 + indexPath.row;
        [cell.playBt addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
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
        _tipLabel.font = [UIFont systemFontOfSize:30];
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

- (void)deleteButtonClicked:(id)sender{
    NSInteger tag = ((UIButton *)sender).tag;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:tag % 100000 inSection:tag / 100000];
    self.indexPathOfDeletingCell = indexPath;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"确定删除?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [alert show];
    });
}

- (void)deleteSection:(NSIndexPath *)indexPath{
    if ([CaiJinTongManager shared].isShowLocalData) {
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

#pragma  mark -- UIAlertView Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex > 0) {
        [self deleteSection:self.indexPathOfDeletingCell];
    }
    self.indexPathOfDeletingCell = nil;
}

@end
