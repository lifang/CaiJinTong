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
#import "DownLoadInformView.h"
#import "Section.h"
#import "LessonViewController.h"

@implementation CustomButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setButtonModel:(SectionSaveModel *)buttonModel {
    _buttonModel = buttonModel;
    
    [self setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03"] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    CGRect frame = self.frame;
    frame.size = CGSizeMake(frame.size.width-20, frame.size.height-10);
    self.frame = frame;
    
    switch (buttonModel.downloadState) {
        case 0:
        {
            //下载中按钮
            [self setTitle:NSLocalizedString(@"下载中...", @"button") forState:UIControlStateNormal];
            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(downloadShowView)
           forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        case 1:
        {//播放按钮
            [self setTitle:NSLocalizedString(@"播放", @"button") forState:UIControlStateNormal];
            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(playVideo)
           forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        case 2:
        {//继续下载按钮
            [self setTitle:NSLocalizedString(@"继续下载", @"button") forState:UIControlStateNormal];
            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(reDownloadClicked)
           forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 3:
        {//重新下载按钮
            [self setTitle:NSLocalizedString(@"重新下载", @"button") forState:UIControlStateNormal];
            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(reDownloadClicked)
           forControlEvents:UIControlEventTouchUpInside];
        }
            break;
        case 4:
        {//下载按钮
            [self setTitle:NSLocalizedString(@"下载", @"button") forState:UIControlStateNormal];
            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
            [self addTarget:self action:@selector(downloadClicked)
           forControlEvents:UIControlEventTouchUpInside];
            
        }
            break;
        default:
            break;
    }
}
//播放
-(void)playVideo {
    
}
//下载中
-(void)downloadShowView
{
    //下载中的点击弹窗
    DownLoadInformView *mDownLoadInformView = [[[NSBundle mainBundle]loadNibNamed:@"DownLoadInformView" owner:self options:nil]objectAtIndex:0];
    AppDelegate *delegate = [AppDelegate sharedInstance];
    mDownLoadInformView.frame = CGRectMake(0, 0, 768, 1024);
    
    mDownLoadInformView.nm1 = self.buttonModel;
    [delegate.window.rootViewController.view addSubview:mDownLoadInformView];
    
}
//继续下载
-(void)reDownloadClicked
{
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService addDownloadTask:self.buttonModel];
}
//下载按钮 点击弹出框
-(void)downloadClicked
{
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    self.buttonModel.downloadState = 0;
    //先判断是否存在然后添加到数据库
    Section *sectionDb = [[Section alloc]init];
    if ([sectionDb getDataWithSid:self.buttonModel.sid]) {
        
    }else {
        [sectionDb addDataWithSectionSaveModel:self.buttonModel];
        //下载
        [mDownloadService addDownloadTask:self.buttonModel];
    }
}

@end
