//
//  DownloadService.h
//  CaiJinTong
//
//  Created by comdosoft on 13-9-16.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionModel.h"
@class ASINetworkQueue;
@interface DownloadService : NSObject
@property (nonatomic) BOOL isFaild;
@property (nonatomic,retain) ASINetworkQueue *networkQueue;
@property (nonatomic, assign) long long spaceOfDownloadingFiles; //正在下载的文件的总大小

-(void)addDownloadTask:(SectionModel *)section;//添加下载任务
-(void)removeTask:(SectionModel *)section;//根据VideoSaveModel删除下载任务
-(void)stopTask:(SectionModel *)section;//停止下载
@end
