//
//  DRTreeNode.h
//  DRTreeFolderView
//
//  Created by david on 13-12-18.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DRTreeNode : NSObject
@property (assign,nonatomic) int noteId;
@property (strong,nonatomic) NSString *noteContentName;//目录展示对象名称
@property (strong,nonatomic) NSString *noteContentID;//目录展示对象id
@property (assign,nonatomic) int noteLevel;//note级数，第一级为0
@property (assign,nonatomic) BOOL noteIsExtend;//当前note是否是展示下一级节点
@property (strong,nonatomic) NSString *noteRootContentID;//根节点的对象id
@property (strong,nonatomic) NSArray *childnotes;
@end
