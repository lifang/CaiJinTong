//
//  SubmitAnswerInterface.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
#import "IndexPathModel.h"
@protocol SubmitAnswerInterfaceDelegate;
/*
 *提交追问或者回答
 */
@interface SubmitAnswerInterface : BaseInterface<BaseInterfaceDelegate>
@property (nonatomic, weak) id<SubmitAnswerInterfaceDelegate>delegate;
@property (nonatomic, assign) ReaskType reaskType;
@property (nonatomic,strong) IndexPathModel *path;
//resultId:resultId=0 表示回答 resultId大于0 表示追问
//type: 1:表示添加追问  3：表示修改追问 type=2：表示回复或者修改回复
-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andReaskTyep:(ReaskType)reask  andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andResultId:(NSString *)resultId andIndexPath:(IndexPathModel*)path;

@end

@protocol SubmitAnswerInterfaceDelegate <NSObject>
/*
 *@brief 提交追问或者回答回调方法
 */
-(void)getSubmitAnswerInfoDidFinished:(NSMutableArray *)result withReaskType:(ReaskType)reask andIndexPath:(IndexPathModel*)path;
-(void)getSubmitAnswerDidFailed:(NSString *)errorMsg withReaskType:(ReaskType)reask;
@end


