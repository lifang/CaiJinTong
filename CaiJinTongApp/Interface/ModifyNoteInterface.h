//
//  ModifyNoteInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 修改笔记
 */
@protocol ModifyNoteInterfaceDelegate;
@interface ModifyNoteInterface : BaseInterface<BaseInterfaceDelegate>
@property (strong,nonatomic) NSIndexPath *path;
@property (strong,nonatomic) NSString *modifyContent;
@property (nonatomic, weak) id<ModifyNoteInterfaceDelegate>delegate;
//@property (assign,nonatomic) int currentPageIndex;
//@property (assign,nonatomic) int allDataCount;
-(void)modifyNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId withNoteContent:(NSString*)noteContent;
@end

@protocol ModifyNoteInterfaceDelegate <NSObject>
-(void)modifyNoteDidFinished:(NSString*)success;

-(void)modifyNoteFailure:(NSString*)errorMsg;
@end
