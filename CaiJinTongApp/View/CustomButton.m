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
#import "NoteModel.h"
#import "Section_chapterModel.h"
#import "DRMoviePlayViewController.h"
#import "SectionViewController.h"
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"gotoMoviePlay" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.buttonModel.sid, @"sectionID", nil]];
}
//下载中
-(void)downloadShowView
{
    //下载中的点击弹窗
    DownLoadInformView *mDownLoadInformView = [[[NSBundle mainBundle]loadNibNamed:@"DownLoadInformView" owner:self options:nil]objectAtIndex:0];
    mDownLoadInformView.frame = CGRectMake(0, 0, 568, 650);
    mDownLoadInformView.nm1 = self.buttonModel;
    [self.superview.superview.superview.superview.superview.superview.superview addSubview:mDownLoadInformView];
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
    //先判断是否存在然后添加到数据库
    Section *sectionDb = [[Section alloc]init];
    if ([sectionDb getDataWithSid:self.buttonModel.sid]) {
        
    }else {
        //请求视频详细信息
        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
            [Utility errorAlert:@"暂无网络!"];
        }else {
            [SVProgressHUD showWithStatus:@"玩命加载中..."];
            
            SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
            self.sectionInterface = sectionInter;
            self.sectionInterface.delegate = self;
            [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.buttonModel.sid];
        }
    }
}

#pragma -- SectionInfoInterface
-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [SVProgressHUD dismissWithSuccess:@"连接成功!"];

        self.buttonModel.sectionImg = result.sectionImg;
        self.buttonModel.lessonInfo = result.lessonInfo;
        self.buttonModel.sectionTeacher = result.sectionTeacher;
        self.buttonModel.noteList = result.noteList;
        self.buttonModel.sectionList = result.sectionList;
        self.buttonModel.name = result.sectionName;
        self.buttonModel.fileUrl = result.sectionDownload;
        self.buttonModel.sectionLastTime = result.sectionLastTime;
        //添加数据库
        Section *sectionDb = [[Section alloc]init];
        if (self.buttonModel.noteList.count>0) {//笔记
            for (int i=0; i<self.buttonModel.noteList.count; i++) {
                NoteModel *note = (NoteModel *)[self.buttonModel.noteList objectAtIndex:i];
                [sectionDb addDataWithNoteModel:note andSid:self.buttonModel.sid];
            }
        }
        if (self.buttonModel.sectionList.count>0) {//章节目录
            for (int i=0; i<self.buttonModel.sectionList.count; i++) {
                Section_chapterModel *section = (Section_chapterModel *)[self.buttonModel.sectionList objectAtIndex:i];
                [sectionDb addDataWithSectionModel:section andSid:self.buttonModel.sid];                
            }
        }
        [sectionDb addDataWithSectionSaveModel:self.buttonModel];//基本信息
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate* appDelegate = [AppDelegate sharedInstance];
            DownloadService *mDownloadService = appDelegate.mDownloadService;
            self.buttonModel.downloadState = 0;
            //下载
            [mDownloadService addDownloadTask:self.buttonModel];
        });
    });
    
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    [SVProgressHUD dismiss];
    [Utility errorAlert:errorMsg];
}
@end
