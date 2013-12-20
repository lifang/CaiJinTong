//
//  TestModelData.m
//  CaiJinTongApp
//
//  Created by david on 13-12-19.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "TestModelData.h"

@implementation TestModelData
+(NSMutableArray *)getQuestion {
    NSMutableArray *chapterQuestionList = [[NSMutableArray alloc]init];
    NSString *questionJSONPath = [NSBundle pathForResource:@"tempQuestion" ofType:@"json" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *questionData = [NSData dataWithContentsOfFile:questionJSONPath];
    id questionJsonData = [NSJSONSerialization JSONObjectWithData:questionData options:NSJSONReadingAllowFragments error:nil];
    if(questionData != nil && [questionJsonData isKindOfClass:[NSDictionary class]]){
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)questionJsonData];
        NSDictionary *dictionary = [dic objectForKey:@"ReturnObject"];
        NSArray *array_chapterQuestionList =[dictionary objectForKey:@"chapterQuestionList"];
        if (array_chapterQuestionList.count>0){
            for (int i= 0; i<array_chapterQuestionList.count; i++) {
                NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
                QuestionModel *question = [[QuestionModel alloc]init];
                question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
                question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionName"]];
                question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
                question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
                question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
                question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
                question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];
                question.isAcceptAnswer = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isAcceptAnswer"]];
                question.questiontitle = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questiontitle"]];
                question.isPraised =[NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isPraised"]];
                
                if (![[question_dic objectForKey:@"answerList"]isKindOfClass:[NSNull class]] && [question_dic objectForKey:@"answerList"]!=nil) {
                    NSArray *array_answer = [question_dic objectForKey:@"answerList"];
                    if (array_answer.count>0) {
                        question.answerList = [[NSMutableArray alloc]init];
                        for (int k=0; k<array_answer.count; k++) {
                            NSDictionary *answer_dic = [array_answer objectAtIndex:k];
                            AnswerModel *answer = [[AnswerModel alloc]init];
                            answer.resultId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"resultId"]];
                            answer.answerTime =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerTime"]];
                            answer.answerId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerId"]];
                            answer.answerNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerNick"]];
                            answer.isPraised = [NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isParise"]];
                            answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
                            answer.IsAnswerAccept =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
                            answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
                            answer.isPraised=[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isPraised"]];
                            
                            //添加追问
                            NSArray *reaskArray = [answer_dic objectForKey:@"addList"];
                            NSMutableArray *reaskModelArr = [NSMutableArray array];
                            for (NSDictionary *reaskDic in reaskArray) {
                                Reaskmodel *reask = [[Reaskmodel alloc] init];
                                reask.reaskID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"ZID"]];
                                reask.reaskContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]];
                                reask.reaskDate = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                                reask.reaskingAnswerID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addMemberID"]];
                                //对追问的回复
                                reask.reAnswerID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AID"]];
                                reask.reAnswerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"Answer"]];
                                reask.reAnswerIsAgree = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AgreeStatus"]];
                                reask.reAnswerIsTeacher = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"IsTeacher"]];
                                reask.reAnswerNickName = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"TeacherName"]];
                                [reaskModelArr addObject:reask];
                            }
                            answer.reaskModelArray = reaskModelArr;
                            
                            [question.answerList addObject:answer];
                        }
                    }
                }
                [chapterQuestionList addObject:question];
            }
        }
    }
    return chapterQuestionList;
}
+(NSArray*)getLessonArr{
    NSMutableArray *arr = [NSMutableArray array];
    LessonModel *lesson1 = [TestModelData getLesson];
    lesson1.lessonId = @"966";
    [arr addObject:lesson1];
    
    LessonModel *lesson2 = [TestModelData getLesson];
    lesson2.lessonId = @"967";
    lesson2.lessonName = @"证券投资基金－第二章";
    [arr addObject:lesson2];
    
    LessonModel *lesson3 = [TestModelData getLesson];
    lesson3.lessonId = @"968";
    lesson3.lessonName = @"证券投资基金－第三章";
    [arr addObject:lesson3];
    
    LessonModel *lesson4 = [TestModelData getLesson];
    lesson4.lessonId = @"969";
    lesson4.lessonName = @"证券投资基金－第四章";
    [arr addObject:lesson4];
    return arr;
}
+(NSArray*)getChapterArr{
    NSMutableArray *arr = [NSMutableArray array];
    return arr;
}
+(NSArray*)getSectionArr{
    NSMutableArray *arr = [NSMutableArray array];
    return arr;
}
+(LessonModel*)getLesson{
    LessonModel *lesson = [[LessonModel alloc] init];
    lesson.lessonId = @"1001";
    lesson.lessonName = @"证券投资基金－第一章";
    lesson.lessonImageURL = @"http://lms.finance365.com/data/temp/course_default.png";
    lesson.lessonStudyProgress = @"21%";
    return lesson;
}
+(chapterModel*)getChapter{
    chapterModel *chapter = [[chapterModel alloc] init];
    chapter.chapterId = @"1001";
    chapter.chapterName = @"第一节";
    return chapter;
}
+(SectionModel*)getSection{
    return nil;
}

+(CategoryModel*)getCategory{
    CategoryModel *category = [[CategoryModel alloc] init];
    category.categoryID = 0;
    category.categoryName = @"证券从业人员资格";
    return category;
}

+(CategoryModel*)getCategoryTree{
    CategoryModel *category = [TestModelData getCategory];
    CategoryModel *category11 = [TestModelData getCategory];
    
    category11.categoryID = @"11";
    category11.categoryName = @"证券市场基础知识";
    CategoryModel *category12 = [TestModelData getCategory];
    category12.categoryID = @"12";
    category12.categoryName = @"证券投资基金";
    category.catogoryChildArr = @[category11,category12];
    return category;
}

//课程
+(SectionModel*)getSectionOld{
    SectionModel *section = [[SectionModel alloc] init];
    section.sectionImg =  @"http://lms.finance365.com/data/temp/course_default.png";
    section.sectionName = @"证券基础知识第一章";
    return section;
}
+(DRTreeNode*)getTreeNodeFromCategoryModel:(CategoryModel*)categoryModel{
    return [TestModelData getTreeNodeFromCategoryModel:categoryModel withLevel:0];
}

+(NSMutableArray*)getTreeNodeArrayFromDictionary:(NSDictionary*)dic{

    return nil;
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr{
    return [TestModelData getTreeNodeArrayFromArray:arr withLevel:0 withRootContentID:nil];
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withLevel:(int)level withRootContentID:(NSString*)rootContentID{
    NSMutableArray *notes = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DRTreeNode *note = [[DRTreeNode alloc] init];
        note.noteContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        note.noteContentName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionName"]];
        note.noteLevel = level;
        if (level <= 0 || [note.noteContentID isEqualToString:@"-1"] || [note.noteContentID isEqualToString:@"-3"]) {
            note.noteRootContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        }else{
            note.noteRootContentID = rootContentID;
        }
        note.childnotes = [TestModelData getTreeNodeArrayFromArray:[dic objectForKey:@"questionNode"] withLevel:level+1 withRootContentID:note.noteRootContentID];
        [notes addObject:note];
    }
    return notes;
}
+(DRTreeNode*)getTreeNodeFromCategoryModel:(CategoryModel*)categoryModel withLevel:(int)level{
    if (categoryModel) {
        DRTreeNode *node = [[DRTreeNode alloc] init];
        node.noteContentID = categoryModel.categoryID;
        node.noteContentName = categoryModel.categoryName;
        if ( categoryModel.catogoryChildArr) {
            NSMutableArray *childArr = [NSMutableArray array];
            for (int index = 0; index < categoryModel.catogoryChildArr.count; index++) {
                [childArr addObject:[TestModelData getTreeNodeFromCategoryModel:[categoryModel.catogoryChildArr objectAtIndex:index] withLevel:level+1]];
            }
            node.childnotes = childArr;
        }
        return node;
    }
    
    return nil;
}

@end
