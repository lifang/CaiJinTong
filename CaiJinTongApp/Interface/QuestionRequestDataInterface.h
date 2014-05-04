//
//  QuestionRequestDataInterface.h
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** QuestionRequestDataInterface
 *
 * 问答界面相关功能接口
 */
@interface QuestionRequestDataInterface : NSObject


/**
 * @brief 采纳回答
 * @param  userId
 * @param  questionId：问题id
 * @param  answerID：答案回答者ID
 * @param  correctAnswerID：答案的ID
 *
 */
+(void)acceptAnswerWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andCorrectAnswerID:(NSString*)correctAnswerID withSuccess:(void(^)(NSString *msg))success withError:(void (^)(NSError *error))failure;

/**
 * @brief 分页加载所有问答
 *
 * @param  userId
 *@param  categoryId 问题分类id
 @param  lastQuestionID 最后一个问题id
 * @return questionModelArray 存放QuestionModel和AnswerModel
 */
+(void)downloadALLQuestionListWithUserId:(NSString *)userId andQuestionCategoryId:(NSString *)categoryId andLastQuestionID:(NSString*)lastQuestionID withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure;

/**
 * @brief 搜索问答列表
 *
 * @param  userId
 * @param  text 搜索关键词
   @param  lastQuestionId 如果lastQuestionId!= nil 分页加载，否则加载第一页
 * @return questionModelArray 存放QuestionModel和AnswerModel
 */
+(void)searchQuestionListWithUserId:(NSString *)userId andText:(NSString *)text withLastQuestionId:(NSString*)lastQuestionId withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure;



/**
 * @brief 加载当前用户的问答
 *
 * @param  userId
 * @param  isMyselfQuestion 类型 isMyselfQuestion=0 表示我提的问题 ,isMyselfQuestion=1 我回答过的问题
   @param  lastQuestionID 最后一个问题id
   @param  categoryId  问题分类 categoryId=0为默认加载
 * @return questionModelArray 存放QuestionModel和AnswerModel
 */
+(void)downloadUserQuestionListWithUserId:(NSString *)userId andIsMyselfQuestion:(NSString *)isMyselfQuestion andLastQuestionID:(NSString*)lastQuestionID withCategoryId:(NSString*)categoryId withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure;


//resultId:resultId=0 表示回答 resultId大于0 表示追问
//type: 1:表示添加追问  3：表示修改追问 type=2：表示回复或者修改回复

/**
 * @brief 提交回答，回复，修改回复，追问，修改追问
 *
 * @param  userId
 * @param  reask 回答类型
   @param  answerContent 回答内容
   @param  questionModel 回答对应问题QuestionModel
   @param  answerID 对应被回答的回答对象id：如一个回答下面对应好多回复和追问
 * @return answerModelArray 存放AnswerModel
 */
+(void)submitAnswerWithUserId:(NSString *)userId andReaskTyep:(ReaskType)reaskType  andAnswerContent:(NSString *)answerContent andQuestionModel:(QuestionModel*)questionModel andAnswerID:(NSString*)answerID withSuccess:(void(^)(NSArray *answerModelArray))success withError:(void (^)(NSError *error))failure;


/**
 * @brief 点赞
 *
 * @param  userId
 * @param  questionId 对应问题的id
   @param  answerId 点赞回答的id
 * @return
 */
+(void)pariseAnswerWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerId:(NSString*)answerId withSuccess:(void(^)(NSString *msg))success withError:(void (^)(NSError *error))failure;


/**
 * @brief 获取用户问答的分类
 *
 * @param  userId
 *
 * @return answerModelArray 存放DRTreeNode对象
 */
+(void)downloadUserQuestionCategoryWithUserId:(NSString*)userId withSuccess:(void(^)(NSArray *userQuestionCategoryArray))success withError:(void (^)(NSError *error))failure;

@end
