//
//  Section_NoteViewController_iPhone.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-29.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_NoteViewController_iPhone.h"
#import "Section_NoteCell_iPhone.h"
#import "NoteModel.h"
#define NOTE_CELL_WIDTH 261
@interface Section_NoteViewController_iPhone ()
@property (nonatomic,strong) UILabel *tipLabel;
@property (nonatomic,assign) CGPoint lastContentOffset;
@end

@implementation Section_NoteViewController_iPhone

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
    self.tableViewList.tag = LessonViewTagType_noteTableViewTag;
    self.tableViewList.delegate = self;
}
- (void)viewDidCurrentView
{
    DLog(@"加载为当前视图 = %@",self.title);
    [self.tableViewList reloadData];
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
        }
    }else{//向上
        if (parentTableView && parentTableView.contentOffset.y <= 0) {
            [scrollView setScrollEnabled:NO];
            [parentTableView setContentOffset:(CGPoint){0,parentTableView.contentSize.height - parentTableView.frame.size.height} animated:YES];
        }
    }
    
}
#pragma mark --

#pragma  mark-- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *note = (NoteModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:9];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(255, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+51;
//    return 50;UIScrollView
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataArray || self.dataArray.count <= 0) {
        [self.tipLabel removeFromSuperview];
        [tableView addSubview:self.tipLabel];
    }else{
        [self.tipLabel removeFromSuperview];
    }
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_NoteCell_iPhone";
    Section_NoteCell_iPhone *cell = (Section_NoteCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NoteModel *note = (NoteModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:9];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(255, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    [cell.contentTextView setUserInteractionEnabled:NO];
    cell.contentTextView.frame = CGRectMake(7, 18, 261, size.height + 15);
    cell.contentTextView.layer.borderWidth = 1.0;
    cell.contentTextView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    cell.contentTextView.font = aFont;
    cell.contentTextView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
    [cell.contentTextView setScrollEnabled:NO];
    [cell.contentTextView setEditable:NO];
    cell.contentTextView.text = note.noteText;
    
    cell.contentLab.text = [NSString stringWithFormat:@"%@ > %@",note.noteChapterName,note.noteSectionName]; //笔记标题
    
    cell.timeLab.text = note.noteTime;
    
    cell.path = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark Section_NoteCellDelegate
-(void)section_NoteCell:(Section_NoteCell_iPhone *)cell didSelectedAtIndexPath:(NSIndexPath *)path{
    NoteModel *note = [self.dataArray objectAtIndex:path.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(section_NoteViewController:didClickedNoteCellWithObj:)]) {
        [self.delegate section_NoteViewController:self didClickedNoteCellWithObj:note];
    }
}

#pragma mark property
-(void)setDataArray:(NSMutableArray *)dataArray{
    NSMutableArray *data = [NSMutableArray array];
    for (chapterModel *chapter in dataArray) {
        for (NoteModel *note in chapter.chapterNoteList) {
            [data addObject:note];
        }
    }
    data = [self bubbleSort:data];
    _dataArray = data;
}

-(NSMutableArray *)bubbleSort:(NSMutableArray *)data{
    //对NoteModels按时间倒序排列
    for(NSUInteger i = 0;i < data.count;i ++){
        for(NSUInteger j = data.count - 1;j > i;j--){
            NoteModel *model1 = data[j];
            NoteModel *model2 = data[j - 1];
            NSDateFormatter *formater = [[NSDateFormatter alloc] init];
            [formater setDateFormat:@"yyyy-MM-dd"];
            NSDate *date1 = [formater dateFromString:model1.noteTime];
            NSDate *date2 = [formater dateFromString:model2.noteTime];
            if([date1 compare:date2] == NSOrderedDescending){ //如果date1比date2更新
                [data replaceObjectAtIndex:j - 1 withObject:model1];
                [data replaceObjectAtIndex:j withObject:model2];
            }
        }
    }
    return data;
}

-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,NOTE_CELL_WIDTH,self.tableViewList.frame.size.height}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:25];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}

@end
