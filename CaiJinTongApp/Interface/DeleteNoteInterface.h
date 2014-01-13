//
//  DeleteNoteInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 删除笔记
 */
@protocol DeleteNoteInterfaceDelegate;
@interface DeleteNoteInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<DeleteNoteInterfaceDelegate>delegate;
@property (strong,nonatomic) NSIndexPath *path;
//@property (assign,nonatomic) int currentPageIndex;
//@property (assign,nonatomic) int allDataCount;
-(void)deleteNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId;
@end

@protocol DeleteNoteInterfaceDelegate <NSObject>
-(void)deleteNoteDidFinished:(NSString*)success;

-(void)deleteNoteFailure:(NSString*)errorMsg;
@end
