//
//  CommentListInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "CommentModel.h"

@protocol CommentListInterfaceDelegate;

@interface CommentListInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<CommentListInterfaceDelegate>delegate;

-(void)getCommentListWithUserId:(NSString*)userId sectionId:(NSString *)sectionId pageIndex:(int)pageIndex;
@end

@protocol CommentListInterfaceDelegate <NSObject>

-(void)getCommentListInfoDidFinished:(NSArray *)result;
-(void)getCommentListInfoDidFailed:(NSString *)errorMsg;

@end