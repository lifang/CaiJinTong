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
@property (nonatomic, strong) NSString *attachmentFileUrl;//附件url

@property (nonatomic, strong) NSString *askerNick;//提问者昵称
@property (nonatomic, strong) NSString *askTime;//提问时间
@property (nonatomic, strong) NSString *praiseCount;//赞个数
@property (strong, nonatomic) NSString *isPraised;//是否已经点赞
@property (nonatomic, strong) NSString *isAcceptAnswer;//是否采纳了正确答案
@property (nonatomic, strong) NSMutableArray *answerList;//回答列表

@property (nonatomic, strong) NSString *questiontitle;
///存放RichContentObj，把所有html和纯文本，图片转化
@property (nonatomic,strong) NSArray *questionRichContentArray;
///是否是展开状态
@property (nonatomic, assign) BOOL questionIsExtend;//问题id
///回答个数
@property (nonatomic, strong) NSString *questionAnswerCount;
@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//

@property (assign,nonatomic) BOOL isEditing;//是否可编辑

//@property (assign,nonatomic) BOOL isExtend;//是否扩展
@end
