//
//  DownloadDataButton.m
//  ASIHttpRequest
//
//  Created by david on 14-1-8.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DownloadDataButton.h"
#import "UpdateDownloadTimesInfo.h"
@interface DownloadDataButton()
@property (nonatomic,assign) long long fileTotalSize;
@property (nonatomic,strong) UIProgressView *progressView;
@property (strong,nonatomic) NSURL *downloadFileURL;//下载文件的地址
@property (assign,nonatomic) BOOL isPostNotification;//设置是否有通知事件
@property (strong,nonatomic) UIAlertView *alert;
@property (strong,nonatomic)  LearningMaterials *materialModel;
@end

@implementation DownloadDataButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
       
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)addTargetMethod{
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.progressView.frame = (CGRect){0,CGRectGetHeight(self.frame)-PAD(3, 5),CGRectGetWidth(self.frame),PAD(5, 4)};
    [self addTarget:self action:@selector(downloadBtClicked) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDateProgress:) name:DownloadDataButton_Notification_Progress object:nil];
}

-(void)setDownloadUrl:(NSURL*)url withDownloadStatus:(DownloadStatus)status withIsPostNotification:(BOOL)isPost{
//    NSArray *arr = [[ASINetworkQueue defaultDownloadLargeDataQueue] operations];
//    NSLog(@"%d",[arr count]);
    [self addTargetMethod];
    self.downloadFileStatus = status;
    if (self.downloadFileURL &&  ![self.downloadFileURL.absoluteString isEqualToString:url.absoluteString]) {
        [self pauseDownloadData];
        self.downloadFileStatus = DownloadStatus_Pause;
    }
    self.downloadFileURL = url;
    self.isPostNotification = isPost;
}


-(void)setDownloadLearningMaterial:(LearningMaterials*)learningMaterial withDownloadStatus:(DownloadStatus)status withIsPostNotification:(BOOL)isPost{
//    NSArray *arr = [[ASINetworkQueue defaultDownloadLargeDataQueue] operations];
//    NSLog(@"%d",[arr count]);
    self.materialModel = learningMaterial;
    [self addTargetMethod];
    self.downloadFileStatus = status;
    self.downloadFileURL = [NSURL URLWithString:learningMaterial.materialFileDownloadURL];
    self.isPostNotification = isPost;
}


-(void)updateDateProgress:(NSNotification*)notification{
    if ([[notification.userInfo objectForKey:URLKey] isEqualToString:self.downloadFileURL.absoluteString]) {
        NSNumber *size = [notification.userInfo objectForKey:URLReceiveDataSize];
        NSNumber *total = [notification.userInfo objectForKey:URLTotalDataSize];
        double value = (double)size.longLongValue/total.longLongValue;
        self.progressView.progress = value;
        NSLog(@"%@:%0.4f,%llu,%llu",self.downloadFileURL.absoluteString,value,size.longLongValue,total.longLongValue);
    }
}

-(void)startDownloadData{
    ASIHTTPRequest *que = [self getRequestFromQueueWithInfo:self.downloadFileURL.absoluteString];
    if (que) {
        return;
    }
    self.downloadFileStatus = DownloadStatus_Downloading;
    NSString *fileName = [self.downloadFileURL lastPathComponent];
    NSString *path = [[ASIHTTPRequest getLargeFileSavePath] stringByAppendingPathComponent:fileName];
    [[NSFileManager defaultManager]  removeItemAtPath:path error:nil];
    [[NSFileManager defaultManager]  removeItemAtPath:[[ASIHTTPRequest getLargeFileTempPath] stringByAppendingPathComponent:fileName] error:nil];
    _localPath = path;
    if (self.isPostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_DidStartDownload object:nil userInfo:@{URLKey: self.downloadFileURL.absoluteString?:@"",URLLocalPath:path?:@""}];
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithLargeDataURL:self.downloadFileURL];
    [request setDownloadDestinationPath:path];
    [request setTemporaryFileDownloadPath:[[ASIHTTPRequest getLargeFileTempPath] stringByAppendingPathComponent:fileName]];
    [request setDownloadProgressDelegate:self.progressView];
    [request setDidFinishSelector:@selector(requestDidFinished:)];
    [request setDidFailSelector:@selector(requestDidFailure:)];
    [request setDelegate:self];
    NSLog(@"%@",self.localPath);
    [[ASINetworkQueue defaultDownloadLargeDataQueue] addOperation:request];
}

-(void)continueDownloadData{
    ASIHTTPRequest *request = [self getRequestFromQueueWithInfo:self.downloadFileURL.absoluteString];
    if (request) {
        self.downloadFileStatus = DownloadStatus_Downloading;
        return;
    }else{
        [self startDownloadData];
    }
}

-(void)pauseDownloadData{
    self.downloadFileStatus = DownloadStatus_Pause;
    ASIHTTPRequest *request = [self getRequestFromQueueWithInfo:self.downloadFileURL.absoluteString];
    if (request) {
        [request setDelegate:nil];
        [request clearDelegatesAndCancel];
    }
    if (self.isPostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_Pause object:nil userInfo:@{URLKey: self.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@""}];
    }
}

-(void)cancelDownloadData{
    self.downloadFileStatus = DownloadStatus_UnDownload;
    ASIHTTPRequest *request = [self getRequestFromQueueWithInfo:self.downloadFileURL.absoluteString];
    if (request) {
        [request setDelegate:nil];
        [request clearDelegatesAndCancel];
    }
    self.progressView.progress = 0.0;
    [self.progressView removeFromSuperview];
    if (self.isPostNotification) {
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_Cancel object:nil userInfo:@{URLKey: self.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@""}];
    }
}


-(ASIHTTPRequest*)getRequestFromQueueWithInfo:(NSString*)info{
    ASINetworkQueue *queue = [ASINetworkQueue defaultDownloadLargeDataQueue];
    for (ASIHTTPRequest *request in queue.operations) {
        if ( info && [info isEqualToString:[request.userInfo objectForKey:URLKey]]) {
            return request;
        }
    }
    return nil;
}

-(void)downloadBtClicked{
    if (self.materialModel.materialFileType == LearningMaterialsFileType_zip || self.materialModel.materialFileType == LearningMaterialsFileType_other) {
        [Utility errorAlert:@"无法打开该文件，请到电脑上下载查看！"];
        return;
    }
    switch (self.downloadFileStatus) {
        case DownloadStatus_UnDownload:
        {
            [self startDownloadData];
            break;
        }
        case DownloadStatus_Downloading:
        {
            self.alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在下载中..." delegate:self cancelButtonTitle:nil otherButtonTitles:@"暂停下载",@"取消下载",@"取消", nil];
            self.alert.tag = DownloadStatus_Downloading;
            [self.alert show];
            break;
        }
        case DownloadStatus_Pause:
        {
            self.alert = [[UIAlertView alloc] initWithTitle:@"" message:@"是否继续下载" delegate:self cancelButtonTitle:nil otherButtonTitles:@"继续下载",@"取消", nil];
            self.alert.tag = DownloadStatus_Pause;
            [self.alert show];
            break;
        }
        case DownloadStatus_Downloaded:
        {
            break;
        }
            
        default:
            break;
    }
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (alertView.tag) {
        case DownloadStatus_UnDownload:
        {
            break;
        }
        case DownloadStatus_Downloading:
        {
            if (buttonIndex == 0) {
                [self pauseDownloadData];
            }
            if (buttonIndex == 1) {
                [self cancelDownloadData];
            }
            break;
        }
        case DownloadStatus_Pause:
        {
            if (buttonIndex == 0) {
                [self continueDownloadData];
            }
            break;
        }
        case DownloadStatus_Downloaded:
        {
            break;
        }
            
        default:
            break;
    }
}
#pragma mark --
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark requestDelegate
-(void)requestDidFinished:(ASIHTTPRequest*)request{
    if ([[request.userInfo objectForKey:URLKey] isEqualToString:self.downloadFileURL.absoluteString]) {
        self.downloadFileStatus = DownloadStatus_Downloaded;
        
        if (self.materialModel) {
            CaiJinTongManager *app = [CaiJinTongManager shared];
            __weak DownloadDataButton *weakSelf = self;
            [UpdateDownloadTimesInfo downloadDownloadTimesWithUserId:app.user.userId withLearningMatearilId:self.materialModel.materialId withSuccess:^(int downloadCount) {
                DownloadDataButton *tempSelf = weakSelf;
                if (tempSelf) {
                    if (tempSelf.alert) {
                        [tempSelf.alert dismissWithClickedButtonIndex:1 animated:YES];
                    }
                    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_DidFinished object:nil userInfo:@{URLKey: tempSelf.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@"",@"downloadCount":[NSString stringWithFormat:@"%d",downloadCount]}];
                }
            } withError:^(NSError *error) {
                DownloadDataButton *tempSelf = weakSelf;
                if (tempSelf) {
                    if (tempSelf.alert) {
                        [tempSelf.alert dismissWithClickedButtonIndex:1 animated:YES];
                    }
                    int downloadTime = tempSelf.materialModel.materialSearchCount?tempSelf.materialModel.materialSearchCount.intValue:0;
                    [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_DidFinished object:nil userInfo:@{URLKey: tempSelf.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@"",@"downloadCount":[NSString stringWithFormat:@"%d",downloadTime+1]}];
                }
            }];
        }else{
            if (self.alert) {
                [self.alert dismissWithClickedButtonIndex:1 animated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_DidFinished object:nil userInfo:@{URLKey: self.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@""}];
        }
    }
    
}

-(void)requestDidFailure:(ASIHTTPRequest*)request{
    if ([[request.userInfo objectForKey:URLKey] isEqualToString:self.downloadFileURL.absoluteString]) {
        if (self.downloadFileStatus != DownloadStatus_Pause) {
            self.downloadFileStatus = DownloadStatus_UnDownload;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:DownloadDataButton_Notification_Failure object:nil userInfo:@{URLKey: self.downloadFileURL.absoluteString?:@"",URLLocalPath:self.localPath?:@""}];
    }
}
#pragma mark --

#pragma mark property
-(UIProgressView *)progressView{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] init];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    }
    return _progressView;
}

-(void)setDownloadFileStatus:(DownloadStatus)downloadFileStatus{
    _downloadFileStatus = downloadFileStatus;
    [self.progressView removeFromSuperview];
    self.backgroundColor = [UIColor clearColor];
    [self setTitle:@"" forState:UIControlStateNormal];
    switch (downloadFileStatus) {
        case DownloadStatus_UnDownload:
        {
//            [self setTitle:@"点击下载" forState:UIControlStateNormal];
            break;
        }
        case DownloadStatus_Downloading:
        {
            
            [self addSubview:self.progressView];
//            [self setTitle:@"正在下载" forState:UIControlStateNormal];
            break;
        }
        case DownloadStatus_Pause:
        {
             [self addSubview:self.progressView];
//            [self setTitle:@"继续下载" forState:UIControlStateNormal];
            break;
        }
        case DownloadStatus_Downloaded:
        {
//            [self setTitle:@"下载完成" forState:UIControlStateNormal];
            break;
        }
        default:
            break;
    }
}


#pragma mark --

@end
