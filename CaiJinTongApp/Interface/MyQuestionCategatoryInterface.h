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
@property (assign,nonatomic) QuestionAndAnswerScope questionScope;
-(void)downloadMyQuestionCategoryDataWithUserId:(NSString*)userId withQuestionType:(QuestionAndAnswerScope)scope;
@end
@protocol MyQuestionCategatoryInterfaceDelegate <NSObject>
-(void)getMyQuestionCategoryDataDidFinished:(NSArray*)categoryNotes withQuestionType:(QuestionAndAnswerScope)scope;

-(void)getMyQuestionCategoryDataFailure:(NSString*)errorMsg;
@end
