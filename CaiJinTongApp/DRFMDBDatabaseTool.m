//
//  DRFMDBDatabaseTool.m
//  CaiJinTongApp
//
//  Created by david on 14-4-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DRFMDBDatabaseTool.h"
@interface DRFMDBDatabaseTool()
@property (nonatomic,strong) FMDatabaseQueue *dbQueue;
@property (nonatomic,strong) NSString *dbPath;
-(void)setPath:(NSString*)path;
-(void)setQueue:(FMDatabaseQueue*)databaseQueue;
@end

@implementation DRFMDBDatabaseTool
+(id)shareDRFMDBDatabaseTool{
    static DRFMDBDatabaseTool *dbTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbTool = [[DRFMDBDatabaseTool alloc] init];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [paths objectAtIndex:0];
//        NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"database"];
        NSString *dbPath = [documentDirectory stringByAppendingPathComponent:@"caijingtong.db"];
        dbTool.dbPath = dbPath;
        [dbTool setPath:dbPath];
        dbTool.dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbTool.dbPath];
        [dbTool setQueue:dbTool.dbQueue];
        [dbTool createTables];
    });
    return dbTool;
}

-(void)setPath:(NSString*)path{
    _databasePath = path;
}

-(void)setQueue:(FMDatabaseQueue*)databaseQueue{
    _databaseQueue = databaseQueue;
}

//TODO:创建所有表
-(void)createTables{
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //1.创建课程表
        FMResultSet *rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Lesson'"];
        
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Lesson (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE ,lessonId VARCHAR, lessonName VARCHAR,lessonCategoryId VARCHAR,lessonImageURL TEXT,lessonStudyProgress VARCHAR, lessonDetailInfo TEXT,lessonTeacherName VARCHAR,lessonDuration VARCHAR,lessonStudyTime VARCHAR,lessonScore VARCHAR,lessonIsScored VARCHAR,userId VARCHAR)"];
        }
        [rs close];
        
        //2.创建课程下的章节列表
        /*
         chapterLessonId 章节对应的课程id
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Chapter'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Chapter (id INTEGER PRIMARY KEY  NOT NULL , chapterId VARCHAR, chapterImg VARCHAR,chapterName VARCHAR,chapterLessonId VARCHAR,lessonCategoryId VARCHAR,userId VARCHAR)"];
        }
        
        [rs close];
        
        //3.创建章节下面的小节表
        /*
         sectionChapterId 小节对应章节id
         */
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Section'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Section (id INTEGER PRIMARY KEY  NOT NULL , sectionId VARCHAR, sectionName VARCHAR,lessonId VARCHAR,sectionChapterId VARCHAR,lessonCategoryId VARCHAR,sectionLastPlayTime VARCHAR,sectionMoviePlayURL TEXT,sectionMovieDownloadURL TEXT,sectionMovieLocalURL TEXT,sectionFinishedDate VARCHAR,sectionMovieFileDownloadStatus VARCHAR,userId VARCHAR)"];
        }
        
        [rs close];
        
        /*
        //4.创建课程下的评论列表
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Comment'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Comment (id INTEGER PRIMARY KEY  NOT NULL , commentId VARCHAR, commentAuthorId VARCHAR,commentAuthorName VARCHAR,commentCreateDate VARCHAR,commentContent TEXT,userId VARCHAR,commentLessonId VARCHAR)"];
        }
        
        [rs close];
        
        */
        
        /*
        //5.创建课程下的笔记列表
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Note'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Note (id INTEGER PRIMARY KEY  NOT NULL , noteId VARCHAR, noteTime VARCHAR,noteText TEXT,noteSectionId VARCHAR,noteChapterId VARCHAR,noteLessonId VARCHAR,userId VARCHAR)"];
        }
        
        [rs close];
        
        */
        //6.创建分类表
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'Category'"];
        /*
         caregoryId 分类id
         categoryName 分类name
         categoryLevel 分类当前层级
         categoryParentId 分类父级id 对应 categoryId
         categoryContentType 当前级所在的类型,0表示课程，1表示资料
         categoryIsExtend 当前级是否是展开的
         categoryIsSelected 当前级是否是选中的
         noteRootContentID 对应的根节点id
         */
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE Category (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE ,categoryId VARCHAR,categoryName VARCHAR, categoryLevel INTEGER,categoryParentId VARCHAR,categoryContentType VARCHAR,categoryIsExtend VARCHAR, categoryIsSelected VARCHAR,userId VARCHAR,noteRootContentID VARCHAR)"];
        }
        [rs close];
        
        
        
        //7.创建资料表
        rs = [db executeQuery:@"select name from SQLITE_MASTER where name = 'LearningMaterials'"];
        if (![rs next]) {
            [rs close];
            [db executeUpdate:@"CREATE TABLE LearningMaterials (id INTEGER PRIMARY KEY  NOT NULL , userId VARCHAR,materialId VARCHAR,materialName VARCHAR,fileName VARCHAR, fileCategoryId VARCHAR,fileLocalPath VARCHAR,fileDownloadUrl VARCHAR,fileDownloadStatus VARCHAR,fileCreateDate VARCHAR,fileCategoryName VARCHAR,fileType INTEGER, fileSearchCount VARCHAR,fileSize VARCHAR)"];
        }
        
        [rs close];
        
        
    }];
}

#pragma mark 课程相关操作

///保存课程分类信息到数据库，存放DRTreeNode数组对象
+(void)insertLessonCategoryListWithUserId:(NSString*)userId withLessonCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished{
    [DRFMDBDatabaseTool deleteLessonCategoryListWithUserId:userId withFinished:^(BOOL flag) {
        if (flag) {
            DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
            [tool.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL whoopsSomethingWrongHappened = YES;
                for (DRTreeNode *node in noteArray) {
                    whoopsSomethingWrongHappened = [DRFMDBDatabaseTool saveTreeNoteIntoCategoryWithType:@"0" withTreeNote:node withDataBase:db withUserId:userId withParentTreeNoteId:@""];
                }
                if (!whoopsSomethingWrongHappened) {
                    *rollback = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finished) {
                            finished(NO);
                        }
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(YES);
                    }
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
        }
    }];
}

//TODO:保存TreeNote到Category 表 type ：0表示课程分类，1表示资料分类
+(BOOL)saveTreeNoteIntoCategoryWithType:(NSString*)type withTreeNote:(DRTreeNode*)note withDataBase:(FMDatabase*)database withUserId:(NSString*)userId withParentTreeNoteId:(NSString*)parentId{
    BOOL res = [database executeUpdate:@"insert into Category (categoryId ,categoryName , categoryLevel ,categoryParentId ,categoryContentType ,categoryIsExtend , categoryIsSelected ,userId,noteRootContentID) values (?,?,?,?,?,?,?,?,?)"
                ,note.noteContentID
                ,note.noteContentName
                ,[NSNumber numberWithInt:note.noteLevel]
                ,parentId
                ,type
                ,note.noteIsExtend?@"yes":@"no"
                ,note.noteIsSelected?@"yes":@"no"
                ,userId
                ,note.noteRootContentID];
    if (res) {
        for (DRTreeNode *child in note.childnotes) {
            [DRFMDBDatabaseTool saveTreeNoteIntoCategoryWithType:type withTreeNote:child withDataBase:database withUserId:userId withParentTreeNoteId:note.noteContentID];
        }
    }
    return res;
}

+(DRTreeNode*)convertTreeNodeFromResultSet:(FMResultSet*)rs{
    DRTreeNode *node = [[DRTreeNode alloc] init];
    node.noteContentID = [rs stringForColumn:@"categoryId"];
    node.noteContentName = [rs stringForColumn:@"categoryName"];
    node.noteIsExtend = [@"yes" isEqualToString:[rs stringForColumn:@"categoryIsExtend"]]?YES:NO;
    node.noteIsSelected = [@"yes" isEqualToString:[rs stringForColumn:@"categoryIsSelected"]]?YES:NO;
    node.noteRootContentID = [rs stringForColumn:@"noteRootContentID"];
    node.noteLevel = [rs intForColumn:@"categoryLevel"];
    node.noteParentId = [rs stringForColumn:@"categoryParentId"];
    return node;
}

///查询数据库中课程分类信息,返回DRTreeNode数组对象
+(void)selectLessonCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Category where userId = ? and categoryContentType=? order by categoryLevel",userId,@"0"];
        
        NSMutableArray *array = [NSMutableArray array];
        while ([rs next]) {
            DRTreeNode *node = [DRFMDBDatabaseTool convertTreeNodeFromResultSet:rs];
            [array addObject:node];
        }
        [rs close];
        NSArray *oneLevelNodeArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"noteLevel == 0"]];
        for (DRTreeNode *node in oneLevelNodeArray) {
            node.childnotes =  [DRFMDBDatabaseTool collectTreeNodeChildWithNodeArray:array withNodeContentId:node.noteContentID];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(oneLevelNodeArray,(oneLevelNodeArray &&oneLevelNodeArray.count > 0) ? nil:@"本地无课程分类数据");
            }
        });
        
    }];
}

///所有parentid相同的节点重组
+(NSArray*)collectTreeNodeChildWithNodeArray:(NSArray*)nodeArray withNodeContentId:(NSString*)nodeContentId{
    NSArray *childNodeArray = [nodeArray filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"noteParentId == %@",nodeContentId]];
    for (DRTreeNode *node in childNodeArray) {
        node.childnotes = [DRFMDBDatabaseTool collectTreeNodeChildWithNodeArray:childNodeArray withNodeContentId:node.noteContentID];
    }
    return childNodeArray;
}

///删除保存的课程分类信息
+(void)deleteLessonCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from Category where userId = ? and categoryContentType=?",userId,@"0"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}


///保存课程信息列表，数组存放LessonModel对象
+(void)insertLessonObjListWithUserId:(NSString*)userId withLessonObjArray:(NSArray*)lessonArray withFinished:(void (^)(BOOL flag))finished{
    if (!lessonArray || lessonArray.count <= 0) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
        for (LessonModel *lesson in lessonArray) {
            BOOL isExist = [DRFMDBDatabaseTool lessonIsExistForLessonId:lesson.lessonId withUserId:userId withDatabase:db];
            if (isExist) {
                whoopsSomethingWrongHappened = [DRFMDBDatabaseTool updateLessonObjListWithUserId:userId withLessonObj:lesson withDatabase:db];
            }else{
                whoopsSomethingWrongHappened = [db executeUpdate:@"insert into Lesson (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId ) values (?,?,?,?,?,?,?,?,?,?,?,?)"
                                                ,lesson.lessonId?:@""
                                                ,lesson.lessonName?:@""
                                                ,lesson.lessonCategoryId?:@""
                                                ,lesson.lessonImageURL?:@""
                                                ,lesson.lessonStudyProgress?:@""
                                                ,lesson.lessonDetailInfo?:@""
                                                ,lesson.lessonTeacherName?:@""
                                                ,lesson.lessonDuration?:@""
                                                ,lesson.lessonStudyTime?:@""
                                                ,lesson.lessonScore?:@""
                                                ,lesson.lessonIsScored?:@""
                                                ,userId];
            }
            if (!whoopsSomethingWrongHappened) {
                break;
            }
        }
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///判断课程是否存在
+(BOOL)lessonIsExistForLessonId:(NSString*)lessonId withUserId:(NSString*)userId withDatabase:(FMDatabase*)db{
    FMResultSet * rs = [db executeQuery:@"select lessonId from Lesson where userId = ? and lessonId=?",userId,lessonId];
    if ([rs next]) {
        return YES;
    }
    return NO;
}

///更新课程信息
+(BOOL)updateLessonObjListWithUserId:(NSString*)userId withLessonObj:(LessonModel*)lesson withDatabase:(FMDatabase*)db{
    return [db executeUpdate:@"update Lesson set  lessonImageURL=? ,lessonStudyProgress=? , lessonDetailInfo=? ,lessonTeacherName=? ,lessonDuration=? ,lessonStudyTime=? ,lessonScore=? ,lessonIsScored=? where userId = ? and lessonId=?"
            ,lesson.lessonImageURL?:@""
            ,lesson.lessonStudyProgress?:@""
            ,lesson.lessonDetailInfo?:@""
            ,lesson.lessonTeacherName?:@""
            ,lesson.lessonDuration?:@""
            ,lesson.lessonStudyTime?:@""
            ,lesson.lessonScore?:@""
            ,lesson.lessonIsScored?:@""
            ,userId
            ,lesson.lessonId];
}

///更新课程信息
+(void)updateLessonObjListWithUserId:(NSString*)userId withLessonObj:(LessonModel*)lesson withFinished:(void (^)(BOOL flag))finished{
    if (!lesson) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
         whoopsSomethingWrongHappened = [DRFMDBDatabaseTool updateLessonObjListWithUserId:userId withLessonObj:lesson withDatabase:db];
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///判断当前课程是否存在
+(void)judgeLessonIsExistWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished{
    if (!lessonId) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL isExist = [DRFMDBDatabaseTool lessonIsExistForLessonId:lessonId withUserId:userId withDatabase:db];
        if (isExist) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(YES);
                }
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
        }
    }];
}

///删除保存的课程信息
+(void)deleteLessonObjWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from Lesson where userId = ? and lessonId=?",userId,lessonId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}

///删除保存的课程信息
+(void)deleteALLLessonsWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from Lesson where userId = ?",userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
       FMResultSet * rs = [db executeQuery:@"select * from Lesson where userId = ?",userId];
        NSMutableArray *lessonArr = [NSMutableArray array];
//        (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId )
        while([rs next]) {
            LessonModel *lesson = lesson = [DRFMDBDatabaseTool convertLessonObjFromResultSet:rs];
            [lessonArr addObject:lesson];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(lessonArr,nil);
            }
        });
    }];
}

+(LessonModel*)convertLessonObjFromResultSet:(FMResultSet*)rs{
    LessonModel *lesson = [[LessonModel alloc] init];
    lesson.lessonId = [rs stringForColumn:@"lessonId"];
    lesson.lessonName = [rs stringForColumn:@"lessonName"];
    lesson.lessonCategoryId = [rs stringForColumn:@"lessonCategoryId"];
    lesson.lessonImageURL = [rs stringForColumn:@"lessonImageURL"];
    lesson.lessonStudyProgress = [rs stringForColumn:@"lessonStudyProgress"];
    lesson.lessonDetailInfo = [rs stringForColumn:@"lessonDetailInfo"];
    lesson.lessonTeacherName = [rs stringForColumn:@"lessonTeacherName"];
    lesson.lessonDuration = [rs stringForColumn:@"lessonDuration"];
    lesson.lessonStudyTime = [rs stringForColumn:@"lessonStudyTime"];
    lesson.lessonScore = [rs stringForColumn:@"lessonScore"];
    lesson.lessonIsScored = [rs stringForColumn:@"lessonIsScored"];
    return lesson;
}
///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Lesson where userId = ? and lessonCategoryId=?",userId,categoryId];
        NSMutableArray *lessonArr = [NSMutableArray array];
        //        (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId )
        while([rs next]) {
            LessonModel *lesson = lesson = [DRFMDBDatabaseTool convertLessonObjFromResultSet:rs];
            [lessonArr addObject:lesson];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(lessonArr,nil);
            }
        });
    }];
}


///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(LessonModel *lesson))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Lesson where userId = ? and lessonId=?",userId,lessonId];
        //        (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId )
         LessonModel *lesson = nil;
        if ([rs next]) {
            lesson = [DRFMDBDatabaseTool convertLessonObjFromResultSet:rs];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(lesson);
            }
        });
    }];
}
#pragma mark --

#pragma mark 资料相关操作
///查询数据库中资料分类信息,返回DRTreeNode数组对象
+(void)selectMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Category where userId = ? and categoryContentType=? order by categoryLevel",userId,@"1"];
        
        NSMutableArray *array = [NSMutableArray array];
        while ([rs next]) {
            DRTreeNode *node = [DRFMDBDatabaseTool convertTreeNodeFromResultSet:rs];
            [array addObject:node];
        }
        [rs close];
        NSArray *oneLevelNodeArray = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"noteLevel == 0"]];
        for (DRTreeNode *node in oneLevelNodeArray) {
            node.childnotes =  [DRFMDBDatabaseTool collectTreeNodeChildWithNodeArray:array withNodeContentId:node.noteContentID];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(oneLevelNodeArray,(oneLevelNodeArray &&oneLevelNodeArray.count > 0) ? nil:@"本地无课程分类数据");
            }
        });
        
    }];
}


///保存资料分类信息到数据库，存放DRTreeNode数组对象
+(void)insertMaterialCategoryListWithUserId:(NSString*)userId withMaterialCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished{
    [DRFMDBDatabaseTool deleteMaterialCategoryListWithUserId:userId withFinished:^(BOOL flag) {
        if (flag) {
            DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
            [tool.databaseQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
                BOOL whoopsSomethingWrongHappened = YES;
                for (DRTreeNode *node in noteArray) {
                    whoopsSomethingWrongHappened = [DRFMDBDatabaseTool saveTreeNoteIntoCategoryWithType:@"1" withTreeNote:node withDataBase:db withUserId:userId withParentTreeNoteId:@""];
                }
                if (!whoopsSomethingWrongHappened) {
                    *rollback = YES;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (finished) {
                            finished(NO);
                        }
                    });
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (finished) {
                        finished(YES);
                    }
                });
            }];
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
        }
    }];
}

///删除保存的资料分类信息
+(void)deleteMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from Category where userId = ? and categoryContentType=?",userId,@"1"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}

///更新资料信息
+(BOOL)updateMaterialObjListWithUserId:(NSString*)userId withMaterialObj:(LearningMaterials*)materials withDatabase:(FMDatabase*)db{
    return [db executeUpdate:@"update LearningMaterials set fileLocalPath = ?,fileDownloadStatus = ? where userId = ? and materialId = ?",materials.materialFileLocalPath,[DRFMDBDatabaseTool convertDownloadStatusFromStatus:materials.materialFileDownloadStaus],userId,materials.materialId];
}


///更新资料信息
+(void)updateMaterialObjListWithUserId:(NSString*)userId withMaterialObj:(LearningMaterials*)materials withFinished:(void (^)(BOOL flag))finished{
    if (!materials) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
        whoopsSomethingWrongHappened = [DRFMDBDatabaseTool updateMaterialObjListWithUserId:userId withMaterialObj:materials withDatabase:db];
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///保存资料信息列表，数组存放LearningMaterials对象
+(void)insertMaterialObjListWithUserId:(NSString*)userId withMaterialObjArray:(NSArray*)materialArray withFinished:(void (^)(BOOL flag))finished{
    if (!materialArray || materialArray.count <= 0) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
        for (LearningMaterials *materials in materialArray) {
            BOOL isExist = [DRFMDBDatabaseTool materialIsExistForMaterialId:materials.materialId withUserId:userId withDatabase:db];
            if (isExist) {
                whoopsSomethingWrongHappened = [DRFMDBDatabaseTool updateMaterialObjListWithUserId:userId withMaterialObj:materials withDatabase:db];
            }else{
                whoopsSomethingWrongHappened = [db executeUpdate:@"insert into LearningMaterials (userId,materialId,materialName,fileName,fileCategoryId,fileLocalPath,fileDownloadUrl,fileDownloadStatus,fileCreateDate,fileCategoryName,fileType,fileSearchCount,fileSize) values (?,?,?,?,?,?,?,?,?,?,?,?,?)"
                                                ,userId?:@""
                                                ,materials.materialId?:@""
                                                ,materials.materialName?:@""
                                                ,@"fileName"
                                                ,materials.materialLessonCategoryId?:@""
                                                ,materials.materialFileLocalPath?:@""
                                                ,materials.materialFileDownloadURL?:@""
                                                ,[DRFMDBDatabaseTool convertDownloadStatusFromStatus:materials.materialFileDownloadStaus]
                                                ,materials.materialCreateDate?:@""
                                                ,materials.materialLessonCategoryName?:@""
                                                ,[DRFMDBDatabaseTool convertMaterialFileTypeFromFileType:materials.materialFileType]
                                                ,materials.materialSearchCount?:@""
                                                ,materials.materialFileSize?:@""];
            }
            if (!whoopsSomethingWrongHappened) {
                break;
            }
        }
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///判断课程是否存在
+(BOOL)materialIsExistForMaterialId:(NSString*)materialId withUserId:(NSString*)userId withDatabase:(FMDatabase*)db{
//    (userId ,materialId ,materialName ,fileName , fileCategoryId ,fileLocalPath ,fileDownloadUrl ,fileDownloadStatus ,fileCreateDate ,fileCategoryName ,fileType , fileSearchCount ,fileSize )
    FMResultSet * rs = [db executeQuery:@"select materialId from LearningMaterials where userId = ? and materialId=?",userId,materialId];
    if ([rs next]) {
        return YES;
    }
    return NO;
}

///资料类型转换
+(NSString*)convertMaterialFileTypeFromFileType:(LearningMaterialsFileType)fileType{
    switch (fileType) {
        case LearningMaterialsFileType_jpg:
            return @"0";
        case LearningMaterialsFileType_pdf:
            return @"1";
        case LearningMaterialsFileType_ppt:
            return @"2";
        case LearningMaterialsFileType_text:
            return @"3";
        case LearningMaterialsFileType_word:
            return @"4";
        case LearningMaterialsFileType_zip:
            return @"5";
        case LearningMaterialsFileType_other:
            return @"6";
        default:
            break;
    }
    return @"6";
}

///资料类型转换
+(LearningMaterialsFileType)convertMaterialFileTypeFromInteger:(int)inter{
    switch (inter) {
        case 0:
            return LearningMaterialsFileType_jpg;
        case 1:
            return LearningMaterialsFileType_pdf;
        case 2:
            return LearningMaterialsFileType_ppt;
        case 3:
            return LearningMaterialsFileType_text;
        case 4:
            return LearningMaterialsFileType_word;
        case 5:
            return LearningMaterialsFileType_zip;
        case 6:
            return LearningMaterialsFileType_other;
        default:
            break;
    }
    return LearningMaterialsFileType_other;
}

///获取资料内容
+(LearningMaterials*)convertLearningMaterialsFromResultSet:(FMResultSet*)rs{
    LearningMaterials *material  = [[LearningMaterials alloc] init];
    material.materialId = [rs stringForColumn:@"materialId"];
    material.materialName = [rs stringForColumn:@"materialName"];
    material.materialLessonCategoryId = [rs stringForColumn:@"fileCategoryId"];
    material.materialLessonCategoryName = [rs stringForColumn:@"fileCategoryName"];
    material.materialFileSize = [rs stringForColumn:@"fileSize"];
    material.materialFileType = [DRFMDBDatabaseTool convertMaterialFileTypeFromInteger:[rs intForColumn:@"fileType"]];
    material.materialFileDownloadStaus = [DRFMDBDatabaseTool convertDownloadStatusFromString:[rs stringForColumn:@"fileDownloadStatus"]];
    material.materialSearchCount = [rs stringForColumn:@"fileSearchCount"];
    material.materialCreateDate = [rs stringForColumn:@"fileCreateDate"];
    material.materialFileDownloadURL = [rs stringForColumn:@"fileDownloadUrl"];
    material.materialFileLocalPath = [rs stringForColumn:@"fileLocalPath"];
    return material;
}

//TODO:下载状态转换
+(NSString*)convertDownloadStatusFromStatus:(DownloadStatus)status{
    switch (status) {
        case DownloadStatus_UnDownload:
            return @"0";
        case DownloadStatus_Downloading:
            return @"1";
        case DownloadStatus_Downloaded:
            return @"2";
        case DownloadStatus_Pause:
            return @"3";
        default:
            break;
    }
    return @"0";
}

//TODO:下载状态转换
+(DownloadStatus)convertDownloadStatusFromString:(NSString*)status{
    if (!status || [status isEqualToString:@""]) {
        return DownloadStatus_UnDownload;
    }
    switch (status.intValue) {
        case 0:
            return DownloadStatus_UnDownload;
        case 1:
            return DownloadStatus_Downloading;
        case 2:
            return DownloadStatus_Downloaded;
        case 3:
            return DownloadStatus_Pause;
        default:
            break;
    }
    return DownloadStatus_UnDownload;
}


///删除保存的资料信息
+(void)deleteALLMaterialWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from LearningMaterials where userId = ?",userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}

///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId withLearningMaterialsCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from LearningMaterials where userId = ? and fileCategoryId = ?",userId,categoryId];
        NSMutableArray *materialArr = [NSMutableArray array];
        //        (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId )
        while([rs next]) {
            LearningMaterials *material  =  [DRFMDBDatabaseTool convertLearningMaterialsFromResultSet:rs];
            [materialArr addObject:material];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(materialArr,nil);
            }
        });
    }];
}


///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId  withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from LearningMaterials where userId = ?",userId];
        NSMutableArray *materialArr = [NSMutableArray array];
        //        (lessonId , lessonName ,lessonCategoryId ,lessonImageURL ,lessonStudyProgress , lessonDetailInfo ,lessonTeacherName ,lessonDuration ,lessonStudyTime ,lessonScore ,lessonIsScored ,userId )
        while([rs next]) {
            LearningMaterials *material  =  [DRFMDBDatabaseTool convertLearningMaterialsFromResultSet:rs];
            [materialArr addObject:material];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(materialArr,nil);
            }
        });
    }];
}
#pragma mark --

#pragma mark 章节信息
///课程下面章节信息
+(void)insertChapterListWithUserId:(NSString*)userId withLessonId:(NSString*)lessonId withLessonCategoryId:(NSString*)categoryId withChapterObjArray:(NSArray*)chapterArray withFinished:(void (^)(BOOL flag))finished{
    if (!chapterArray || chapterArray.count <= 0) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
        FMResultSet * rs = [db executeQuery:@"select chapterId from Chapter where userId = ? and chapterLessonId=? and lessonCategoryId = ?",userId,lessonId,categoryId];
        if ([rs next]) {
            [rs close];
            whoopsSomethingWrongHappened = [db executeUpdate:@"delete from Chapter where userId = ? and chapterLessonId=? and lessonCategoryId = ?",userId,lessonId,categoryId];
        }else
        [rs close];
        //                (chapterId , chapterName ,chapterLessonId ,userId )
        if (whoopsSomethingWrongHappened) {
            for (chapterModel *chapter in chapterArray) {
                whoopsSomethingWrongHappened = [db executeUpdate:@"insert into Chapter (chapterId,chapterName ,chapterLessonId ,lessonCategoryId,chapterImg,userId ) values (?,?,?,?,?,?)"
                                                ,chapter.chapterId?:@""
                                                ,chapter.chapterName?:@""
                                                ,lessonId?:@""
                                                ,categoryId?:@""
                                                ,chapter.chapterImg?:@""
                                                ,userId];
                if (!whoopsSomethingWrongHappened) {
                    break;
                }
            }
        }
        
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///删除保存的章节信息
+(void)deleteALLChapterWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        BOOL res = [db executeUpdate:@"delete from Chapter where userId = ?",userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}

///查询数据库中课程信息,返回chapterModel数组对象
+(void)selectChapterListWithUserId:(NSString*)userId withLessonId:(NSString*)lessonId withFinished:(void (^)(NSArray *chapterArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Chapter where userId = ? and chapterLessonId=?",userId,lessonId];
        NSMutableArray *chapterArr = [NSMutableArray array];
//         (chapterId , chapterName ,chapterLessonId ,userId )
        while([rs next]) {
            chapterModel *chapter = [[chapterModel alloc] init];
            chapter.chapterId = [rs stringForColumn:@"chapterId"];
            chapter.chapterName = [rs stringForColumn:@"chapterName"];
            chapter.chapterImg = [rs stringForColumn:@"chapterImg"];
            [chapterArr addObject:chapter];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(chapterArr,nil);
            }
        });
    }];
}
#pragma mark --



#pragma mark 章节下的小节信息

///判断章节下的小节是否存在
+(BOOL)sectionIsExistForSectionId:(NSString*)sectionId withUserId:(NSString*)userId withLessonId:(NSString*)lessonId  withDatabase:(FMDatabase*)db{
//    (sectionId , sectionName ,lessonId ,sectionChapterId ,lessonCategoryId ,sectionLastPlayTime ,sectionMoviePlayURL ,sectionMovieDownloadURL ,sectionMovieLocalURL ,sectionFinishedDate ,sectionMovieFileDownloadStatus ,userId )
    FMResultSet * rs = [db executeQuery:@"select sectionId from Section where userId = ? and lessonId=? and sectionId=?",userId,lessonId,sectionId];
    if ([rs next]) {
        [rs close];
        return YES;
    }
     [rs close];
    return NO;
}

///保存章节下的小节信息列表，数组存放SectionModel对象,如果对象存在则修改对象
+(void)insertSectionModelObjListWithUserId:(NSString*)userId withChapterId:(NSString*)chapterId withSectionModelObjArray:(NSArray*)sectionModelArray withFinished:(void (^)(BOOL flag))finished{
    if (!sectionModelArray || sectionModelArray.count <= 0) {
        if (finished) {
            finished(NO);
        }
        return;
    }
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        BOOL whoopsSomethingWrongHappened = YES;
        for (SectionModel *section in sectionModelArray) {
            BOOL isExist = [DRFMDBDatabaseTool sectionIsExistForSectionId:section.sectionId withUserId:userId withLessonId:section.lessonId withDatabase:db];
            if (isExist) {
                whoopsSomethingWrongHappened = [DRFMDBDatabaseTool updateSectionObjListWithUserId:userId withChapterId:chapterId withSectionObj:section withDatabase:db];
            }else{
//                 (sectionId , sectionName ,lessonId ,sectionChapterId ,lessonCategoryId ,sectionLastPlayTime ,sectionMoviePlayURL ,sectionMovieDownloadURL ,sectionMovieLocalURL ,sectionFinishedDate ,sectionMovieFileDownloadStatus ,userId )
                whoopsSomethingWrongHappened = [db executeUpdate:@"insert into Section (sectionId , sectionName ,lessonId ,sectionChapterId ,lessonCategoryId ,sectionLastPlayTime ,sectionMoviePlayURL ,sectionMovieDownloadURL ,sectionMovieLocalURL ,sectionFinishedDate ,sectionMovieFileDownloadStatus ,userId ) values (?,?,?,?,?,?,?,?,?,?,?,?)"
                                                ,section.sectionId
                                                ,section.sectionName
                                                ,section.lessonId
                                                ,chapterId
                                                ,section.lessonCategoryId
                                                ,section.sectionLastPlayTime
                                                ,section.sectionMoviePlayURL
                                                ,section.sectionMovieDownloadURL
                                                ,section.sectionMovieLocalURL
                                                ,section.sectionFinishedDate
                                                ,[DRFMDBDatabaseTool convertDownloadStatusFromStatus:section.sectionMovieFileDownloadStatus]
                                                ,userId];
            }
            if (!whoopsSomethingWrongHappened) {
                break;
            }
        }
        if (!whoopsSomethingWrongHappened) {
            *rollback = YES;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (finished) {
                    finished(NO);
                }
            });
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(YES);
            }
        });
    }];
}

///更新小节信息
+(BOOL)updateSectionObjListWithUserId:(NSString*)userId withChapterId:(NSString*)chapterId withSectionObj:(SectionModel*)section withDatabase:(FMDatabase*)db{
//    (sectionId , sectionName ,lessonId ,sectionChapterId ,lessonCategoryId ,sectionLastPlayTime ,sectionMoviePlayURL ,sectionMovieDownloadURL ,sectionMovieLocalURL ,sectionFinishedDate ,sectionMovieFileDownloadStatus ,userId )
    return [db executeUpdate:@"update Section set  sectionLastPlayTime=? ,sectionMoviePlayURL=? ,sectionMovieDownloadURL=? ,sectionMovieLocalURL=? ,sectionFinishedDate=? ,sectionMovieFileDownloadStatus=? where sectionId=?  and userId=?"
            ,section.sectionLastPlayTime
            ,section.sectionMoviePlayURL
            ,section.sectionMovieDownloadURL
            ,section.sectionMovieLocalURL
            ,section.sectionFinishedDate
            ,[DRFMDBDatabaseTool convertDownloadStatusFromStatus:section.sectionMovieFileDownloadStatus]
            ,section.sectionId
            ,userId];
}

///删除保存的小节信息
+(void)deleteALLSectionWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        __block BOOL res = [db executeUpdate:@"delete from Section where userId = ?",userId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(res);
            }
        });
    }];
}


///获取资料内容
+(SectionModel*)convertSectionFromResultSet:(FMResultSet*)rs{
    //    (sectionId , sectionName ,lessonId ,sectionChapterId ,lessonCategoryId ,sectionLastPlayTime ,sectionMoviePlayURL ,sectionMovieDownloadURL ,sectionMovieLocalURL ,sectionFinishedDate ,sectionMovieFileDownloadStatus ,userId )
    
    SectionModel *section = [[SectionModel alloc] init];
    section.sectionId = [rs stringForColumn:@"sectionId"];
    section.sectionName = [rs stringForColumn:@"sectionName"];
    section.lessonId = [rs stringForColumn:@"lessonId"];
    section.lessonCategoryId = [rs stringForColumn:@"lessonCategoryId"];
    section.sectionLastPlayTime = [rs stringForColumn:@"sectionLastPlayTime"];
    section.sectionMoviePlayURL = [rs stringForColumn:@"sectionMoviePlayURL"];
    section.sectionMovieDownloadURL = [rs stringForColumn:@"sectionMovieDownloadURL"];
    section.sectionMovieLocalURL = [rs stringForColumn:@"sectionMovieLocalURL"];
    section.sectionFinishedDate = [rs stringForColumn:@"sectionFinishedDate"];
    section.sectionMovieFileDownloadStatus = [DRFMDBDatabaseTool convertDownloadStatusFromString:[rs stringForColumn:@"sectionMovieFileDownloadStatus"]];
    
    return section;
}


///查询数据库中小节信息,返回SectionModel数组对象
+(void)selectSectionListWithUserId:(NSString*)userId  withChapterId:(NSString*)chapterId withLessonId:(NSString*)lessonId withFinished:(void (^)(NSArray *sectionArray,NSString *errorMsg))finished{
    DRFMDBDatabaseTool *tool = [DRFMDBDatabaseTool shareDRFMDBDatabaseTool];
    [tool.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:@"select * from Section where userId = ? and lessonId = ? and sectionChapterId = ?",userId,lessonId,chapterId];
        NSMutableArray *sectionArr = [NSMutableArray array];
        while([rs next]) {
            SectionModel *section  =  [DRFMDBDatabaseTool convertSectionFromResultSet:rs];
            [sectionArr addObject:section];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (finished) {
                finished(sectionArr,nil);
            }
        });
    }];
}
#pragma mark --
@end
