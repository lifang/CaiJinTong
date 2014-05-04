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
    cell.btn.isMovieView = self.isMovieView;
    [cell beginReceiveNotification];
    if ([CaiJinTongManager shared].isShowLocalData) {
        [cell.playBt setTitle:@"删 除" forState:UIControlStateNormal];
        cell.playBt.hidden = NO;
        cell.playBt.userInteractionEnabled = YES;
    }
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
@end
