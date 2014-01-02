//
//  Section.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section.h"

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
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher from Section where sid = ?",sid];
    
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
    BOOL res = [self.db executeUpdate:@"insert into Section ( sid , lessonId,name , fileUrl ,playUrl, localFileUrl,downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher,sectionFinishedDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
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
                ,@""];
    return res;
}
-(BOOL)updateTheStateWithSid:(NSString *) sid andDownloadState:(NSUInteger)downloadState {
    return [self.db executeUpdate:@"update Section set downloadState = ? where sid= ?",[NSString stringWithFormat:@"%d", downloadState], sid];
}
-(int)HasTheDataDownloadWithSid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name ,fileUrl , downloadState ,contentLength from Section where sid = ?",sid];
    
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

-(void)saveSectionModelFinishedDateWithSectionModel:(SectionModel*)section withLessonId:(NSString*)lessonId{
    if (!section) {
        return;
    }
     FMResultSet * rs = [self.db executeQuery:@"select sid from Section where sid = ?",section.sectionId];
    if (rs.next) {
        [self.db executeUpdate:@"update Section set sectionFinishedDate = ?,sectionStudy=? where sid= ?",section.sectionFinishedDate,section.sectionLastPlayTime, section.sectionId];
    }else{
        [self.db executeUpdate:@"insert into Section ( sid , lessonId,name , fileUrl ,playUrl, localFileUrl,downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher,sectionFinishedDate) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
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
         ,section.sectionFinishedDate];
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
    if (error) {
        failure(@"清除缓存时发生错误");
    }else{
        success();
    }
}


-(NSArray *)getAllInfo {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime,sectionImg,lessonInfo,sectionTeacher from Section where downloadState ＝ 1"];
    
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
