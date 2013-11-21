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
#import "Section_chapterModel.h"
@interface Section_ChapterViewController ()

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
                                             selector:@selector(initBtn:) name:@"removeDownLoad" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(initBtn:) name:@"stopDownLoad" object:nil];
    
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
    static NSString *CellIdentifier = @"Section_ChapterCell";
    Section_ChapterCell *cell = (Section_ChapterCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Section_ChapterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    Section_chapterModel *section = (Section_chapterModel *)[self.dataArray objectAtIndex:indexPath.row];
    
    cell.nameLab.text = section.sectionName;
    cell.sid = section.sectionId;
    
    //查询数据库
    Section *sectionDb = [[Section alloc]init];
    SectionSaveModel *sectionSave = [sectionDb getDataWithSid:section.sectionId];
    float contentlength = [sectionDb getContentLengthBySid:section.sectionId];
    
//    if (!cell.pv) {
//        AMProgressView *pvv = [[AMProgressView alloc] initWithFrame:CGRectMake(50, 100, 484, 30)
//                                                  andGradientColors:nil
//                                                   andOutsideBorder:NO
//                                                        andVertical:NO];
//        cell.pv = pvv;
//        [cell.contentView addSubview:cell.pv];
//    }
    
//    if (!cell.pv) {
//        UISlider *pvv = [[UISlider alloc] initWithFrame:CGRectMake(50, 100, 484, 30)];
    
//        NSLog(@"山东龙口副驾驶的路口附近sd卡了房间看老师的减肥了看电视");
//        UIImage *frontImage = [[UIImage imageNamed:@"pdlay-courselistd_07.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//        UIImage *backgroundImage = [[UIImage imageNamed:@"play-courselist_06.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
//        [cell.pv setMinimumTrackImage:frontImage forState:UIControlStateNormal];
//        [cell.pv setMaximumTrackImage:backgroundImage forState:UIControlStateNormal];
//        [cell.pv setThumbImage:[UIImage imageNamed:@"nothing"] forState:UIControlStateNormal];
//        [cell.pv setMaximumValue:1.0];
//        [cell.pv setMinimumValue:0.0];
    
//        cell.pv = pvv;
//        [cell.contentView addSubview:cell.pv];
//    }
    //进度条
    
    
    if (sectionSave) {
        if (sectionSave.downloadState== 0) {
            cell.statusLab.text = @"下载中...";
        }else if (sectionSave.downloadState== 1) {
            cell.statusLab.text = @"已下载";
        }else if (sectionSave.downloadState == 2) {
            cell.statusLab.text = @"暂停";
        }else {
            cell.statusLab.text = @"下载";
        }
        cell.sliderFrontView.frame = CGRectMake(50, 102, 484 * sectionSave.downloadPercent, 33);
//        cell.pv.value = sectionSave.downloadPercent;
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
//        cell.pv.value = 0;
//        cell.pv.value = 0.8;
        cell.sliderFrontView.frame = CGRectMake(50, 102, 484 * 0.4, 33);
        cell.statusLab.text = @"未下载";
        cell.lengthLab.text = @"";
    }
    cell.sectionS = sectionSave;
    cell.timeLab.text = section.sectionLastTime;
    return cell;
}
@end
