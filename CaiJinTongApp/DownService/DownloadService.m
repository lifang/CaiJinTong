//
//  DownloadService.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "DownloadService.h"
//#import "VideoSaveModel.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@implementation DownloadService
@synthesize networkQueue = _networkQueue;

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
        [self.networkQueue go];
    }
    return self;
}
//添加下载任务
-(void)addDownloadTask:(VideoSaveModel *) nm {
    
}
//根据VideoSaveModel删除下载任务
-(void)removeTask:(VideoSaveModel *)nm {
    
}
//停止下载
-(void)stopTask:(VideoSaveModel *)nm {
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
}
- (void)requestFinished:(ASIHTTPRequest *)request {
    //更新数据库
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    //更新数据库 下载失败
}
- (void)queueFinished:(ASINetworkQueue *)queue {
    
}
@end
