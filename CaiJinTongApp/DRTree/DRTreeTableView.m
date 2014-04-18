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
@property (nonatomic,strong) NSIndexPath *selectedPath;
@property (nonatomic,strong) UILabel *tipLabel;
///是否正在进行动画
@property (nonatomic,assign,readonly) BOOL isBeginningAnimation;
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
    
    if (!isPAD) {
        self.originRect = frame;
        self.tableView = [[TreeTableView alloc] initWithFrame:(CGRect){CGRectGetWidth(self.frame),0,DRTReeWidth,frame.size.height}];
        [self.tableView setBackgroundColor:[UIColor colorWithRed:6.0/255.0 green:18.0/255.0 blue:27.0/255.0 alpha:1.0]];
    }else{
        self.tableView = [[TreeTableView alloc] initWithFrame:(CGRect){0,0,frame.size}];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth;
//    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
//    [self.tableView setSectionIndexTrackingBackgroundColor:[UIColor clearColor]];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self addSubview:self.tableView];
    self.isExtendChildNode = YES;
    self.tipLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,frame.size}];
    self.tipLabel.backgroundColor = [UIColor clearColor];
    [self.tipLabel setFont:[UIFont systemFontOfSize:20]];
    self.tipLabel.text = @"暂无分类数据";
    [self.tipLabel setTextColor:[UIColor lightGrayColor]];
    [self addSubview:self.tipLabel];
    if (self.noteArr.count > 0) {
        [self.tipLabel setHidden:YES];
    }else{
        [self.tipLabel setHidden:NO];
    }
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
    self.selectedPath = nil;
    DRTreeNode *note = [self.tableDataArr objectAtIndex:indexPath.row];
    if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:isExtendChildSelectedTreeNode:)]) {
         self.isExtendChildNode = [self.delegate drTreeTableView:self isExtendChildSelectedTreeNode:note];
    }
    if (self.isExtendChildNode) {
        [self selectedNoteAtIndexPath:indexPath withAnimation:NO];
    }
    
    [tableView reloadData];
    DRTreeCell *cell = (DRTreeCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (note.childnotes && [note.childnotes count] > 0) {
        
        if (note.noteIsExtend) {
            [cell setBackgroundColor:[UIColor lightGrayColor]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:didExtendChildTreeNode:)]) {
                [self.delegate drTreeTableView:self didExtendChildTreeNode:note];
            }
        }else{
            [cell setBackgroundColor:[UIColor clearColor]];
            if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:didCloseChildTreeNode:)]) {
                [self.delegate drTreeTableView:self didCloseChildTreeNode:note];
            }
        }
    }else{
        [cell setBackgroundColor:[UIColor lightGrayColor]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(drTreeTableView:didSelectedTreeNode:)]) {
            [self.delegate drTreeTableView:self didSelectedTreeNode:note];
        }
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


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.selectedPath && indexPath.row > self.selectedPath.row) {
        DRTreeNode *node = [self.tableDataArr objectAtIndex:self.selectedPath.row];
        if (indexPath.row <= self.selectedPath.row+node.childnotes.count) {
            CGRect selectRect = [tableView rectForRowAtIndexPath:self.selectedPath];
            CGRect cellRect = cell.frame;
            cell.frame = selectRect;
            [UIView animateWithDuration:0.3 animations:^{
                cell.frame = cellRect;
            } completion:^(BOOL finished) {
                cell.frame = cellRect;
            }];
        }else{
            CGRect cellRect = cell.frame;
            CGRect startRect = (CGRect){cellRect.origin,cellRect.size.width,cellRect.size.height - CGRectGetHeight(cellRect)*node.childnotes.count};
            cell.frame = startRect;
            [UIView animateWithDuration:0.3 animations:^{
                cell.frame = cellRect;
            } completion:^(BOOL finished) {
                cell.frame = cellRect;
            }];
        }
    }
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
//    int noteIndex = [self.tableDataArr indexOfObject:note];
    [self.tableDataArr removeObject:note];
//    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:noteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
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
            self.selectedPath = path;
            [self.tableDataArr insertObjects:selectedNote.childnotes atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(path.row+1, selectedNote.childnotes.count)]];
//            NSMutableArray *insertPath = [NSMutableArray array];
//            for (int row = path.row+1; row < selectedNote.childnotes.count+path.row+1; row++) {
//                [insertPath addObject:[NSIndexPath indexPathForRow:row inSection:0]];
//            }
//            [self.tableView insertRowsAtIndexPaths:insertPath withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
//        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

}
#pragma mark --

-(void)closeAllNoteArr:(DRTreeNode*)childNote{
    if (!childNote) {
        return;
    }
    childNote.noteIsExtend = NO;
    for (DRTreeNode *note in childNote.childnotes) {
        [self closeAllNoteArr:note];
    }
}

/**
 转换node树形结构到tableview Data Arr
 */
-(void)insertNodeDataArr:(NSArray*)nodeArr intoTableDataArr:(NSMutableArray*)tableDataArr{
    for (DRTreeNode *node in nodeArr) {
        [tableDataArr addObject:node];
        if (node.noteIsExtend && node.childnotes.count > 0) {
            [self insertNodeDataArr:node.childnotes intoTableDataArr:tableDataArr];
        }
    }
}


///iphone有效，点击空白区域隐藏tree
-(void)setHiddleTreeTableView:(BOOL)isHiddle withAnimation:(BOOL)animation{
    if (!isPAD) {
        if (self.isBeginningAnimation) {
            return;
        }
        if (isHiddle) {
            if (animation) {
                if (CGRectGetMinX(self.tableView.frame) < CGRectGetWidth(self.frame) || CGRectGetMinX(self.frame) <= CGRectGetMinX(self.originRect)) {
                    [self setUserInteractionEnabled:NO];
                    _isBeginningAnimation = YES;
                    [UIView animateWithDuration:0.5 animations:^{
                        self.tableView.frame = (CGRect){CGRectGetWidth(self.frame)+1,0 ,self.tableView.frame.size};
                    } completion:^(BOOL finished) {
                        self.frame = (CGRect){320,CGRectGetMinY(self.frame),self.frame.size};
                        [self setUserInteractionEnabled:YES];
                        _isBeginningAnimation = NO;
                    }];
                }
            }else{
                if (CGRectGetMinX(self.tableView.frame) < CGRectGetWidth(self.frame) || CGRectGetMinX(self.frame) <= CGRectGetMinX(self.originRect)) {
                    self.tableView.frame = (CGRect){CGRectGetWidth(self.frame)+1,0 ,self.tableView.frame.size};
                    self.frame = (CGRect){320,CGRectGetMinY(self.frame),self.frame.size};
                }
            }

        }else{
            if (animation) {
                if (CGRectGetMinX(self.tableView.frame) >= CGRectGetWidth(self.frame) || CGRectGetMinX(self.frame) >= 320) {
                    self.frame = self.originRect;
                    [self setUserInteractionEnabled:NO];
                    _isBeginningAnimation = YES;
                    [UIView animateWithDuration:0.5 animations:^{
                         self.tableView.frame = (CGRect){CGRectGetWidth(self.frame) - DRTReeWidth,0 ,self.tableView.frame.size};
                    } completion:^(BOOL finished) {
                        [self setUserInteractionEnabled:YES];
                        _isBeginningAnimation = NO;
                    }];
                }
            }else{
                if (CGRectGetMinX(self.tableView.frame) >= CGRectGetWidth(self.frame) || CGRectGetMinX(self.frame) >= 320) {
                    self.tableView.frame = (CGRect){CGRectGetWidth(self.frame) - DRTReeWidth,0 ,self.tableView.frame.size};
                    self.frame = self.originRect;
                }
            }

        }
    }
}
#pragma mark property

-(NSMutableArray *)tableDataArr{
    if (!_tableDataArr) {
        _tableDataArr = [NSMutableArray array];
    }
    return _tableDataArr;
}
-(void)setNoteArr:(NSMutableArray *)noteArr{
    _noteArr = noteArr;
    if (noteArr.count > 0) {
        [self.tipLabel setHidden:YES];
    }else{
        [self.tipLabel setHidden:NO];
    }
    if (noteArr) {
         self.tableDataArr = [NSMutableArray array];
        [self insertNodeDataArr:noteArr intoTableDataArr:self.tableDataArr];
    }else{
        [self.tableDataArr removeAllObjects];
    }
    [self.tableView reloadData];
}
#pragma mark --


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (CGRectGetMinX(self.tableView.frame) >= CGRectGetWidth(self.frame)) {
        [self setHiddleTreeTableView:NO withAnimation:YES];
        if (self.hiddleBlock) {
            self.hiddleBlock(NO);
        }
    }else{
        [self setHiddleTreeTableView:YES withAnimation:YES];
        if (self.hiddleBlock) {
            self.hiddleBlock(YES);
        }
    }
    
}
@end
