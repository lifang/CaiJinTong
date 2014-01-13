//
//  SearchNoteInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"

/*
 搜索笔记列表
 */
@protocol SearchNoteInterfaceDelegate;
@interface SearchNoteInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<SearchNoteInterfaceDelegate>delegate;
@property (assign,nonatomic) int currentPageIndex;
@property (assign,nonatomic) int pageCount;
-(void)searchNoteListWithUserId:(NSString*)userId withSearchContent:(NSString*)searchContent withPageIndex:(int)pageIndex;
@end

@protocol SearchNoteInterfaceDelegate <NSObject>
-(void)searchNoteListDataDidFinished:(NSArray*)noteList withCurrentPageIndex:(int)pageIndex withTotalCount:(int)allDataCount;

-(void)searchNoteListDataFailure:(NSString*)errorMsg;
@end
