//
//  Section.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section.h"

@implementation Section

-(SectionSaveModel *)getDataWithSid:(NSString *) sid {
    FMResultSet * rs = [self.db executeQuery:@"select id , sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime from Section where sid = ?",sid];
    
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

-(BOOL)addDataWithSectionSaveModel:(SectionSaveModel *)model {
    BOOL res = [self.db executeUpdate:@"insert into Section ( sid , name , fileUrl , downloadState ,contentLength,percentDown,sectionStudy,sectionLastTime) values (?,?,?,?,?,?,?,?)"
                , model.sid
                ,model.name
                ,model.fileUrl
                ,@"0"
                ,[NSString stringWithFormat:@"%f", model.downloadPercent],@"0",@"0",model.sectionLastTime];
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
@end
