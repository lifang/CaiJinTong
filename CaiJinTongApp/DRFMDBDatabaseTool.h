//
//  DRFMDBDatabaseTool.h
//  CaiJinTongApp
//
//  Created by david on 14-4-3.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "DRTreeNode.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMDatabasePool.h"
#import "FMDatabaseQueue.h"
#import "LessonModel.h"
#import "LearningMaterials.h"
#import "chapterModel.h"
#import "SectionModel.h"
/** DRFMDBDatabaseTool
 *
 * 在单利线程安全下使用数据库
 */
@interface DRFMDBDatabaseTool : NSObject
///数据库路径
@property (nonatomic,strong,readonly) NSString *databasePath;
///数据库操作单利
@property (nonatomic,strong,readonly) FMDatabaseQueue *databaseQueue;
+(id)shareDRFMDBDatabaseTool;
//TODO:课程相关操作
///查询数据库中课程分类信息,返回DRTreeNode数组对象
+(void)selectLessonCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished;

///保存课程分类信息到数据库，存放DRTreeNode数组对象
+(void)insertLessonCategoryListWithUserId:(NSString*)userId withLessonCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程分类信息
+(void)deleteLessonCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///保存课程信息列表，数组存放LessonModel对象
+(void)insertLessonObjListWithUserId:(NSString*)userId withLessonObjArray:(NSArray*)lessonArray withFinished:(void (^)(BOOL flag))finished;

///更新课程信息
+(void)updateLessonObjListWithUserId:(NSString*)userId withLessonObj:(LessonModel*)lesson withFinished:(void (^)(BOOL flag))finished;

///判断当前课程是否存在
+(void)judgeLessonIsExistWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程信息
+(void)deleteLessonObjWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程信息
+(void)deleteALLLessonsWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(LessonModel *lesson))finished;

//TODO:资料相关操作
///查询数据库中资料分类信息,返回DRTreeNode数组对象
+(void)selectMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished;

///保存资料分类信息到数据库，存放DRTreeNode数组对象
+(void)insertMaterialCategoryListWithUserId:(NSString*)userId withMaterialCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的资料分类信息
+(void)deleteMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///保存资料信息列表，数组存放LearningMaterials对象,如果对象存在则修改对象
+(void)insertMaterialObjListWithUserId:(NSString*)userId withMaterialObjArray:(NSArray*)materialArray withFinished:(void (^)(BOOL flag))finished;

/////更新资料信息
//+(void)updateMaterialObjListWithUserId:(NSString*)userId withMaterialObj:(LearningMaterials*)materials withFinished:(void (^)(BOOL flag))finished;

///删除保存的资料信息
+(void)deleteALLMaterialWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId withLearningMaterialsCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished;

///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId  withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished;

//TODO:课程下面章节信息
///保存章节信息,如果已经存在则覆盖
+(void)insertChapterListWithUserId:(NSString*)userId withLessonId:(NSString*)lessonId withLessonCategoryId:(NSString*)categoryId withChapterObjArray:(NSArray*)chapterArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的章节信息
+(void)deleteALLChapterWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中章节信息,返回chapterModel数组对象
+(void)selectChapterListWithUserId:(NSString*)userId withLessonId:(NSString*)lessonId withFinished:(void (^)(NSArray *chapterArray,NSString *errorMsg))finished;

//TODO:章节下的小节信息
///保存章节下的小节信息列表，数组存放SectionModel对象,如果对象存在则修改对象
+(void)insertSectionModelObjListWithUserId:(NSString*)userId withChapterId:(NSString*)chapterId withSectionModelObjArray:(NSArray*)sectionModelArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的小节信息
+(void)deleteALLSectionWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中小节信息,返回SectionModel数组对象
+(void)selectSectionListWithUserId:(NSString*)userId  withChapterId:(NSString*)chapterId withLessonId:(NSString*)lessonId withFinished:(void (^)(NSArray *sectionArray,NSString *errorMsg))finished;
@end
