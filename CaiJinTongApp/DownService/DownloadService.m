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
        [self.networkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        [self.networkQueue setShowAccurateProgress:YES];
        [self.networkQueue setMaxConcurrentOperationCount:1];
        [self.networkQueue go];
    }
    return self;
}
//根据数据库里面的纪录，若下载完成返回nil，其他返回model
-(SectionSaveModel *)getdataFromDB:(SectionSaveModel *)nm {
    SectionSaveModel *sectionSave = nil;
    Section *sectionDb = [[Section alloc]init];
    sectionSave = [sectionDb getDataWithSid:nm.sid];
    if (sectionSave == nil) {
        sectionSave = [[SectionSaveModel alloc]init];
        //新添加下载任务
        sectionSave.sid = nm.sid;
        sectionSave.name = nm.name;
        sectionSave.fileUrl = nm.fileUrl;
        sectionSave.downloadState = 0;
        sectionSave.downloadPercent = nm.downloadPercent;
        sectionSave.sectionLastTime = nm.sectionLastTime;
        sectionSave.sectionStudy = @"0";
    }else {//0:下载中 1:下载完成 2:下载停止
        if (sectionSave.downloadState == 0) {
            //任务下载中
        }else if (sectionSave.downloadState == 1) {
            //下载完成
            sectionSave = nil;
        }else { //if (sectionSave.downloadState == 2)
            //下载停止
        }
    }
    return sectionSave;
}
//添加下载任务
-(void)addDownloadTask:(SectionSaveModel *) nm {
    if (nm) {
        SectionSaveModel *sectionSave = [self getdataFromDB:nm];
        if (sectionSave != nil) {
            //判断当前下载任务是否已经在下载队列中
            if ([self.networkQueue requestsCount] > 0) {
                NSArray *requestArray = self.networkQueue.operations;
                for (NSOperation *oper in requestArray) {
                    ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
                    if ([sectionSave.sid isEqualToString:[[request.userInfo objectForKey:@"SectionSaveModel"] sid]]) {
                        //当前任务正在执行，取消本次操作
                        // 考虑是否需要发送nofification通知
                        
                        return;
                    }
                }
            }
            NSString *urlString = [NSString stringWithFormat:@"%@",sectionSave.fileUrl];
            urlString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)urlString,
                                                                                              NULL,
                                                                                              NULL,
                                                                                              kCFStringEncodingUTF8));
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
            request.delegate = self;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:sectionSave , @"SectionSaveModel", nil];
            request.userInfo = userInfo;
            NSString *downloadPath = [CaiJinTongManager getMovieLocalPathWithSectionID:sectionSave.sid];
            NSString *tempPath = [CaiJinTongManager getMovieLocalTempPathWithSectionID:sectionSave.sid];
            [request setDownloadDestinationPath:downloadPath];//下载路径
            [request setDownloadProgressDelegate:sectionSave];//下载进度代理
            [request setTemporaryFileDownloadPath:tempPath];//缓存路径

            request.allowResumeForFileDownloads = YES;//打开断点，是否要断点续传
            [request setShowAccurateProgress:YES];
            
            [[self networkQueue] addOperation:request];
            
            //数据库更新
            Section *sectionDb = [[Section alloc]init];
            [sectionDb updateTheStateWithSid:sectionSave.sid andDownloadState:0];
//            [sectionDb updateSectionModelLocalPath:downloadPath withSectionId:sectionSave.sid];
            //发送开始下载通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadStart" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:sectionSave,@"SectionSaveModel",nil]];
        }
    }
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    SectionSaveModel *nm = (SectionSaveModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    float contentLenth = [[responseHeaders objectForKey:@"Content-Length"]floatValue];
    float length = contentLenth/1024/1024;
    //通知  更新progress
    Section *sectionDb = [[Section alloc]init];
    [sectionDb updateContentLength:length BySid:nm.sid];
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //更新数据库
    SectionSaveModel *nm = (SectionSaveModel *)[request.userInfo objectForKey:@"SectionSaveModel"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        nm.downloadState = 1;
       //数据库更新数据
        Section *sectionDb = [[Section alloc]init];
        [sectionDb updateTheStateWithSid:nm.sid andDownloadState:nm.downloadState];
        [sectionDb updatePercentDown:1 BySid:nm.sid];
        
        SectionSaveModel *nn = [sectionDb getDataWithSid:nm.sid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFinished" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:nn,@"SectionSaveModel",nil]];
            //... Handle success
            
        });
    });
}
//根据VideoSaveModel删除下载任务
-(void)removeTask:(SectionSaveModel *)nm {
    //判断当前下载任务是否已经在下载队列中
    if ([self.networkQueue requestsCount] > 0) {
        NSArray *requestArray = self.networkQueue.operations;
        for (NSOperation *oper in requestArray) {
            ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
            if ([nm.sid isEqualToString:[[request.userInfo objectForKey:@"SectionSaveModel"] sid]]) {
                //当前任务正在执行，取消本次操作
                //todo 考虑是否需要发送nofification通知
                [request clearDelegatesAndCancel];
                request = nil;
                
                // return;
            }
        }
    }
    //删除
//    [[Section defaultSection] updateTheStateWithSid:nm.sid andDownloadState:4];
    [[Section defaultSection] deleteDataWithSid:nm.sid];

    //删除Document下的残留
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDir;
    if (platform>5.0) {
        documentDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }else{
        documentDir = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    
    NSString *tmpFilePath = [documentDir stringByAppendingPathComponent:[NSString stringWithFormat:@"/Application/%@",nm.sid]];
    [fileManager removeItemAtPath:tmpFilePath error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.zip",tmpFilePath] error:nil];
    [fileManager removeItemAtPath:[NSString stringWithFormat:@"%@.temp",tmpFilePath] error:nil];
    //send notification
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeDownLoad" object:nil];
}

//停止下载
-(void)stopTask:(SectionSaveModel *)nm {
    //判断当前下载任务是否已经在下载队列中
    if ([self.networkQueue requestsCount] > 0) {
        NSArray *requestArray = self.networkQueue.operations;
        for (NSOperation *oper in requestArray) {
            ASIHTTPRequest *request = (ASIHTTPRequest *)oper;
            if ([nm.sid isEqualToString:[[request.userInfo objectForKey:@"SectionSaveModel"] sid]]) {
                //当前任务正在执行，取消本次操作
                //todo 考虑是否需要发送nofification通知
                [request clearDelegatesAndCancel];
                request = nil;
            }
        }
    }
    
    //停止下载任务
    Section *sectionDb = [[Section alloc]init];
    [sectionDb updateTheStateWithSid:nm.sid andDownloadState:2];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"stopDownLoad" object:nil];
}


- (void)requestFailed:(ASIHTTPRequest *)request {
    //更新数据库 下载失败
    SectionSaveModel *nm = (SectionSaveModel *)[[request userInfo]objectForKey:@"SectionSaveModel"];
    Section *sectionDb = [[Section alloc]init];
    [sectionDb updateTheStateWithSid:nm.sid andDownloadState:3];
    //发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadFailed" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:nm,@"SectionSaveModel",nil]];
}
- (void)queueFinished:(ASINetworkQueue *)queue {
    
}
@end
