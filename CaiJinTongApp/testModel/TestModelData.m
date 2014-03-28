//
//  TestModelData.m
//  CaiJinTongApp
//
//  Created by david on 13-12-19.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "TestModelData.h"
#import "NoteModel.h"
#import "CommentModel.h"
#import "Section_chapterModel.h"

@implementation TestModelData
+(SectionModel *)getSectionInfo {
    SectionModel *section = [[SectionModel alloc]init];
    NSString *questionJSONPath = [NSBundle pathForResource:@"sectionInfo" ofType:@"json" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *questionData = [NSData dataWithContentsOfFile:questionJSONPath];
    id questionJsonData = [NSJSONSerialization JSONObjectWithData:questionData options:NSJSONReadingAllowFragments error:nil];
    if(questionData != nil && [questionJsonData isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:(NSDictionary *)questionJsonData];
        NSDictionary *dictionary = [dic objectForKey:@"ReturnObject"];
        if (dictionary) {
            
            section.sectionId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionId"]];
            section.sectionImg = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionImg"]];
            section.sectionName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionName"]];
            section.sectionProgress = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionProgress"]];
            section.sectionSD = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionSD"]];
            section.sectionHD = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionHD"]];
            section.sectionScore = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionScore"]];
            //                                section.isGrade = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isGrade"]];
            section.isGrade = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"IsComment"]];
            section.lessonInfo = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lessonInfo"]];
            section.sectionTeacher = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionTeacher"]];
            section.sectionDownload = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionDownload"]];
            section.sectionStudy = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionStudy"]];
            section.sectionLastTime = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionLastTime"]];
            
            //笔记列表
            if (![[dictionary objectForKey:@"noteList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"noteList"]!=nil) {
                NSArray *array_note = [dictionary objectForKey:@"noteList"];
                if (array_note.count>0) {
                    array_note = [[array_note reverseObjectEnumerator] allObjects];
                    section.noteList = [[NSMutableArray alloc]init];
                    for (int i=0; i<array_note.count; i++) {
                        NSDictionary *dic_note = [array_note objectAtIndex:i];
                        NoteModel *note = [[NoteModel alloc]init];
                        note.noteId = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteId"]];
                        note.noteTime = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteTime"]];
                        note.noteText = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteText"]];
                        [section.noteList addObject:note];
                    }
                }
            }
            //评论列表
            if (![[dictionary objectForKey:@"commentList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"commentList"]!=nil) {
                NSArray *array_comment = [dictionary objectForKey:@"commentList"];
                if (array_comment.count>0) {
                    section.commentList = [[NSMutableArray alloc]init];
                    for (int i=0; i<array_comment.count; i++) {
                        NSDictionary *dic_comment = [array_comment objectAtIndex:i];
                        CommentModel *comment = [[CommentModel alloc]init];
                        comment.nickName = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"nickName"]];
                        comment.time = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"time"]];
                        comment.content = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"content"]];
                        comment.pageIndex = [[dic_comment objectForKey:@"pageIndex"]intValue];
                        comment.pageCount = [[dic_comment objectForKey:@"pageCount"]intValue];
                        [section.commentList addObject:comment];
                    }
                }
            }
            //章节目录
            if (![[dictionary objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"sectionList"]!=nil) {
                NSArray *array_section = [dictionary objectForKey:@"sectionList"];
                if (array_section.count>0) {
                    section.sectionList = [[NSMutableArray alloc]init];
                    for (int i=0; i<array_section.count; i++) {
                        NSDictionary *dic_section = [array_section objectAtIndex:i];
                        Section_chapterModel *section_chapter = [[Section_chapterModel alloc]init];
                        section_chapter.sectionId = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionId"]];
                        section_chapter.sectionDownload = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionDownload"]];
                        section_chapter.sectionName = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionName"]];
                        section_chapter.sectionLastTime = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionLastTime"]];
                        [section.sectionList addObject:section_chapter];
                    }
                }
                DLog(@"se = %@",section.sectionList);
            }
        }
    }
    return section;
}
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
                question.attachmentFileUrl = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"extUrl"]];
                question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionname"]];
                question.questiontitle = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questiontitle"]];
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
    lesson1.lessonStudyProgress = @"21%";
    [arr addObject:lesson1];
    
    LessonModel *lesson2 = [TestModelData getLesson];
    lesson2.lessonId = @"967";
    lesson2.lessonName = @"证券投资基金－第二章";
    lesson2.lessonStudyProgress = @"27%";
    [arr addObject:lesson2];
    
    LessonModel *lesson3 = [TestModelData getLesson];
    lesson3.lessonId = @"968";
    lesson3.lessonName = @"证券投资基金－第三章";
    lesson3.lessonStudyProgress = @"11%";
    [arr addObject:lesson3];
    
    LessonModel *lesson4 = [TestModelData getLesson];
    lesson4.lessonId = @"969";
    lesson4.lessonName = @"证券投资基金－第四章";
    lesson4.lessonStudyProgress = @"50%";
    [arr addObject:lesson4];
    
    LessonModel *lesson5 = [TestModelData getLesson];
    lesson5.lessonId = @"5454";
    lesson5.lessonName = @"证券投资基金－第五章";
    lesson5.lessonStudyProgress = @"52%";
    [arr addObject:lesson5];
    
    LessonModel *lesson6 = [TestModelData getLesson];
    lesson6.lessonId = @"94569";
    lesson6.lessonName = @"证券投资基金－第六章";
    [arr addObject:lesson6];
    
    LessonModel *lesson7 = [TestModelData getLesson];
    lesson7.lessonId = @"96549";
    lesson7.lessonName = @"证券投资基金－第七章";
    [arr addObject:lesson7];
    
    LessonModel *lesson8 = [TestModelData getLesson];
    lesson8.lessonId = @"98769";
    lesson8.lessonName = @"证券投资基金－第八章";
    [arr addObject:lesson8];
    
    LessonModel *lesson9 = [TestModelData getLesson];
    lesson9.lessonId = @"96349";
    lesson9.lessonName = @"证券投资基金－第九章";
    [arr addObject:lesson9];
    
    LessonModel *lesson14 = [TestModelData getLesson];
    lesson14.lessonId = @"96921";
    lesson14.lessonName = @"证券投资基金－第十章";
    [arr addObject:lesson14];
    
    LessonModel *lesson24 = [TestModelData getLesson];
    lesson24.lessonId = @"969222";
    lesson24.lessonName = @"证券投资基金－第十一章";
    [arr addObject:lesson24];
    
    LessonModel *lesson25 = [TestModelData getLesson];
    lesson25.lessonId = @"969222";
    lesson25.lessonName = @"证券投资基金－第十二章";
    [arr addObject:lesson25];
    
    LessonModel *lesson26 = [TestModelData getLesson];
    lesson26.lessonId = @"969222";
    lesson26.lessonName = @"证券投资基金－第十三章";
    [arr addObject:lesson26];
    
    LessonModel *lesson27 = [TestModelData getLesson];
    lesson27.lessonId = @"969222";
    lesson27.lessonName = @"证券投资基金－第十四章";
    [arr addObject:lesson27];
    
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
    lesson.lessonStudyProgress = @"0%";
    return lesson;
}
+(chapterModel*)getChapter{
    chapterModel *chapter = [[chapterModel alloc] init];
    chapter.chapterId = @"1001";
    chapter.chapterName = @"第一节";
    return chapter;
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
    category.catogoryChildArr = [NSMutableArray arrayWithArray:@[category11,category12]];
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

+(NSMutableArray *)loadJSON{
    NSString *questionJSONPath = [NSBundle pathForResource:@"LHLTestJSON" ofType:@"json" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *questionData = [NSData dataWithContentsOfFile:questionJSONPath];
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:questionData options:NSJSONReadingAllowFragments error:nil];
    
    return [NSMutableArray arrayWithArray:jsonArray];
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
