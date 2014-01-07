//
//  Section_NoteViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_NoteViewController.h"
#define NOTE_CELL_WIDTH 650
@interface Section_NoteViewController ()
@property (nonatomic,strong) UILabel *tipLabel;
@end

@implementation Section_NoteViewController

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
    self.tableViewList.separatorStyle = NO;
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
#pragma  mark-- UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteModel *note = (NoteModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(NOTE_CELL_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+50+20;
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
    static NSString *CellIdentifier = @"Section_NoteCell";
    Section_NoteCell *cell = (Section_NoteCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Section_NoteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NoteModel *note = (NoteModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:18];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(NOTE_CELL_WIDTH, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    [cell.contentTextView setUserInteractionEnabled:NO];
    cell.contentTextView.frame = CGRectMake(30, 50, NOTE_CELL_WIDTH, size.height+20);
    cell.contentTextView.layer.borderWidth = 2.0;
    cell.contentTextView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    cell.contentTextView.font = aFont;
    cell.contentTextView.contentInset = UIEdgeInsetsMake(0, 5.0f, 0, 5.0f);
    [cell.contentTextView setScrollEnabled:NO];
    [cell.contentTextView setEditable:NO];
    cell.contentTextView.text = note.noteText;
    
    cell.sectionNameLab.text = @"财金基础知识第一章 > 第一节 > 财金基础知识第一章视频";
    
    cell.timeLab.text = note.noteTime;
    
    cell.path = indexPath;
    cell.delegate = self;
    return cell;
}


#pragma mark Section_NoteCellDelegate
-(void)section_NoteCell:(Section_NoteCell *)cell didSelectedAtIndexPath:(NSIndexPath *)path{
    NoteModel *note = [self.dataArray objectAtIndex:path.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(section_NoteViewController:didClickedNoteCellWithObj:)]) {
        [self.delegate section_NoteViewController:self didClickedNoteCellWithObj:note];
    }
}
#pragma mark --
#pragma mark property

-(void)setDataArray:(NSMutableArray *)dataArray{
    NSMutableArray *data = [NSMutableArray array];
    for (chapterModel *chapter in dataArray) {
        for (NoteModel *note in chapter.chapterNoteList) {
            [data addObject:note];
        }
    }
    _dataArray = data;
}
-(UILabel *)tipLabel{
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,NOTE_CELL_WIDTH,self.tableViewList.frame.size.height}];
        _tipLabel.textAlignment = NSTextAlignmentCenter;
        _tipLabel.textColor = [UIColor grayColor];
        _tipLabel.font = [UIFont systemFontOfSize:30];
        [_tipLabel setText:@"没有数据"];
    }
    return _tipLabel;
}
@end
