//
//  DownloadDataButton.h
//  ASIHttpRequest
//
//  Created by david on 14-1-8.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest+DownloadData.h"
#import "ASINetworkQueue+StaticQueues.h"
#import "LearningMaterials.h"
//下载进度
#define DownloadDataButton_Notification_Progress @"DownloadDataButton_Notification_Progress"
//下载完成时通知
#define DownloadDataButton_Notification_DidFinished @"DownloadDataButton_Notification_DidFinished"
//开始下载时通知
#define DownloadDataButton_Notification_DidStartDownload @"DownloadDataButton_Notification_DidStartDownload"

#define DownloadDataButton_Notification_Failure @"DownloadDataButton_Notification_Failure"

#define DownloadDataButton_Notification_Pause @"DownloadDataButton_Notification_Pause"

#define DownloadDataButton_Notification_Cancel @"DownloadDataButton_Notification_Cancel"

#define DownloadDataButton_Notification_DownloadButtonClicked @"DownloadDataButton_Notification_DownloadButtonClicked"
/*
 实现文件下载功能
 */

@interface DownloadDataButton : UIButton<UIAlertViewDelegate>
@property (strong,nonatomic,readonly) NSString *localPath;
@property (assign,nonatomic) DownloadStatus downloadFileStatus;//文件下载状态

-(void)setDownloadUrl:(NSURL*)url withDownloadStatus:(DownloadStatus)status withIsPostNotification:(BOOL)isPost;
-(void)setDownloadLearningMaterial:(LearningMaterials*)learningMaterial withDownloadStatus:(DownloadStatus)status withIsPostNotification:(BOOL)isPost;
@end
