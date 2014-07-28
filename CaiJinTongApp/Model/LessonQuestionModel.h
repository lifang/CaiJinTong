//
//  LessonQuestionModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonQuestionModel : NSObject

@property (nonatomic, strong) NSString *lessonQuestionId;
@property (nonatomic, strong) NSString *lessonQuestionName;
@property (nonatomic, strong) NSMutableArray *chapterQuestionList;

@end
