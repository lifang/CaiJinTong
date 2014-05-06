//
//  Section_ChapterViewController_iPhone_Embed.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_ChapterViewController_iPhone_Embed.h"
#import "Section_ChapterCell_iPhone.h"
#import "SectionModel.h"
#import "Section.h"

#define CAPTER_CELL_WIDTH 277
@interface Section_ChapterViewController_iPhone_Embed ()
@property (nonatomic,strong) UILabel *tipLabel;
@end
@implementation Section_ChapterViewController_iPhone_Embed

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
    [self.tableViewList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];

    [self.tableViewList registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"header"];
    
}

///从数据库中加载数据
-(void)reloadDataFromDataBase{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak Section_ChapterViewController_iPhone_Embed *weakSelf = self;
    UserModel *user = [CaiJinTongManager shared].user;
    
    [DRFMDBDatabaseTool selectLessonTreeDatasWithUserId:user.userId withLessonId:self.lessonId withFinished:^(LessonModel *lesson, NSString *errorMsg) {
        Section_ChapterViewController_iPhone_Embed *tempSelf =weakSelf;
        if (tempSelf) {
            if (lesson) {
                tempSelf.dataArray = lesson.chapterList;
            }else{
                tempSelf.dataArray = [CaiJinTongManager shared].lesson.chapterList;
            }
            
            [tempSelf.tableViewList reloadData];
            [MBProgressHUD hideHUDForView:tempSelf.view animated:YES];
        }
    }];
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
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [tableView addSubview:self.tipLabel];
    }else {
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

//-(UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UITableViewHeaderFooterView *header = [[UITableViewHeaderFooterView alloc] init];
//    chapterModel *chapter = [self.dataArray objectAtIndex:section];
//    UILabel *label = [[UILabel alloc] initWithFrame:(CGRect){0,1,276,15}];
//    label.font = [UIFont systemFontOfSize:12];
//    label.text = chapter.chapterName;
//    label.textColor = [UIColor darkGrayColor];
//    label.backgroundColor = [ UIColor lightGrayColor];
//    [header.contentView addSubview:label];
//    return header;
//}

-(UITableViewHeaderFooterView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"header"];
    chapterModel *chapter = [self.dataArray objectAtIndex:section];
    UILabel *label = header.textLabel;
    label.font = [UIFont systemFontOfSize:12];
    label.text = chapter.chapterName;
    label.textColor = [UIColor darkGrayColor];
    label.backgroundColor = [ UIColor lightGrayColor];
    return header;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_ChapterCell_iPhone_Embed";
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

@end
