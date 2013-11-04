//
//  AnswerModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnswerModel : NSObject

@property (nonatomic, strong) NSString *answerId;//回答者id
@property (nonatomic, strong) NSString *answerTime;//回答时间
@property (nonatomic, strong) NSString *answerNick;//回答者昵称
@property (nonatomic, strong) NSString *answerPraiseCount;//回答被赞个数

@property (nonatomic, strong) NSString *IsAnswerAccept;//是否被采纳为正确答案
@property (nonatomic, strong) NSString *answerContent;//回答内容
@property (nonatomic, strong) NSString *resultId;//答案id

@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//

@end