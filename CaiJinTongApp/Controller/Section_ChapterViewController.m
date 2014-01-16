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
#import "SectionSaveModel.h"
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_ChapterCell";
    Section_ChapterCell *cell = (Section_ChapterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Section_ChapterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    chapterModel *chapter = [self.dataArray objectAtIndex:indexPath.section];
    SectionModel *section = [chapter.sectionList objectAtIndex:indexPath.row];
    section.lessonId = self.lessonId;
    cell.nameLab.text = section.sectionName;
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
        }else {
            cell.statusLab.text = @"下载";
        }
        cell.sliderFrontView.frame = CGRectMake(47, 73, CAPTER_CELL_WIDTH * sectionSave.downloadPercent, 33);
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
        cell.sliderFrontView.frame = CGRectMake(47, 73, CAPTER_CELL_WIDTH * 0, 33);
        cell.statusLab.text = @"未下载";
        cell.lengthLab.text = @"";
    }
    cell.sectionModel = section;
    cell.isMoviePlayView = self.isMovieView;
    cell.btn.isMovieView = self.isMovieView;
    cell.sectionS = sectionSave;
    cell.timeLab.text = section.sectionLastTime;
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
#pragma mark --
@end
