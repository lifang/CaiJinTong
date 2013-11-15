//
//  QuestionModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnswerModel.h"
@interface QuestionModel : NSObject

@property (nonatomic, strong) NSString *questionId;//问题id
@property (nonatomic, strong) NSString *questionName;//问题名称
@property (nonatomic, strong) NSString *askerId;//提问者id
@property (nonatomic, strong) NSString *askImg;//提问者头像

@property (nonatomic, strong) NSString *askerNick;//提问者昵称
@property (nonatomic, strong) NSString *askTime;//提问时间
@property (nonatomic, strong) NSString *praiseCount;//赞个数
@property (assign,nonatomic) BOOL isPraised;//是否已经点赞
@property (nonatomic, strong) NSString *isAcceptAnswer;//是否采纳了正确答案
@property (nonatomic, strong) NSMutableArray *answerList;//回答列表

@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//

@end
