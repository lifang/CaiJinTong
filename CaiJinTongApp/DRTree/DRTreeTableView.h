//
//  DRTreeTableView.h
//  DRTreeFolderView
//
//  Created by david on 13-12-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DRTreeCell.h"
#import "DRTreeNode.h"
@protocol DRTreeTableViewDelegate;
@interface DRTreeTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL isExtendChildNode;//默认为YES，扩展子类
@property (nonatomic,strong)  NSMutableArray *noteArr;
@property (weak,nonatomic) id<DRTreeTableViewDelegate> delegate;
-(DRTreeTableView*)initWithFrame:(CGRect)frame withTreeNodeArr:(NSArray*)treeNodeArr;
@end

@protocol DRTreeTableViewDelegate <NSObject>

-(void)drTreeTableView:(DRTreeTableView*)treeView didSelectedTreeNode:(DRTreeNode*)selectedNote;

-(BOOL)drTreeTableView:(DRTreeTableView*)treeView isExtendChildSelectedTreeNode:(DRTreeNode*)selectedNote;

-(void)drTreeTableView:(DRTreeTableView*)treeView didExtendChildTreeNode:(DRTreeNode*)extendNote;

-(void)drTreeTableView:(DRTreeTableView*)treeView didCloseChildTreeNode:(DRTreeNode*)extendNote;
@end