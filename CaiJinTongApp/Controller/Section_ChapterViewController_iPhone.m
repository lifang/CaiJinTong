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
#import "AMProgressView.h"
#import "Section.h"
@interface Section_ChapterViewController_iPhone ()

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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_ChapterCell_iPhone";
    Section_ChapterCell_iPhone *cell = (Section_ChapterCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Section_chapterModel *section = (Section_chapterModel *)[self.dataArray objectAtIndex:indexPath.row];
    
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
        }else {
            cell.statusLab.text = @"下载";
        }
        cell.sliderFrontView.frame = CGRectMake(0, 37, 277 * sectionSave.downloadPercent, 11);
        if (contentlength>0) {
            cell.lengthLab.text = [NSString stringWithFormat:@"%.2fM/%.2fM",contentlength*sectionSave.downloadPercent,contentlength];
        }
        cell.btn.buttonModel = sectionSave;
        
    }else {
        sectionSave = [[SectionSaveModel alloc]init];
        sectionSave.sid = section.sectionId;
        sectionSave.downloadState = 4;
        sectionSave.downloadPercent = 0;
        cell.btn.buttonModel = sectionSave;
        cell.sliderFrontView.frame = CGRectMake(0, 37, 277 * 0, 11);
        cell.statusLab.text = @"未下载";
        cell.lengthLab.text = @"";
    }
    cell.sectionS = sectionSave;
    cell.timeLab.text = section.sectionLastTime;
    return cell;
}
@end
