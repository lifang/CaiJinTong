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
#import "SectionSaveModel.h"
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
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:)
                                                 name: @"downloadStart"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:)
                                                 name: @"downloadFinished"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:)
                                                 name: @"downloadFailed"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:)
                                                 name:@"removeDownLoad"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:)
                                                 name:@"stopDownLoad"
                                               object:nil];
    
    [self.tableViewList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
}


-(void)initBtn:(NSNotification *)notification {
    dispatch_async ( dispatch_get_main_queue (), ^{
        [self.tableViewList reloadData];
    });
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
    
    chapterModel *chapter = [self.dataArray objectAtIndex:indexPath.section];
    SectionModel *section = [chapter.sectionList objectAtIndex:indexPath.row];
    section.lessonId = self.lessonId;
    cell.nameLab.text = [NSString stringWithFormat:@"【%@】",section.sectionName];
    cell.sid = section.sectionId;
    
    //查询数据库
    Section *sectionDb = [[Section alloc]init];
    SectionSaveModel *sectionSave = [sectionDb getDataWithSid:section.sectionId];
    float contentlength = [sectionDb getContentLengthBySid:section.sectionId];
    //进度条
    if (sectionSave) {
        if (sectionSave.downloadState== 0) {
            cell.statusLab.text = @"下载中...";
        }else if (sectionSave.downloadState== 1) {
            cell.statusLab.text = @"已下载";
        }else if (sectionSave.downloadState == 2) {
            cell.statusLab.text = @"继续下载";
        }else if (sectionSave.downloadState == 4) {
            cell.statusLab.text = @"未下载";
        }else  {
            cell.statusLab.text = @"下载";
        }
        cell.sliderFrontView.frame = CGRectMake(0, 33, CAPTER_CELL_WIDTH * sectionSave.downloadPercent, 15);
        if (contentlength>0) {
            cell.lengthLab.text = [NSString stringWithFormat:@"%.2fM/%.2fM",contentlength*sectionSave.downloadPercent,contentlength];
        }
        sectionSave.fileUrl = section.sectionMovieDownloadURL;
        sectionSave.playUrl = section.sectionMoviePlayURL;
        sectionSave.name = section.sectionName;
        sectionSave.lessonId = self.lessonId;
        cell.btn.buttonModel = sectionSave;
        
    }else {
        sectionSave = [[SectionSaveModel alloc]init];
        sectionSave.sid = section.sectionId;
        sectionSave.downloadState = 4;
        sectionSave.name = section.sectionName;
        sectionSave.downloadPercent = 0;
        sectionSave.fileUrl = section.sectionMovieDownloadURL;
        sectionSave.playUrl = section.sectionMoviePlayURL;
        sectionSave.name = section.sectionName;
        sectionSave.lessonId = self.lessonId;
        cell.btn.buttonModel = sectionSave;
        cell.sliderFrontView.frame = CGRectMake(0, 33, CAPTER_CELL_WIDTH * 0, 15);
        cell.statusLab.text = @"未下载";
        cell.lengthLab.text = @"";
    }
    cell.sectionModel = section;
    cell.isMoviePlayView = self.isMovieView;
    cell.btn.isMovieView = self.isMovieView;
    cell.sectionS = sectionSave;
    if(section.sectionLastTime){
        NSString *sectionLastTime = [NSString stringWithString:section.sectionLastTime];
        sectionLastTime = [sectionLastTime stringByReplacingOccurrencesOfString:@"小时" withString:@"h"];
        sectionLastTime = [sectionLastTime stringByReplacingOccurrencesOfString:@"分" withString:@"´"];
        sectionLastTime = [sectionLastTime stringByReplacingOccurrencesOfString:@"秒" withString:@"〞"];
        cell.timeLab.text = sectionLastTime;
    }else{
        cell.timeLab.text = nil;
    }
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

@end
