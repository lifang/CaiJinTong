//
//  DRTreeTableView.m
//  DRTreeFolderView
//
//  Created by david on 13-12-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DRTreeTableView.h"

@interface TreeTableView : UITableView

@end
@implementation TreeTableView

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddleSearchKeyboardNotification" object:nil];
}

@end


@interface DRTreeTableView()
@property (nonatomic,strong) TreeTableView *tableView;
@property (nonatomic,strong) NSMutableArray *tableDataArr;//用于显示的note数据
@end
@implementation DRTreeTableView

-(DRTreeTableView*)initWithFrame:(CGRect)frame withTreeNodeArr:(NSArray*)treeNodeArr{
    self = [super initWithFrame:frame];
    if (self) {
        self.noteArr = [NSMutableArray arrayWithArray:treeNodeArr];
        [self initTreeViewWithFrame:frame];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initTreeViewWithFrame:frame];
    }
    return self;
}

-(void)initTreeViewWithFrame:(CGRect)frame{
    self.tableView = [[TreeTableView alloc] initWithFrame:(CGRect){0,0,frame.size}];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
//    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
//    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self addSubview:self.tableView];
    self.isExtendChildNode = YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DRTreeNode *note = [self.tableDataArr objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:isExtendChildSelectedTreeNode:)]) {
         self.isExtendChildNode = [self.delegate drTreeTableView:self isExtendChildSelectedTreeNode:note];
    }
    if (self.isExtendChildNode) {
        [self selectedNoteAtIndexPath:indexPath withAnimation:YES];
    }
    if (!note.noteIsExtend && [note.childnotes count] > 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:didSelectedTreeNode:)]) {
        [self.delegate drTreeTableView:self didSelectedTreeNode:note];
    }
}
#pragma mark --

#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DRTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[DRTreeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    DRTreeNode *note = [self.tableDataArr objectAtIndex:indexPath.row];
    cell.note = note;
    [cell setNeedsDisplay];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableDataArr.count;
}

#pragma mark --

#pragma mark action

-(void)deleteNote:(DRTreeNode*)note withAnimation:(BOOL)isAnimation{
    if (note.noteIsExtend) {
        for (int index = 0; index < note.childnotes.count; index++) {
            [self deleteNote:[note.childnotes objectAtIndex:index] withAnimation:isAnimation];
        }
    }
    note.noteIsExtend = NO;
    int noteIndex = [self.tableDataArr indexOfObject:note];
    [self.tableDataArr removeObject:note];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:noteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)selectedNoteAtIndexPath:(NSIndexPath*)path withAnimation:(BOOL)isAnimation{
   
    DRTreeNode *selectedNote = [self.tableDataArr objectAtIndex:path.row];
    if (selectedNote.childnotes && selectedNote.childnotes.count > 0) {
        if (selectedNote.noteIsExtend) {
            selectedNote.noteIsExtend = NO;
            for (DRTreeNode *note in selectedNote.childnotes) {
                 [self deleteNote:note withAnimation:isAnimation];
            }
        }else{
            selectedNote.noteIsExtend = YES;
            [self.tableDataArr insertObjects:selectedNote.childnotes atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(path.row+1, selectedNote.childnotes.count)]];
            NSMutableArray *insertPath = [NSMutableArray array];
            for (int row = path.row+1; row < selectedNote.childnotes.count+path.row+1; row++) {
                [insertPath addObject:[NSIndexPath indexPathForRow:row inSection:0]];
            }
            [self.tableView insertRowsAtIndexPaths:insertPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}
#pragma mark --
#pragma mark property
-(NSMutableArray *)tableDataArr{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}
-(void)setNoteArr:(NSMutableArray *)noteArr{
    _noteArr = noteArr;
    if (noteArr) {
        self.tableDataArr = noteArr;
    }else{
        [self.tableDataArr removeAllObjects];
    }
    [self.tableView reloadData];
}
#pragma mark --
@end
