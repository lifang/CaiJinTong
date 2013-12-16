//
//  AnswerModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 追问对象
 */
@interface Reaskmodel : NSObject
//追问
@property (nonatomic, strong) NSString *reaskID;//追问id
@property (nonatomic, strong) NSString *reaskContent;//追问内容
@property (nonatomic, strong) NSString *reaskDate;//追问日期
@property (nonatomic, strong) NSString *reaskingAnswerID;//被追问者的id
@property (nonatomic, strong) NSString *reaskNickName;//追问着昵称
//对追问的回复
@property (nonatomic, strong) NSString *reAnswerID;//回复者id
@property (nonatomic, strong) NSString *reAnswerContent;//回复者内容
@property (nonatomic, strong) NSString *reAnswerNickName;//回复者昵称
@property (nonatomic, strong) NSString *reAnswerIsAgree;//是否同意这个回答
@property (nonatomic, strong) NSString *reAnswerIsTeacher;//回复者是否是老师
@end



@interface AnswerModel : NSObject

@property (nonatomic, strong) NSString *answerId;//回答者id
@property (nonatomic, strong) NSString *answerTime;//回答时间
@property (nonatomic, strong) NSString *answerNick;//回答者昵称
@property (nonatomic, strong) NSString *answerPraiseCount;//回答被赞个数

@property (nonatomic, strong) NSString *IsAnswerAccept;//是否被采纳为正确答案
@property (nonatomic, strong) NSString *answerContent;//回答内容
@property (nonatomic, strong) NSString *resultId;//答案id

@property (strong, nonatomic) NSString *isPraised;//是否已经点赞
@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//

@property (assign,nonatomic) BOOL isEditing;//是否可编辑

@property (nonatomic, strong) NSMutableArray *reaskModelArray;   //追问对象列表
@end
