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
#define DRTReeWidth 250
@protocol DRTreeTableViewDelegate;
@interface DRTreeTableView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,assign) BOOL isExtendChildNode;//默认为YES，扩展子类
@property (nonatomic,strong)  NSMutableArray *noteArr;
///初始化指定的大小
@property (nonatomic,assign) CGRect originRect;

@property (nonatomic,strong) void (^hiddleBlock)(BOOL isHiddle);
@property (weak,nonatomic) id<DRTreeTableViewDelegate> delegate;
///iphone有效，点击空白区域隐藏tree
-(void)setHiddleTreeTableView:(BOOL)isHiddle withAnimation:(BOOL)animation;

-(DRTreeTableView*)initWithFrame:(CGRect)frame withTreeNodeArr:(NSArray*)treeNodeArr;
@end

@protocol DRTreeTableViewDelegate <NSObject>

-(void)drTreeTableView:(DRTreeTableView*)treeView didSelectedTreeNode:(DRTreeNode*)selectedNote;

-(BOOL)drTreeTableView:(DRTreeTableView*)treeView isExtendChildSelectedTreeNode:(DRTreeNode*)selectedNote;

-(void)drTreeTableView:(DRTreeTableView*)treeView didExtendChildTreeNode:(DRTreeNode*)extendNote;

-(void)drTreeTableView:(DRTreeTableView*)treeView didCloseChildTreeNode:(DRTreeNode*)extendNote;
@end