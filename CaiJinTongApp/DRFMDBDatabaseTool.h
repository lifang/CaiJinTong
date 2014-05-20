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

///查询数据库中课程分类信息,返回DRTreeNode数组对象
+(void)selectDownloadedMovieFileLessonCategoryListWithUserId:(NSString*)userId withDownloadLessonArray:(NSArray*)lessonArray withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished;

///保存课程分类信息到数据库，存放DRTreeNode数组对象
+(void)insertLessonCategoryListWithUserId:(NSString*)userId withLessonCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程分类信息
+(void)deleteLessonCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///保存课程信息列表，数组存放LessonModel对象
+(void)insertLessonObjListWithUserId:(NSString*)userId withLessonObjArray:(NSArray*)lessonArray withFinished:(void (^)(BOOL flag))finished;

///更新课程信息
+(void)updateLessonObjListWithUserId:(NSString*)userId withLessonObj:(LessonModel*)lesson withFinished:(void (^)(BOOL flag))finished;


///更新课程信息
+(void)updateLessonObjListWithUserId:(NSString*)userId withLessonObjArray:(NSArray*)lessonArray withFinished:(void (^)(BOOL flag))finished;


///判断当前课程是否存在
+(void)judgeLessonIsExistWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程信息
+(void)deleteLessonObjWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(BOOL flag))finished;

///删除保存的课程信息
+(void)deleteALLLessonsWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished;

///查询数据库中已经下载好视频信息课程信息,返回LessonModel数组对象
+(void)selectDownloadedMovieFileLessonListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *lessonArray,NSString *errorMsg))finished;

///查询数据库中课程信息,返回LessonModel数组对象
+(void)selectLessonListWithUserId:(NSString*)userId withLessonObjId:(NSString*)lessonId withFinished:(void (^)(LessonModel *lesson))finished;

//TODO:资料相关操作

///查询数据库中资料分类信息,返回DRTreeNode数组对象
+(void)selectMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished;

///查询数据库中已经下载文件的资料分类信息,返回DRTreeNode数组对象
+(void)selectDownloadedFileMaterialCategoryListWithUserId:(NSString*)userId withDownloadMaterialArray:(NSArray*)materialArray withFinished:(void (^)(NSArray *treeNoteArray,NSString *errorMsg))finished;

///保存资料分类信息到数据库，存放DRTreeNode数组对象
+(void)insertMaterialCategoryListWithUserId:(NSString*)userId withMaterialCategoryArray:(NSArray*)noteArray withFinished:(void (^)(BOOL flag))finished;

///删除保存的资料分类信息
+(void)deleteMaterialCategoryListWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///保存资料信息列表，数组存放LearningMaterials对象,如果对象存在则修改对象
+(void)insertMaterialObjListWithUserId:(NSString*)userId withMaterialObjArray:(NSArray*)materialArray withFinished:(void (^)(BOOL flag))finished;

///保存资料信息列表，数组存放LearningMaterials对象,如果对象存在则修改对象
+(void)updateMaterialObjListWithUserId:(NSString*)userId withMaterialObjArray:(NSArray*)materialArray withFinished:(void (^)(BOOL flag))finished;

///更新资料信息下载状态
+(void)updateMaterialObjListWithUserId:(NSString*)userId withMaterialId:(NSString*)materialId withDownloadStatus:(DownloadStatus)downloadStatus withFinished:(void (^)(BOOL flag))finished;

///更新资料文件本地路径
+(void)updateMaterialObjListWithUserId:(NSString*)userId withMaterialId:(NSString*)materialId withLocalPath:(NSString*)localpath withFinished:(void (^)(BOOL flag))finished;

///删除保存的资料信息
+(void)deleteALLMaterialWithUserId:(NSString*)userId withFinished:(void (^)(BOOL flag))finished;

///删除指定的资料
+(void)deleteMaterialWithUserId:(NSString*)userId withLearningMaterialsId:(NSString*)materialId withFinished:(void (^)(BOOL flag))finished;

///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId withLearningMaterialsCategoryId:(NSString*)categoryId withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished;

///查询当前资料的本地路径
+(void)selectLearningMaterialsLocalPathWithUserId:(NSString*)userId withLearningMaterialsId:(NSString*)materialId withFinished:(void (^)(NSString *materialLocalPath))finished;

///查询当前资料的下载状态
+(void)selectLearningMaterialsDownloadStatusWithUserId:(NSString*)userId withLearningMaterialsId:(NSString*)materialId withFinished:(void (^)(DownloadStatus status))finished;

///查询当前资料的下载状态
+(void)selectLearningMaterialsDownloadStatusWithUserId:(NSString*)userId withLearningMaterialArray:(NSArray*)materialArray withFinished:(void (^)(NSArray *materialList))finished;

///查询数据库中资料信息,返回LearningMaterials数组对象
+(void)selectLearningMaterialsListWithUserId:(NSString*)userId  withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished;

///查询数据库中已经下载资料的信息,返回LearningMaterials数组对象
+(void)selectDownloadedLearningMaterialsListWithUserId:(NSString*)userId  withFinished:(void (^)(NSArray *learningMaterialsArray,NSString *errorMsg))finished;

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

///更新小节下载状态信息
+(void)updateSectionDownloadStatusWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withDownloadStatus:(DownloadStatus)status withFinished:(void (^)(BOOL flag))finished;

///更新小节视频保存路径状态信息
+(void)updateSectionMovieLocalPathWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withLocalPath:(NSString *)localpath withFinished:(void (^)(BOOL flag))finished;

///更新小节已经下载大小信息
+(void)updateSectionDownloadStatusWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withFileDownloadSize:(NSString*)downloadSize  withFinished:(void (^)(BOOL flag))finished;

///更新小节需要下载文件总共大小
+(void)updateSectionDownloadStatusWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withFileTotalSize:(NSString*)totalSize  withFinished:(void (^)(BOOL flag))finished;

///删除小节信息
+(void)deleteSectionWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withFinished:(void (^)(BOOL flag))finished;

///更新小节视频播放的结束时间和最后播放时间
+(void)updateSectionPlayDateWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withPlayTime:(NSString*)playTime withLastFinishedDate:(NSString*)lastFinishedDate  withFinished:(void (^)(BOOL flag))finished;

///重新计算小节视频播放的结束时间和最后播放时间
+(void)updateSectionReCalculatePlayDateWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId  withFinished:(void (^)(BOOL flag))finished;

///更新小节视频离线播放时长
+(void)updateSectionOfflinePlayTimeWithUserId:(NSString*)userId withSectionId:(NSString*)sectionId withPlayTimeOffLine:(NSString*)offlinePlayTime withFinished:(void (^)(BOOL flag))finished;
///查询数据库已经下载的视频大小
+(void)selectSectionFileSizeWithUserId:(NSString*)userId  withSectionId:(NSString*)sectionId  withFinished:(void (^)(long long totalSize,long long downloadSize))finished;

///查询数据库中离线播放时间
+(void)selectSectionOfflinePlayTimeWithUserId:(NSString*)userId  withSectionId:(NSString*)sectionId  withFinished:(void (^)(NSString *offlinePlayTime))finished;

///查询数据库中小节信息,返回SectionModel数组对象
+(void)selectSectionListWithUserId:(NSString*)userId  withChapterId:(NSString*)chapterId withLessonId:(NSString*)lessonId withFinished:(void (^)(NSArray *sectionArray,NSString *errorMsg))finished;


///查询数据库中小节信息,返回SectionModel数组对象
+(void)selectSectionListWithUserId:(NSString*)userId  withFinished:(void (^)(NSArray *sectionArray,NSString *errorMsg))finished;

///查询数据库中小节信息,返回SectionModel数组对象
+(void)selectSectionListWithUserId:(NSString*)userId  withSectionId:(NSString*)sectionId withLessonId:(NSString*)lessonId withFinished:(void (^)(SectionModel *section))finished;

///查询数据库中最近播放的小节信息,返回SectionModel数组对象
+(void)selectSectionLastPlayWithUserId:(NSString*)userId   withLessonId:(NSString*)lessonId withFinished:(void (^)(SectionModel *section))finished;

//TODO:对课程整体操作
///插入课程LessonModel数据，包括已经下载的章节，和小节信息
+(void)insertLessonTreeDatasWithUserId:(NSString*)userId withLesson:(LessonModel*)lesson  withFinished:(void (^)(BOOL flag))finished;

///更新课程LessonModel数据，包括已经下载的章节，和小节信息
+(void)updateLessonTreeDatasWithUserId:(NSString*)userId withLessonArray:(NSArray*)lessonArray withFinished:(void (^)(BOOL flag))finished;

///删除所有的课程信息，包括章节和小节
+(void)deleteAllLessonDataWithUserId:(NSString*)userId  withFinished:(void (^)(BOOL flag))finished;

///查询数据库中课程信息,返回LessonModel数组对象,包括小节，章节
+(void)selectLessonTreeDatasWithUserId:(NSString*)userId withLessonId:(NSString*)lessonId withFinished:(void (^)(LessonModel *lesson,NSString *errorMsg))finished;

//清理所有缓存
+(void)clearAllDownloadedDatasWithSuccess:(void(^)())success withFailure:(void(^)(NSString*errorString))failure;
@end
