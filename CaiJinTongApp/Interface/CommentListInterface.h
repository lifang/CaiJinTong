//
//  CommentListInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "SectionModel.h"

@protocol CommentListInterfaceDelegate;

@interface CommentListInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id<CommentListInterfaceDelegate>delegate;

-(void)getGradeInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andPageIndex:(int)pageIndex;
@end

@protocol CommentListInterfaceDelegate <NSObject>

-(void)getCommentListInfoDidFinished:(SectionModel *)result;
-(void)getCommentListInfoDidFailed:(NSString *)errorMsg;

@end