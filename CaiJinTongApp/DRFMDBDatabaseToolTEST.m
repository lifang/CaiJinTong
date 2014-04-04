//
//  DRFMDBDatabaseToolTEST.m
//  CaiJinTongApp
//
//  Created by david on 14-4-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRFMDBDatabaseToolTEST.h"
#import "DRFMDBDatabaseTool.h"
@implementation DRFMDBDatabaseToolTEST
///测试插入课程分类信息
+(void)insertLessonCatogroyTest{
    NSMutableArray *treeNoteArray = [NSMutableArray array];
    DRTreeNode *note10 = [[DRTreeNode alloc] init];
    note10.noteContentID = @"1000";
    note10.noteContentName = @"1000";
    note10.noteIsExtend = YES;
    note10.noteIsSelected = NO;
    note10.noteLevel = 0;
    note10.noteRootContentID = @"1000";
    
    DRTreeNode *note11 = [[DRTreeNode alloc] init];
    note11.noteContentID = @"1001";
    note11.noteContentName = @"1001";
    note11.noteIsExtend = NO;
    note11.noteIsSelected = NO;
    note11.noteLevel = 0;
    note11.noteRootContentID = @"1001";
    
    DRTreeNode *note21 = [[DRTreeNode alloc] init];
    note21.noteContentID = @"2001";
    note21.noteContentName = @"2001";
    note21.noteIsExtend = NO;
    note21.noteIsSelected = NO;
    note21.noteLevel = 1;
    note21.noteRootContentID = @"1000";
    note10.childnotes = @[note21];
    
    [treeNoteArray addObject:note10];
    [treeNoteArray addObject:note11];
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    NSLog(@"%@",tool.databasePath);
//    [DRFMDBDatabaseTool insertLessonCategoryListWithUserId:@"123" withLessonCategoryArray:treeNoteArray withFinished:^(BOOL flag) {
//        NSLog(@"%@",flag?@"yes":@"no");
//    }];
    
    [DRFMDBDatabaseTool selectLessonCategoryListWithUserId:@"123" withFinished:^(NSArray *treeNoteArray, NSString *errorMsg) {
        NSLog(@"%@",treeNoteArray);
        NSLog(@"%@",errorMsg);
    }];
    
//    [DRFMDBDatabaseTool deleteLessonCategoryListWithUserId:@"123" withFinished:^(BOOL flag) {
//        
//    }];
}

///测试插入课程信息
+(void)insertLessonTest{
    NSMutableArray *lessonArray = [NSMutableArray array];
    LessonModel *lesson = [[LessonModel alloc] init];
    lesson.lessonId = @"1";
    lesson.lessonDetailInfo = @"nihao";
    lesson.lessonDuration = @"20";
    lesson.lessonImageURL = @"www.baidu.com";
    lesson.lessonScore = @"20";
    lesson.lessonStudyTime = @"23";
    lesson.lessonTeacherName = @"dd";
    [lessonArray addObject:lesson];
    [DRFMDBDatabaseTool insertLessonObjListWithUserId:@"235" withLessonObjArray:lessonArray withFinished:^(BOOL flag) {
        NSLog(@"insert lesson :%@",flag?@"yes":@"no");
    }];
    
//    [DRFMDBDatabaseTool updateLessonObjListWithUserId:@"235" withLessonObj:lesson withFinished:^(BOOL flag) {
//        NSLog(@"update lesson:%@",flag?@"yes":@"no");
//    }];
}

///测试插入资料信息
+(void)insertMaterialTest{
  NSMutableArray *lessonArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        LearningMaterials *materials = [[LearningMaterials alloc] init];
        materials.materialId = @"111";
        materials.materialName= @"00000";
        materials.materialLessonCategoryId= @"564";
        materials.materialFileLocalPath= @"000000";
        materials.materialFileDownloadURL= @"000000";
        materials.materialFileDownloadStaus = DownloadStatus_Downloaded;
        materials.materialCreateDate= @"564";
        materials.materialLessonCategoryName= @"564";
        materials.materialFileType = LearningMaterialsFileType_jpg;
        materials.materialSearchCount= @"564";
        materials.materialFileSize= @"564";
        [lessonArray addObject:materials];
    }
    
    [DRFMDBDatabaseTool insertMaterialObjListWithUserId:@"256" withMaterialObjArray:lessonArray withFinished:^(BOOL flag) {
        NSLog(@"insertMaterialObj:%@",flag?@"yes":@"no");
    }];
    
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    NSLog(@"%@",tool.databasePath);
}

///测试插入章节信息
+(void)insertChapterTest{
    NSMutableArray *lessonArray = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        chapterModel *chapter = [[chapterModel alloc] init];
        chapter.chapterId = @"1254";
        chapter.chapterName = @"hao are you";
        chapter.chapterImg = @"sfss";
        [lessonArray addObject:chapter];
    }
    [DRFMDBDatabaseTool insertChapterListWithUserId:@"123" withLessonId:@"123" withLessonCategoryId:@"123" withChapterObjArray:lessonArray withFinished:^(BOOL flag) {
        NSLog(@"insertChapterList:%@",flag?@"yes":@"no");
    }];
}

///测试小节信息
+(void)insertSectionTest{
    SectionModel *section = [[SectionModel alloc] init];
    section.sectionId = @"44dd";
    section.sectionName = @"ddd";
    section.lessonId = @"ddd";
    section.lessonCategoryId = @"ddd";
    section.sectionLastPlayTime = @"ddd";
    section.sectionMoviePlayURL = @"0000000000";
    section.sectionMovieDownloadURL = @"ddd";
    section.sectionMovieLocalURL = @"00000000";
    section.sectionFinishedDate = @"ddd";
    section.sectionMovieFileDownloadStatus = DownloadStatus_Downloading;
//    [DRFMDBDatabaseTool insertSectionModelObjListWithUserId:@"123" withChapterId:@"123" withSectionModelObjArray:@[section] withFinished:^(BOOL flag) {
//         NSLog(@"insertSectionModelObj:%@",flag?@"yes":@"no");
//    }];
    [DRFMDBDatabaseTool deleteALLSectionWithUserId:@"123" withFinished:^(BOOL flag) {
        NSLog(@"deleteALLSectionWith:%@",flag?@"yes":@"no");
    }];
}
@end
