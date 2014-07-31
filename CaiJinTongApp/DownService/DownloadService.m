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

#define reservedSpace 205 * 1024 * 1024

@implementation DownloadService

- (id)init {
    self = [super init];
    if (self) {
        [[self networkQueue] cancelAllOperations];
        self.networkQueue = [ASINetworkQueue queue];
        [self.networkQueue setShouldCancelAllRequestsOnFailure:NO];
        [self.networkQueue setDelegate:self];
//        [self.networkQueue setRequestDidFailSelector:@selector(requestFailed:)];
//        [self.networkQueue setRequestDidFinishSelector:@selector(requestFinished:)];
        //        [self.networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        [self.networkQueue setShowAccurateProgress:YES];
        //        [self.networkQueue setDownloadProgressDelegate:self];
        [self.networkQueue setMaxConcurrentOperationCount:5];
        [self.networkQueue go];
        self.spaceOfDownloadingFiles = 0;
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
    
    NSString * urlString = [NSString stringWithFormat:@"%@",section.sectionMovieDownloadURL];
    urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                      (CFStringRef)urlString,
                                                                                      NULL,
                                                                                      NULL,
                                                                                      kCFStringEncodingUTF8));
    
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.delegate = self;
    
    NSString *downloadPath = [CaiJinTongManager getMovieLocalPathWithSectionID:section.sectionId withSuffix:[urlString pathExtension]];
    NSString *tempPath = [CaiJinTongManager getMovieLocalTempPathWithSectionID:[NSString stringWithFormat:@"temp_%@",section.sectionId]];
    [request setDownloadDestinationPath:downloadPath];//下载路径
    [request setTemporaryFileDownloadPath:tempPath];//缓存路径
    request.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
    [request setShowAccurateProgress:YES];
    section.sectionMovieLocalURL = downloadPath;
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:section , @"SectionSaveModel",section.sectionId,@"sectionId", nil];
    request.userInfo = userInfo;
    [[self networkQueue] addOperation:request];
    
    __weak ASIHTTPRequest *wRequest = request;
    
    [request setCompletionBlock:^{
        //更新数据库
        SectionModel *section= (SectionModel *)[[wRequest userInfo]objectForKey:@"SectionSaveModel"];
        NSLog(@"下载成功!!!!!!");
        
        UserModel *user = [CaiJinTongManager shared].user;
        
        //针对下载未完成就"finish"的状况
        DownloadStatus realStatus;
        if (section.sectionFileTotalSize.longLongValue > section.sectionFileDownloadSize.longLongValue) {
            realStatus = DownloadStatus_Pause;
        }else{
            realStatus = DownloadStatus_Downloaded;
        }
        section.sectionMovieFileDownloadStatus = realStatus;
        NSLog(@"totalSize = %llu ,downloadSize = %llu ,realStatus = %d" ,section.sectionFileTotalSize.longLongValue ,section.sectionFileDownloadSize.longLongValue ,realStatus);
        
        [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:realStatus withFinished:^(BOOL flag) {
            if (flag) {
                //发送通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
            }
        }];
        [[AppDelegate sharedInstance].appButtonModelArray removeObject:section];
    }];
    
    [request setBytesReceivedBlock:^(unsigned long long size, unsigned long long total) { //进度条回调
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

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    long long contentLenth = [[responseHeaders objectForKey:@"Content-Length"]longLongValue];
    UserModel *user = [CaiJinTongManager shared].user;
    section.sectionFileTotalSize = [NSString stringWithFormat:@"%llu",contentLenth];
    NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:section , @"SectionSaveModel",section.sectionId,@"sectionId", [NSString stringWithFormat:@"%llu",contentLenth] ,@"contentLength" , nil];
    request.userInfo = userInfo;
    
    //判断空间是否足够
    long long totalContentLength = 0;
    for (NSOperation *operation in self.networkQueue.operations){
        if (((ASIHTTPRequest *)operation).contentLength > 0){
            totalContentLength += ((ASIHTTPRequest *)operation).contentLength;
        }
    }
    if ([DownloadService freeDiskSpaceInBytes] - totalContentLength < reservedSpace) {
        //空间不足
        [Utility errorAlert:@"本机存储空间不足,请先清理"];
        AppDelegate *appDelegate = [AppDelegate sharedInstance];
        for (SectionModel *sectionModel in appDelegate.appButtonModelArray) {
            if ([sectionModel.sectionId isEqualToString:section.sectionId]) {
                [appDelegate.appButtonModelArray removeObject:sectionModel];
                break;
            }
        }
        [request clearDelegatesAndCancel];
        request = nil;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStart" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
        return;
    }
    
    section.sectionMovieFileDownloadStatus = DownloadStatus_Downloading;
    [DRFMDBDatabaseTool insertLessonTreeDatasWithUserId:user.userId withLesson:[CaiJinTongManager shared].lesson withFinished:^(BOOL flag) {
        [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withDownloadStatus:DownloadStatus_Downloading withFinished:^(BOOL flag) {
            [DRFMDBDatabaseTool updateSectionMovieLocalPathWithUserId:user.userId withSectionId:section.sectionId  withLocalPath:section.sectionMovieLocalURL withFinished:^(BOOL flag) {
                //发送开始下载通知
                [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStart" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
                [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId withSectionId:section.sectionId withFileTotalSize:[NSString stringWithFormat:@"%llu",contentLenth] withFinished:^(BOOL flag) {
                    if (flag) {
                        //发送通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
                    }
                }];
            }];
            
        }];
    }];
    
    
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    self.isFaild = YES;
    //更新数据库 下载失败
    SectionModel *section= (SectionModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    UserModel *user = [CaiJinTongManager shared].user;
    NSLog(@"下载失败 ,downloadStatus = %d ,error = %@" ,section.sectionMovieFileDownloadStatus ,request.error);
    if (section.sectionMovieFileDownloadStatus != DownloadStatus_UnDownload) {
        section.sectionMovieFileDownloadStatus = DownloadStatus_Pause;
    }
    [[AppDelegate sharedInstance].appButtonModelArray removeObject:section];
    [DRFMDBDatabaseTool updateSectionDownloadStatusWithUserId:user.userId
                                                withSectionId:section.sectionId
                                           withDownloadStatus:section.sectionMovieFileDownloadStatus
                                                 withFinished:^(BOOL flag) {
                                                     //发送通知
                                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFailed"
                                                                                                         object:self
                                                                                                       userInfo:[NSDictionary dictionaryWithObjectsAndKeys:section,@"SectionSaveModel",nil]];
                                                 }];
}

- (void)requestRedirected:(ASIHTTPRequest *)request{
    NSLog(@"请求重定向");
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

//获取设备剩余空间 (字节)
+ (long long)freeDiskSpaceInBytes{
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    return [[fattributes objectForKey:NSFileSystemFreeSize] longLongValue];
}

@end
