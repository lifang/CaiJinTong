//
//  DownloadService.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "DownloadService.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "Section.h"

@implementation DownloadService

- (id)init {
    self = [super init];
    if (self) {
        [[self networkQueue] cancelAllOperations];
        self.networkQueue = [ASINetworkQueue queue];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:NO];
        [self.networkQueue setDelegate:self];
        [self.networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
        [self.networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
//        [self.networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        [self.networkQueue setShowAccurateProgress:YES];
//        [self.networkQueue setDownloadProgressDelegate:self];
        [self.networkQueue setMaxConcurrentOperationCount:5];
        [self.networkQueue go];
    }
    return self;
}

//添加下载任务
-(void)addDownloadTask:(SectionModel *)section{
    if (!section) {
        return;
    }

    //判断当前下载任务是否已经在下载队列中
    NSArray *requestArray = self.networkQueue.operations;
    for (NSOperation *oper in requestArray) {
        ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
        if ([section.sectionId isEqualToString:[request.userInfo objectForKey:@"sectionId"]]) {
            //当前任务正在执行，取消本次操作
            // 考虑是否需要发送nofification通知
            
            return;
        }
    }

    
    NSString *urlString = [NSString stringWithFormat:@"%@",section.sectionMovieDownloadURL];
    urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                      (CFStringRef)urlString,
                                                                                      NULL,
                                                                                      NULL,
                                                                                      kCFStringEncodingUTF8));
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:section , @"SectionSaveModel",section.sectionId,@"sectionId", nil];
    request.userInfo = userInfo;
    NSString *downloadPath = [CaiJinTongManager getMovieLocalPathWithSectionID:section.sectionId withSuffix:[section.sectionMovieDownloadURL pathExtension]];
    NSString *tempPath = [CaiJinTongManager getMovieLocalTempPathWithSectionID:[NSString stringWithFormat:@"temp_%@",section.sectionId]];
    [request setDownloadDestinationPath:downloadPath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
//    [request setDownloadProgressDelegate:self];
    request.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
    [request setShowAccurateProgress:YES];
    
    [[self networkQueue] addOperation:request];
    
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionMovieLocalURL = downloadPath;
    section.sectionMovieFileDownloadStatus = DownloadStatus_Downloading;
    [DRFMDBDatabaseTool insertLessonTreeDatasWithUserId:user.userId withLesson:[CaiJinTongManager shared].lesson withFinished:^(BOOL flag) {
        [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_Downloading withFinished:^(BOOL flag) {
            [DRFMDBDatabaseTool updateSectionMovieLocalPathWithUserId:user.userId withSectionId:section.sectionId  withLocalPath:downloadPath withFinished:^(BOOL flag) {
                //发送开始下载通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStart" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
            }];
            
        }];
    }];
    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) {
        UserModel *user = [CaiJinTongManager shared].user;
        section.sectionFileDownloadSize = [NSString stringWithFormat:@"%llu",size];
        section.sectionFileTotalSize = [NSString stringWithFormat:@"%llu",total];
        [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withFileDownloadSize:[NSString stringWithFormat:@"%llu",size] withFinished:^(BOOL flag) {
            if (flag) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
            }
        }];
    }];
}


//- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes{
//    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
//    UserModel *user = [CaiJinTongManager shared].user;
//    section.sectionFileDownloadSize = [NSString stringWithFormat:@"%llu",request.totalBytesRead];
//    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withFileDownloadSize:[NSString stringWithFormat:@"%llu",request.totalBytesRead] withFinished:^(BOOL flag) {
//        if (flag) {
//            //发送通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
//        }
//    }];
//}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    long long contentLenth = [[responseHeaders objectForKey:@"Content-Length"]longLongValue];
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionFileTotalSize = [NSString stringWithFormat:@"%llu",contentLenth];
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withFileTotalSize:[NSString stringWithFormat:@"%llu",contentLenth] withFinished:^(BOOL flag) {
        if (flag) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
        }
    }];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //更新数据库
    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    section.sectionMovieFileDownloadStatus = DownloadStatus_Downloaded;
    UserModel *user = [CaiJinTongManager shared].user;
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_Downloaded withFinished:^(BOOL flag) {
        if (flag) {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
        }
    }];
    [[AppDelegate sharedInstance].appButtonModelArray removeObject:section];
}
//根据VideoSaveModel删除下载任务
-(void)removeTask:(SectionModel *)section{
    //判断当前下载任务是否已经在下载队列中
    if ([self.networkQueue requestsCount] > 0) {
        NSArray *requestArray = self.networkQueue.operations;
        for (NSOperation *oper in requestArray) {
            ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
            if ([section.sectionId isEqualToString:[[request.userInfo objectForKey:@"SectionSaveModel"] sectionId]]) {
                //当前任务正在执行，取消本次操作
                //todo 考虑是否需要发送nofification通知
                [request clearDelegatesAndCancel];
                request = nil;
                
                // return;
            }
        }
    }
    
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionMovieFileDownloadStatus = DownloadStatus_UnDownload;
    section.sectionFileDownloadSize = nil;
    section.sectionFileTotalSize = nil;
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_UnDownload withFinished:^(BOOL flag) {
        if (flag) {
            //删除Document下的残留
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentDir;
            if (platform>5.0) {
                documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            }else{
                documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            }
            
            NSString *downloadPath = [CaiJinTongManager getMovieLocalPathWithSectionID:section.sectionId withSuffix:[section.sectionMovieDownloadURL pathExtension]];
            NSString *tempPath = [CaiJinTongManager getMovieLocalTempPathWithSectionID:[NSString stringWithFormat:@"temp_%@",section.sectionId]];
            
            [fileManager removeItemAtPath:downloadPath error:nil];
            [fileManager removeItemAtPath:tempPath error:nil];
            //send notification
            
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDownLoad" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
    }];
}

//停止下载
-(void)stopTask:(SectionModel *)section{
    //判断当前下载任务是否已经在下载队列中
    if ([self.networkQueue requestsCount] > 0) {
        NSArray *requestArray = self.networkQueue.operations;
        for (NSOperation *oper in requestArray) {
            ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
            if ([section.sectionId isEqualToString:[[request.userInfo objectForKey:@"SectionSaveModel"] sectionId]]) {
                //当前任务正在执行，取消本次操作
                //todo 考虑是否需要发送nofification通知
                [request clearDelegatesAndCancel];
                request = nil;
            }
        }
    }
    
    //停止下载任务
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionMovieFileDownloadStatus = DownloadStatus_Pause;
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_Pause withFinished:^(BOOL flag) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownLoad" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
    }];
    
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    self.isFaild = YES;
    //更新数据库 下载失败
    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionMovieFileDownloadStatus = DownloadStatus_Pause;
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_Pause withFinished:^(BOOL flag) {
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFailed" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
    }];
   
}

@end
