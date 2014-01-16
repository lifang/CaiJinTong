//
//  LessonModel+toSection.m
//  CaiJinTongApp
//
//  Created by apple on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonModel+toSection.h"

@implementation LessonModel(toSection)
-(SectionModel *) toSection{
    SectionModel *s = [[SectionModel alloc] init];
    s.sectionId =  self.lessonId;
    s.sectionName =  self.lessonName;
    s.sectionImg =  self.lessonImageURL;
    s.sectionProgress =  self.lessonStudyProgress;
    s.lessonInfo =  self.lessonDetailInfo;
    s.sectionTeacher =  self.lessonTeacherName;
    s.sectionLastTime = self.lessonDuration;
    s.sectionStudy = self.lessonStudyTime;
    s.sectionScore =  self.lessonScore;
    s.isGrade =  self.lessonIsScored;
    s.sectionList = [NSMutableArray arrayWithArray:self.chapterList];
    s.commentList = [NSMutableArray arrayWithArray:self.lessonCommentList];
    
    return s;
}
@end
