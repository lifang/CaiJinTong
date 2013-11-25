//
//  Section_NoteViewController.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_NoteViewController.h"
#import "Section_NoteCell.h"
#import "NoteModel.h"
@interface Section_NoteViewController ()

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
	// Do any additional setup after loading the view.
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
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    return size.height+35+20;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    CGSize size = [note.noteText sizeWithFont:aFont constrainedToSize:CGSizeMake(500, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    
    [cell.contentTextView setUserInteractionEnabled:NO];
    cell.contentTextView.frame = CGRectMake(30, 35, 500, size.height+20);
    cell.contentTextView.text = note.noteText;
    cell.timeLab.text = note.noteTime;
    cell.contentTextView.layer.borderWidth = 2.0;
    cell.contentTextView.layer.borderColor = [[UIColor colorWithRed:244.0/255.0 green:243.0/255.0 blue:244.0/255.0 alpha:1.0] CGColor];
    cell.contentTextView.font = aFont;
    cell.contentTextView.contentInset = UIEdgeInsetsMake(0, 5.0f, 0, 5.0f);
    
//    cell.sectionNameLab.text = note.noteId;
    
    return cell;
}
@end
