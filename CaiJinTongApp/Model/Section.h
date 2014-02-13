//
//  Section.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseDao.h"
#import "SectionSaveModel.h"
#import "NoteModel.h"
#import "SectionModel.h"
#import "Section_chapterModel.h"
#import "SectionModel.h"
#import "LearningMaterials.h"
@interface Section : BaseDao
+(Section*)defaultSection;
-(NSArray *)getDowningInfo;
//////////////////////////////////资料
-(LearningMaterials*)searchLearningMaterialsWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId;
-(NSString*)searchLearningMaterialsLocalPathWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId;
-(DownloadStatus)searchLearningMaterialsDownloadStatusWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId;
-(void)addLeariningMaterial:(LearningMaterials*)materials withUserId:(NSString*)userId;
-(BOOL)isExistForMaterialId:(NSString*)materialId withUserId:(NSString*)userId;
-(void)updateLeariningMaterial:(LearningMaterials*)materials withUserId:(NSString*)userId;
-(void)deleteLeariningMaterialWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId;
/**
  查询已经下载的资料
 */
-(NSArray*)searchAllDownloadMaterialsWithwithUserId:(NSString*)userId;
/**
 删除所有资料数据
 */
-(BOOL)deleteAllLearningMaterial;
//////////////////////////////////小节
-(SectionModel*)searchLastPlaySectionModelWithLessonId:(NSString*)lessonId;//获取最近播放的sectionModel
-(void)saveSectionModelFinishedDateWithSectionModel:(SectionModel*)section withLessonId:(NSString*)lessonId;//保存最近播放结束时间
-(void)addPlayTimeOffLineWithSectionId:(NSString*)sectionId withTimeForSecond:(NSString*)playTime;//追加离线播放时长
-(void)updatePlayDateOffLineWithSectionId:(NSString*)sectionId;//重新计算离线播放时间点
//-(NSString*)selectTotalPlayDateOffLineWithSectionId:(NSString*)sectionId;//计算第一次离线播放时间点＋离线播放时长
-(NSString*)selectTotalPlayTimeOffLineWithSectionId:(NSString*)sectionId;//查询总时间

-(SectionSaveModel *)getDataWithSid:(NSString *) sid;
-(SectionModel *)getSectionModelWithSid:(NSString *) sid;//获取信息
-(void)deleteDataWithSid:(NSString *) sid;//删除
-(BOOL)addDataWithSectionSaveModel:(SectionSaveModel *)model;
-(BOOL)updateTheStateWithSid:(NSString *) sid andDownloadState:(NSUInteger)downloadState;//更新下载状态信息
//-(BOOL)updateSectionModelLocalPath:(NSString*)localPath withSectionId:(NSString*)sectionId;//更新本地路径
//更新学习时间
-(BOOL)updateStudyTime:(NSString *)sectionStudy BySid:(NSString *)sid;
-(int)HasTheDataDownloadWithSid:(NSString *)sid;//判断是否下载完成
//TODO 判断下载状态 将下载状态改为暂停状态2 同时在启动的时候将状态改为2暂停。
-(BOOL)updatePercentDown:(double)length BySid:(NSString *)sid;//更新下载大小
-(float)getPercentDownBySid:(NSString *)sid;
-(float)getContentLengthBySid:(NSString *)sid ;//获取文章长度
-(BOOL)updateContentLength:(double)length BySid:(NSString *)sid;//更新文章的长度大小

-(NSArray *)getAllInfo;
-(NSArray *)getAllSection;
//笔记
-(BOOL)addDataWithNoteModel:(NoteModel *)model andSid:(NSString *)sid;
-(void)deleteDataFromNoteWithSid:(NSString *)sid;
-(NSArray *)getNoteInfoWithSid:(NSString *)sid;
//章节目录
-(BOOL)addDataWithSectionModel:(Section_chapterModel *)model andSid:(NSString *)sid;
-(void)deleteDataFromChapterWithSid:(NSString *)sid;
-(NSArray *)getChapterInfoWithSid:(NSString *)sid;
//清除缓存
+(void)clearAllDownloadedSectionWithSuccess:(void(^)())success withFailure:(void(^)(NSString*errorString))failure;
@end
