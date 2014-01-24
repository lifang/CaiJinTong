//
//  Section.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section.h"
#import "ASIHTTPRequest+DownloadData.h"
@interface Section()
+(SectionModel*)convertToSectionModelFromResult:(FMResultSet*)rs;
@end

@implementation Section
static Section *defaultSection = nil;
+(Section*)defaultSection{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultSection = [[Section alloc] init];
    });
    return defaultSection;
}

#pragma mark 学习资料

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
/**
 *return
  0:未下载，1没有下载完成，2下载完成,3暂停
 */
-(DownloadStatus)searchLearningMaterialsDownloadStatusWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId{
    if (!materialId || !userId) {
        return DownloadStatus_UnDownload;
    }
    FMResultSet * rs = [self.db executeQuery:@"select fileDownloadStatus from LearningMaterials where userId = ? and materialId = ?",userId,materialId];
    NSString *path = nil;
    if ([rs next]) {
        
        path = [rs stringForColumn:@"fileDownloadStatus"];
    }
    
    [rs close];
    return [Section convertDownloadStatusFromString:path];
}

-(BOOL)deleteAllLearningMaterial{
    return  [self.db executeUpdate:@"delete from LearningMaterials "];
}

-(NSArray*)searchAllDownloadMaterialsWithwithUserId:(NSString*)userId{
    if (!userId) {
        return nil;
    }
    NSMutableArray *materialsArr = [NSMutableArray array];
    FMResultSet * rs = [self.db executeQuery:@"select * from LearningMaterials where userId = ? and fileDownloadStatus = 2",userId];
    while ([rs next]) {
        LearningMaterials *material  = [Section convertLearningMaterialsFromResultSet:rs];
        [materialsArr addObject:material];
    }
    
    [rs close];
    return materialsArr;

}

-(NSString*)searchLearningMaterialsLocalPathWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId{
    if (!materialId || !userId) {
        return nil;
    }
    FMResultSet * rs = [self.db executeQuery:@"select fileLocalPath from LearningMaterials where userId = ? and materialId = ?",userId,materialId];
    NSString *path = nil;
    if ([rs next]) {

        path = [rs stringForColumn:@"fileLocalPath"];
    }
    
    [rs close];
    return path;
}

+(LearningMaterials*)convertLearningMaterialsFromResultSet:(FMResultSet*)rs{
    LearningMaterials *material  = [[LearningMaterials alloc] init];
    material.materialId = [rs stringForColumn:@"materialId"];
    material.materialName = [rs stringForColumn:@"materialName"];
    material.materialLessonCategoryId = [rs stringForColumn:@"fileCategoryId"];
    material.materialLessonCategoryName = [rs stringForColumn:@"fileCategoryName"];
    material.materialFileSize = [rs stringForColumn:@"fileSize"];
    material.materialFileType = [Section convertMaterialFileTypeFromInteger:[rs intForColumn:@"fileType"]];
    material.materialFileDownloadStaus = [Section convertDownloadStatusFromString:[rs stringForColumn:@"fileDownloadStatus"]];
    material.materialSearchCount = [rs stringForColumn:@"fileSearchCount"];
    material.materialCreateDate = [rs stringForColumn:@"fileCreateDate"];
    material.materialFileDownloadURL = [rs stringForColumn:@"fileDownloadUrl"];
    material.materialFileLocalPath = [rs stringForColumn:@"fileLocalPath"];
    return material;
}

-(LearningMaterials*)searchLearningMaterialsWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId{
    if (!materialId || !userId) {
        return nil;
    }
    FMResultSet * rs = [self.db executeQuery:@"select * from LearningMaterials where userId = ? and materialId = ?",userId,materialId];
    LearningMaterials *material  = nil;
    if ([rs next]) {
        material = [Section convertLearningMaterialsFromResultSet:rs];
    }
    
    [rs close];
    return material;
}

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
-(void)addLeariningMaterial:(LearningMaterials*)materials withUserId:(NSString*)userId{
    if (!materials || !userId) {
        return;
    }
    if (![[Section defaultSection] isExistForMaterialId:materials.materialId withUserId:userId]) {
        [self.db executeUpdate:@"insert into LearningMaterials (userId,materialId,materialName,fileName,fileCategoryId,fileLocalPath,fileDownloadUrl,fileDownloadStatus,fileCreateDate,fileCategoryName,fileType,fileSearchCount,fileSize) values (?,?,?,?,?,?,?,?,?,?,?,?,?)"
         ,userId?:@""
         ,materials.materialId?:@""
         ,materials.materialName?:@""
         ,@"fileName"
         ,materials.materialLessonCategoryId?:@""
         ,materials.materialFileLocalPath?:@""
         ,materials.materialFileDownloadURL?:@""
         ,[Section convertDownloadStatusFromStatus:materials.materialFileDownloadStaus]
         ,materials.materialCreateDate?:@""
         ,materials.materialLessonCategoryName?:@""
         ,[Section convertMaterialFileTypeFromFileType:materials.materialFileType]
         ,materials.materialSearchCount?:@""
         ,materials.materialFileSize?:@""];
    }
}

-(BOOL)isExistForMaterialId:(NSString*)materialId withUserId:(NSString*)userId{
    if (!materialId || !userId) {
        return NO;
    }
    FMResultSet * rs = [self.db executeQuery:@"select id from LearningMaterials where userId = ? and materialId = ?",userId,materialId];
    if (rs.next) {
        [rs close];
        return YES;
    }
    return NO;
}

-(void)updateLeariningMaterial:(LearningMaterials*)materials withUserId:(NSString*)userId{
    if (!materials || !userId) {
        return;
    }
    if ([[Section defaultSection] isExistForMaterialId:materials.materialId withUserId:userId]) {
        [self.db executeUpdate:@"update LearningMaterials set fileLocalPath = ?,fileDownloadStatus = ? where userId = ? and materialId = ?",materials.materialFileLocalPath,[Section convertDownloadStatusFromStatus:materials.materialFileDownloadStaus],userId,materials.materialId];
    }else{
        [[Section defaultSection] addLeariningMaterial:materials withUserId:userId];
    }
}

-(void)deleteLeariningMaterialWithMaterialId:(NSString*)materialId withUserId:(NSString*)userId{
    BOOL res = [self.db executeUpdate:@"delete from LearningMaterials where userId = ? and materialId = ?",userId,materialId];
    if (!res) {
        DLog(@"删除失败!");
    } else {
        DLog(@"删除成功");
    }
}

#pragma mark --

-(SectionSaveModel *)getDataWithSid:(NSString *) sid {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher from Section where sid = ?",sid];
    
    SectionSaveModel *nm = nil;
    
    if ([rs next]) {
        nm = [[SectionSaveModel alloc] init];
        nm.sid = [rs stringForColumn:@"sid"];
        nm.name = [rs stringForColumn:@"name"];
        nm.fileUrl = [rs stringForColumn:@"fileUrl"];
        nm.downloadState = [rs intForColumn:@"downloadState"];
        nm.downloadPercent = [rs doubleForColumn:@"percentDown"];//获取下载进度
        nm.sectionStudy = [rs stringForColumn:@"sectionStudy"];
        nm.sectionLastTime = [rs stringForColumn:@"sectionLastTime"];
        
        nm.sectionImg = [rs stringForColumn:@"sectionImg"];
        nm.lessonInfo = [rs stringForColumn:@"lessonInfo"];
        nm.sectionTeacher = [rs stringForColumn:@"sectionTeacher"];
    }
    
    [rs close];
    return nm;
}

-(SectionModel *)getSectionModelWithSid:(NSString *) sid {
    FMResultSet * rs = [self.db executeQuery:@"select * from Section where sid = ?",sid];
    
    SectionModel *nm = nil;
    
    if ([rs next]) {
        nm = [Section convertToSectionModelFromResult:rs];
    }
    
    [rs close];
    return nm;
}
-(void)deleteDataWithSid:(NSString *)sid {
    BOOL res = [self.db executeUpdate:@"delete from Section where sid = ?",sid];
    
    if (!res) {
        DLog(@"删除失败!");
    } else {
        DLog(@"删除成功");
    }
}

-(BOOL)addDataWithSectionSaveModel:(SectionSaveModel *)model{
    BOOL res = [self.db executeUpdate:@"insert into Section ( sid , lessonId,name , fileUrl ,playUrl, localFileUrl,downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher,sectionFinishedDate,firstPlayOfflineDate,totalPlayOfflineTime) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                , model.sid
                ,model.lessonId
                ,model.name
                ,model.fileUrl
                ,model.playUrl
                ,model.localFileUrl
                ,@"0"
                ,[NSString stringWithFormat:@"%f", model.downloadPercent]
                ,@"0"
                ,@"0"
                ,model.sectionLastTime
                ,model.sectionImg
                ,model.lessonInfo
                ,model.sectionTeacher
                ,@""
                ,@"0"
                ,@"0"];
    return res;
}

-(BOOL)updateSectionModelLocalPath:(NSString*)localPath withSectionId:(NSString*)sectionId{
    if (!localPath || sectionId) {
        return NO;
    }
    return [self.db executeUpdate:@"update Section set localFileUrl = ? where sid= ?",localPath, sectionId];
}

-(BOOL)updateTheStateWithSid:(NSString *) sid andDownloadState:(NSUInteger)downloadState {
    return [self.db executeUpdate:@"update Section set downloadState = ? where sid= ?",[NSString stringWithFormat:@"%d", downloadState], sid];
}
-(int)HasTheDataDownloadWithSid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select downloadState from Section where sid = ?",sid];
    
    NSUInteger down = 4;//未下载状态
    if ([rs next]) {
        down = [rs intForColumn:@"downloadState"];
    }
    [rs close];
    
    return down;//4 未下载 1 下载完成 2 下载暂停
}
-(BOOL)updatePercentDown:(double)length BySid:(NSString *)sid {
    return [self.db executeUpdate:@"update Section set percentDown = ? where sid= ?",[NSString stringWithFormat:@"%lf", length], sid];
}

-(void)addPlayTimeOffLineWithSectionId:(NSString*)sectionId withTimeForSecond:(NSString*)playTime{//追加离线播放时长
    if (!sectionId || !!playTime) {
        return;
    }
    NSString *totalTime = nil;
    FMResultSet * rs = [self.db executeQuery:@"select totalPlayOfflineTime from Section where sid = ?",sectionId];
    if (rs.next) {
        totalTime = [rs stringForColumn:@"totalPlayOfflineTime"];
    }
    [self.db executeUpdate:@"update Section set totalPlayOfflineTime = ? where sid= ?",[NSString stringWithFormat:@"%d",totalTime.intValue + playTime.intValue], sectionId];
}
-(void)updatePlayDateOffLineWithSectionId:(NSString*)sectionId{//重新计算离线播放时间点
    if (!sectionId) {
        return;
    }
    [self.db executeUpdate:@"update Section set totalPlayOfflineTime = ?,firstPlayOfflineDate = ? where sid= ?",@"0", [Utility getNowDateFromatAnDate],sectionId];
}
-(NSString*)selectTotalPlayDateOffLineWithSectionId:(NSString*)sectionId{//计算第一次离线播放时间点＋离线播放时长
//     firstPlayOfflineDate VARCHAR,totalPlayOfflineTime VARCHAR
    if (!sectionId) {
        return nil;
    }
    NSString *totalTime = nil;
     NSString *offlineDate = nil;
    FMResultSet * rs = [self.db executeQuery:@"select totalPlayOfflineTime,firstPlayOfflineDate from Section where sid = ?",sectionId];
    if (rs.next) {
        totalTime = [rs stringForColumn:@"totalPlayOfflineTime"];
        offlineDate = [rs stringForColumn:@"firstPlayOfflineDate"];
    }
    if (offlineDate && totalTime) {
        NSDate *offDate = [Utility getDateFromDateString:offlineDate];
        NSDate *lastDate = [offDate dateByAddingTimeInterval:totalTime.intValue];
        offlineDate = [Utility getStringFromDate:lastDate];
    }
    return offlineDate;
}

-(NSString*)selectTotalPlayTimeOffLineWithSectionId:(NSString*)sectionId{//计算第一次离线播放时间点＋离线播放时长
    //     firstPlayOfflineDate VARCHAR,totalPlayOfflineTime VARCHAR
    if (!sectionId) {
        return nil;
    }
    NSString *totalTime = nil;
    FMResultSet * rs = [self.db executeQuery:@"select totalPlayOfflineTime from Section where sid = ?",sectionId];
    if (rs.next) {
        totalTime = [rs stringForColumn:@"totalPlayOfflineTime"];
    }
    return totalTime;
}

-(void)saveSectionModelFinishedDateWithSectionModel:(SectionModel*)section withLessonId:(NSString*)lessonId{
    if (!section) {
        return;
    }
     FMResultSet * rs = [self.db executeQuery:@"select sid from Section where sid = ?",section.sectionId];
    if (rs.next) {
        [self.db executeUpdate:@"update Section set sectionFinishedDate = ?,sectionStudy=? where sid= ?",section.sectionFinishedDate,section.sectionLastPlayTime, section.sectionId];
    }else{
       
        [self.db executeUpdate:@"insert into Section ( sid , lessonId,name , fileUrl ,playUrl, localFileUrl,downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher,sectionFinishedDate,firstPlayOfflineDate,totalPlayOfflineTime) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
         , section.sectionId
         ,lessonId?:@""
         ,section.sectionName
         ,section.sectionMovieDownloadURL
         ,section.sectionMoviePlayURL
         ,section.sectionMovieLocalURL?:@""
         ,@"0"
         ,@"0"
         ,@"0"
         ,section.sectionLastPlayTime
         ,@""
         ,@""
         ,@""
         ,@""
         ,section.sectionFinishedDate
         ,@"0"
         ,@"0"];
    }
}


//更新学习时间
-(BOOL)updateStudyTime:(NSString *)sectionStudy BySid:(NSString *)sid {
    return [self.db executeUpdate:@"update Section set sectionStudy = ? where sid= ?",sectionStudy, sid];
}

-(float)getPercentDownBySid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select percentDown,downloadState from Section where sid = ?",sid];
    
    float downloadPercent = 0;
    if ([rs next]) {
        
        downloadPercent = [rs doubleForColumn:@"percentDown"];//获取下载进度
        
    }
    
    return downloadPercent;
}
-(float)getContentLengthBySid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select downloadState ,contentLength from Section where sid = ?", sid];
    
    float downloadPercent = 0;
    if ([rs next]) {
        
        downloadPercent = [rs doubleForColumn:@"contentLength"];
    }
    
    [rs close];
    return downloadPercent;
}
-(BOOL)updateContentLength:(double)length BySid:(NSString *)sid {
    return [self.db executeUpdate:@"update Section set contentLength = ? where sid= ?",[NSString stringWithFormat:@"%f", length],sid];
}

//清理所有缓存
+(void)clearAllDownloadedSectionWithSuccess:(void(^)())success withFailure:(void(^)(NSString*errorString))failure{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    //清除下载的视频
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    ASINetworkQueue *queue = mDownloadService.networkQueue;
    [(NSOperationQueue*)queue cancelAllOperations];
    for (SectionModel *sectionModel in [[Section defaultSection] getAllSection]) {
        NSString *path = [CaiJinTongManager getMovieLocalPathWithSectionID:sectionModel.sectionId];
        if ([fileManager isExecutableFileAtPath:path] && [fileManager fileExistsAtPath:path]) {
            if (error) {
                [fileManager removeItemAtPath:path error:nil];
            }else{
                [fileManager removeItemAtPath:path error:&error];
            }
        }
        [[Section defaultSection] deleteDataWithSid:sectionModel.sectionId];
    }
    
    //清除下载的资料
    NSError *materialError = nil;
    UserModel *user = [[CaiJinTongManager shared] user];
    NSArray *allMaterialArr = [[Section defaultSection] searchAllDownloadMaterialsWithwithUserId:user.userId];
    for (LearningMaterials *material in allMaterialArr) {
        NSString *path = material.materialFileLocalPath;
        if (path) {
            if ([fileManager isExecutableFileAtPath:path] && [fileManager fileExistsAtPath:path]) {
                if (materialError) {
                    [fileManager removeItemAtPath:path error:nil];
                }else{
                    [fileManager removeItemAtPath:path error:&materialError];
                }
            }
        }
    }
    
    BOOL deleteIsSuccess = [[Section defaultSection] deleteAllLearningMaterial];
    
    if (error || materialError || !deleteIsSuccess) {
        failure(@"清除缓存时发生错误");
    }else{
        success();
    }
}


-(NSArray *)getAllInfo {
    FMResultSet * rs = [self.db executeQuery:@"select * from Section where downloadState ＝ 1"];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        [array addObject:[Section convertToSectionModelFromResult:rs]];
    }
    [rs close];
    return array;
}

-(SectionModel*)searchLastPlaySectionModelWithLessonId:(NSString*)lessonId{//获取最近播放的sectionModel
    if (!lessonId) {
        return nil;
    }
    FMResultSet * rs = [self.db executeQuery:@"select * from Section where lessonId =?",lessonId];
    SectionModel *resultModel = nil;
    while ([rs next]) {
        NSString *lastDateString = [rs stringForColumn:@"sectionFinishedDate"];
        if ([lastDateString isEqualToString:@""]) {
            continue;
        }
        if (!resultModel) {
            resultModel = [Section convertToSectionModelFromResult:rs];
        }
        NSDate *tempDate = [Utility getDateFromDateString:lastDateString];
        NSDate *lastDate = [Utility getDateFromDateString:resultModel.sectionFinishedDate];
        
        if ([tempDate compare:lastDate] == NSOrderedDescending) {
            resultModel = [Section convertToSectionModelFromResult:rs];
        }
    }
    [rs close];
    return resultModel;
}

+(SectionModel*)convertToSectionModelFromResult:(FMResultSet*)rs{
    SectionModel *nm = [[SectionModel alloc] init];
    nm.sectionId = [rs stringForColumn:@"sid"];
    nm.lessonId = [rs stringForColumn:@"lessonId"];
    nm.sectionName = [rs stringForColumn:@"name"];
    nm.sectionMovieDownloadURL = [rs stringForColumn:@"fileUrl"];//下载地址
    nm.sectionMoviePlayURL = [rs stringForColumn:@"playUrl"];//在线播放地址
    nm.sectionMovieLocalURL = [rs stringForColumn:@"localFileUrl"];//本地地址
    nm.sectionLastPlayTime = [rs stringForColumn:@"sectionStudy"];//已经学习时间
    nm.sectionLastTime = [rs stringForColumn:@"sectionLastTime"];//视频总长度
    nm.sectionImg = [rs stringForColumn:@"sectionImg"];
    nm.lessonInfo = [rs stringForColumn:@"lessonInfo"];
    nm.sectionTeacher = [rs stringForColumn:@"sectionTeacher"];
    nm.sectionFinishedDate = [rs stringForColumn:@"sectionFinishedDate"];
    return nm;
}

-(NSArray *)getAllSection {
    FMResultSet * rs = [self.db executeQuery:@"select sid from Section"];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        [array addObject:[Section convertToSectionModelFromResult:rs]];
    }
    [rs close];
    return array;
}
-(NSArray *)getDowningInfo {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher from Section where downloadState = 0"];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        SectionSaveModel *nm = [[SectionSaveModel alloc] init];
        nm.sid = [rs stringForColumn:@"sid"];
        nm.name = [rs stringForColumn:@"name"];
        nm.downloadState = [rs doubleForColumn:@"downloadState"];
        [array addObject:nm];
    }
    [rs close];
    return array;
}
//笔记
-(BOOL)addDataWithNoteModel:(NoteModel *)model andSid:(NSString *)sid{
    BOOL res = [self.db executeUpdate:@"insert into Note ( sid , noteId , noteTime , noteText) values (?,?,?,?)"
                ,sid
                ,model.noteId
                ,model.noteTime
                ,model.noteText  ];
    return res;
}

-(void)deleteDataFromNoteWithSid:(NSString *)sid {
    BOOL res = [self.db executeUpdate:@"delete from Note where sid = ?",sid];
    
    if (!res) {
        DLog(@"删除失败!");
    } else {
        DLog(@"删除成功");
    }
}
-(NSArray *)getNoteInfoWithSid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , noteId , noteTime , noteText from Note where sid = ?",sid];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        NoteModel *nm = [[NoteModel alloc] init];
        nm.noteId = [rs stringForColumn:@"noteId"];
        nm.noteTime = [rs stringForColumn:@"noteTime"];
        nm.noteText = [rs stringForColumn:@"noteText"];
        [array addObject:nm];
    }
    [rs close];
    return array;
}
//章节目录
-(BOOL)addDataWithSectionModel:(Section_chapterModel *)model andSid:(NSString *)sid {
    BOOL res = [self.db executeUpdate:@"insert into Chapter ( sid , name, sectionId, sectionDownload, sectionLastTime) values (?,?,?,?,?)"
                ,sid
                ,model.sectionName
                ,model.sectionId
                ,model.sectionDownload
                ,model.sectionLastTime];
    return res;
}
-(void)deleteDataFromChapterWithSid:(NSString *)sid {
    BOOL res = [self.db executeUpdate:@"delete from Chapter where sid = ?",sid];
    
    if (!res) {
        DLog(@"删除失败!");
    } else {
        DLog(@"删除成功");
    }
}
-(NSArray *)getChapterInfoWithSid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , sectionId , sectionDownload , sectionLastTime from Chapter where sid = ?",sid];
    
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        Section_chapterModel *nm = [[Section_chapterModel alloc] init];
        nm.sectionId = [rs stringForColumn:@"sectionId"];
        nm.sectionName = [rs stringForColumn:@"name"];
        nm.sectionDownload = [rs stringForColumn:@"sectionDownload"];
        nm.sectionLastTime = [rs stringForColumn:@"sectionLastTime"];
        [array addObject:nm];
    }
    [rs close];
    return array;
}
@end
