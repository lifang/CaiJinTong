//
//  StudySummaryModel.h
//  CaiJinTongApp
//
//  Created by david on 14-3-20.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
/** StudySummaryModel
 *
 * 学习的预揽对象
 */
@interface StudySummaryModel : NSObject
///全部课程
@property (assign,nonatomic) int studyAllCourseCount;
///已经学习课程
@property (assign,nonatomic) int studyBeginningCourseCount;
///所有测试
@property (assign,nonatomic) int studyAllTestCount;
///参与的测试
@property (assign,nonatomic) int studyBeginningTestCount;
///所有的问答
@property (assign,nonatomic) int studyAllQuestionCount;
///参与的问答
@property (assign,nonatomic) int studyBeginningQuestionCount;

///所有资料个数
@property (assign,nonatomic) int studyAllLearningMatarilCount;

///所有笔记个数
@property (assign,nonatomic) int studyAllNotesCount;

@end
