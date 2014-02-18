//
//  BaseDao.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseDao.h"
#import <sys/xattr.h>

@implementation BaseDao

-(id)init
{
    if (self = [super init]) {
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSFileManager *filemgr =[NSFileManager defaultManager];
        
        if (platform>5.0) {
            
            //如果系统是5.0.1及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:newDir]];
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"caijingtong.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
            self.dbPath = dbPath;
        }else{
            
            //如果系统是5.0及其以下这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"caijingtong.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
            self.dbPath = dbPath;
        }
        
        if (![self.db open]) {
            // NSLog(@"Could not open db.");
            self.db = nil;
        }
        
        //创建表section
        FMResultSet *rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'Section'"];
        
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE Section (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , sid VARCHAR ,lessonId VARCHAR, name VARCHAR,fileUrl VARCHAR,playUrl VARCHAR,localFileUrl VARCHAR, downloadState INTEGER,contentLength DOUBLE,percentDown FLOAT,sectionStudy VARCHAR,sectionLastTime VARCHAR,sectionImg VARCHAR,lessonInfo VARCHAR,sectionTeacher VARCHAR,sectionFinishedDate  VARCHAR,firstPlayOfflineDate VARCHAR,totalPlayOfflineTime VARCHAR)"];
        }
        
        [rs close];
        //创建section章节目录表
        rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'Chapter'"];
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE Chapter (id INTEGER PRIMARY KEY  NOT NULL , sid VARCHAR, name VARCHAR, sectionId VARCHAR, sectionDownload VARCHAR, sectionLastTime VARCHAR)"];
        }
        
        [rs close];
        
        //创建资料表
        rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'LearningMaterials'"];
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE LearningMaterials (id INTEGER PRIMARY KEY  NOT NULL , userId VARCHAR,materialId VARCHAR,materialName VARCHAR,fileName VARCHAR, fileCategoryId VARCHAR,fileLocalPath VARCHAR,fileDownloadUrl VARCHAR,fileDownloadStatus VARCHAR,fileCreateDate VARCHAR,fileCategoryName VARCHAR,fileType INTEGER, fileSearchCount VARCHAR,fileSize VARCHAR)"];
        }
        
        [rs close];
        
        //创建section笔记表
        rs = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'Note'"];
        if (![rs next]) {
            [rs close];
            [self.db executeUpdate:@"CREATE TABLE Note (id INTEGER PRIMARY KEY  NOT NULL , sid VARCHAR, noteId VARCHAR, noteTime VARCHAR, noteText VARCHAR)"];
        }
        
        [rs close];
 
    }
    NSLog(@"%@",self.dbPath);
    return self;
}
//添加不用备份的属性5.0.1
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{

    if (platform>=5.1) {//5.1的阻止备份
        
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
            //NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
        }
        return success;
    }else if (platform>5.0 && platform<5.1){//5.0.1的阻止备份
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return YES;
}

@end
