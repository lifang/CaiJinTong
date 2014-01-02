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
@interface Section_NoteViewController_iPhone ()

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
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:9];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(255, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+51;
//    return 50;UIScrollView
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Section_NoteCell_iPhone";
    Section_NoteCell_iPhone *cell = (Section_NoteCell_iPhone *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NoteModel *note = (NoteModel *)[self.dataArray objectAtIndex:indexPath.row];
    UIFont *aFont = [UIFont fontWithName:@"Trebuchet MS" size:9];
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(255, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    cell.contentTextView.frame = CGRectMake(7, 18, 261, size.height + 15);
    cell.contentTextView.text = note.noteText;
    cell.timeLab.text = note.noteTime;
    cell.contentTextView.layer.borderWidth = 1.0;
    cell.contentTextView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    cell.contentTextView.font = aFont;
    cell.contentTextView.contentInset = UIEdgeInsetsMake(-4, 0, 0, 0);
//    [cell.contentTextView zoomToRect:CGRectMake(10, 55, 255, size.height + 21) animated:NO];
    [cell.contentTextView setUserInteractionEnabled:NO];
    return cell;
}

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

@end
