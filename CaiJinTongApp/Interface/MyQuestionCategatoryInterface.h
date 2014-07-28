//
//  MyQuestionCategatoryInterface.h
//  CaiJinTongApp
//
//  Created by david on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
/*
 加载我的问答分类信息
 */
@protocol MyQuestionCategatoryInterfaceDelegate;
@interface MyQuestionCategatoryInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<MyQuestionCategatoryInterfaceDelegate>delegate;
-(void)downloadMyQuestionCategoryDataWithUserId:(NSString*)userId;
@end
@protocol MyQuestionCategatoryInterfaceDelegate <NSObject>
-(void)getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:(NSArray*)myAnswerCategoryNotes withMyQuestionCategorynodes:(NSArray*)myQuestionCategoryNotes;

-(void)getMyQuestionCategoryDataFailure:(NSString*)errorMsg;
@end
