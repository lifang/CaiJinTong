//
//  CustomButton.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CustomButton.h"
#import "AppDelegate.h"
#import "DownloadService.h"
#import "Section.h"
#import "NoteModel.h"
#import "Section_chapterModel.h"
#import "DRMoviePlayViewController.h"
#import "SectionViewController.h"

@interface CustomButton ()
@property (nonatomic,strong) UIAlertView *alert;
@end

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)downloadButtonClicked{
    switch (self.buttonModel.sectionMovieFileDownloadStatus) {
        case DownloadStatus_Downloading:
        {
            //下载中按钮
            [self setTitle:NSLocalizedString(@"下载中...", @"button") forState:UIControlStateNormal];
            [self downloadShowView];
        }
            break;
            
        case DownloadStatus_Downloaded:
        {//播放按钮
            [self setTitle:NSLocalizedString(@"播放", @"button") forState:UIControlStateNormal];
            [self playVideo];
        }
            break;
        case DownloadStatus_Pause:
        {//继续下载按钮
            [self setTitle:NSLocalizedString(@"继续下载", @"button") forState:UIControlStateNormal];
            [self reDownloadClicked];
        }
            break;
            
        case DownloadStatus_UnDownload:
        {//下载按钮
            [self setTitle:NSLocalizedString(@"下载", @"button") forState:UIControlStateNormal];
            [self downloadClicked];
            
        }
            break;
        default:
            break;
    }
}


-(void)setButtonModel:(SectionModel *)buttonModel {
    /*
     临时添加,1月22日. 如按钮状态发生改变时,即下载完成/失败时,去除alertView
     */
    if(_buttonModel.sectionMovieFileDownloadStatus != buttonModel.sectionMovieFileDownloadStatus && self.alert.visible){
        [self.alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    
    _buttonModel = buttonModel;
    [self setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03.png"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self addTarget:self action:@selector(downloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    switch (buttonModel.sectionMovieFileDownloadStatus) {
        case DownloadStatus_Downloading:
        {
            //下载中按钮
            [self setTitle:NSLocalizedString(@"下载中...", @"button") forState:UIControlStateNormal];
        }
            break;
            
        case DownloadStatus_Downloaded:
        {//播放按钮
            [self setTitle:NSLocalizedString(@"播放", @"button") forState:UIControlStateNormal];
            
        }
            break;
        case DownloadStatus_Pause:
        {//继续下载按钮
            [self setTitle:NSLocalizedString(@"继续下载", @"button") forState:UIControlStateNormal];
        }
            break;
        
        case DownloadStatus_UnDownload:
        {//下载按钮
            [self setTitle:NSLocalizedString(@"下载", @"button") forState:UIControlStateNormal];
            
        }
            break;
        default:
            break;
    }
}

//播放
-(void)playVideo {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.isMovieView?@"gotoMoviePlayMovie": @"gotoMoviePlay" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.buttonModel.sectionId, @"sectionID", self.buttonModel.sectionName,@"sectionName",nil]];
}

//下载中
-(void)downloadShowView
{
    //下载中的点击弹窗
    self.alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在下载中，请稍后...." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"暂停下载",@"取消下载", nil];
    self.alert.tag = 0;
    [self.alert show];
}

-(UIView*)findSuperViewWithSupView:(UIView*)supView{
    if (supView && supView.superview) {
        return [self findSuperViewWithSupView:supView.superview];
    }
    return supView;
}


//继续下载
-(void)reDownloadClicked
{
    [self continueAction];
}

//下载按钮 点击弹出框
-(void)downloadClicked
{
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    //下载
    [mDownloadService addDownloadTask:self.buttonModel];
}


#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 0) {//正在下载中
        if (buttonIndex == 1) {//暂停下载
            [self pauseAction];
        }
        if (buttonIndex == 2) {//取消下载
            [self canceDownloadAction];
        }
    }
    
    if (alertView.tag == 2) {//暂停下载中
        if (buttonIndex == 0) {//继续下载
            [self continueAction];
        }
        if (buttonIndex == 1) {//取消下载
            [self canceDownloadAction];
        }
    }
}
#pragma mark --

//暂停下载
-(void)pauseAction{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService stopTask:self.buttonModel];
}

//继续下载
-(void)continueAction {
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService addDownloadTask:self.buttonModel];
    
}
//取消下载
-(void)canceDownloadAction {
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService removeTask:self.buttonModel];
}

@end
