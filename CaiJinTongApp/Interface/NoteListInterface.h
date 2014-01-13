//
//  NoteListInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 加载笔记列表
 */
@protocol NoteListInterfaceDelegate;
@interface NoteListInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<NoteListInterfaceDelegate>delegate;
@property (assign,nonatomic) int currentPageIndex;
@property (assign,nonatomic) int pageCount;
-(void)downloadNoteListWithUserId:(NSString*)userId withPageIndex:(int)pageIndex;
@end

@protocol NoteListInterfaceDelegate <NSObject>
-(void)getNoteListDataDidFinished:(NSArray*)noteList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)getNoteListDataFailure:(NSString*)errorMsg;
@end
