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
//-(void)setButtonModel:(SectionSaveModel *)buttonModel {
//    _buttonModel = buttonModel;
//    [self setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03"] forState:UIControlStateNormal];
//    [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//    switch (buttonModel.downloadState) {
//        case 0:
//        {
//            //下载中按钮
//            [self setTitle:NSLocalizedString(@"下载中...", @"button") forState:UIControlStateNormal];
//            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(downloadShowView)
//           forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
//            
//        case 1:
//        {//播放按钮
//            [self setTitle:NSLocalizedString(@"播放", @"button") forState:UIControlStateNormal];
//            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(playVideo)
//           forControlEvents:UIControlEventTouchUpInside];
//            
//        }
//            break;
//        case 2:
//        {//继续下载按钮
//            [self setTitle:NSLocalizedString(@"继续下载", @"button") forState:UIControlStateNormal];
//            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(reDownloadClicked)
//           forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
//        case 3:
//        {//重新下载按钮
//            [self setTitle:NSLocalizedString(@"重新下载", @"button") forState:UIControlStateNormal];
//            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(reDownloadClicked)
//           forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
//        case 4:
//        {//下载按钮
//            [self setTitle:NSLocalizedString(@"下载", @"button") forState:UIControlStateNormal];
//            [self removeTarget:self action:NULL forControlEvents:UIControlEventTouchUpInside];
//            [self addTarget:self action:@selector(downloadClicked)
//           forControlEvents:UIControlEventTouchUpInside];
//            
//        }
//            break;
//        default:
//            break;
//    }
//}

-(void)setButtonModel:(SectionSaveModel *)buttonModel {
    _buttonModel = buttonModel;
    [self setBackgroundImage:[UIImage imageNamed:@"course-mycourse_03.png"] forState:UIControlStateNormal];
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
        case 3:
        {//继续下载按钮
            [self setTitle:NSLocalizedString(@"继续下载", @"button") forState:UIControlStateNormal];
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
    
    [[NSNotificationCenter defaultCenter] postNotificationName:self.isMovieView?@"gotoMoviePlayMovie": @"gotoMoviePlay" object:nil userInfo:[NSDictionary dictionaryWithObjectsAndKeys:self.buttonModel.sid, @"sectionID", self.buttonModel.name,@"sectionName",nil]];
}

//下载中
-(void)downloadShowView
{
    //下载中的点击弹窗
    self.alert = [[UIAlertView alloc] initWithTitle:@"" message:@"正在下载中，请稍后...." delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"暂停下载",@"取消下载", nil];
    self.alert.tag = 0;
    [self.alert show];
}
////下载中
//-(void)downloadShowView
//{
//    //下载中的点击弹窗
//    DownLoadInformView *mDownLoadInformView = [[[NSBundle mainBundle]loadNibNamed:@"DownLoadInformView" owner:self options:nil]objectAtIndex:0];
//    mDownLoadInformView.nm1 = self.buttonModel;
//    mDownLoadInformView.frame = CGRectMake(0, 0, 1024, 768);
//    UIView *parentView = [self findSuperViewWithSupView:self];
//    [parentView addSubview:mDownLoadInformView];
//    mDownLoadInformView.center = (CGPoint){parentView.frame.size.width/2,parentView.frame.size.height/2};
//}

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
////下载按钮 点击弹出框
//-(void)downloadClicked
//{
//    //先判断是否存在然后添加到数据库
//    Section *sectionDb = [[Section alloc]init];
//    if ([sectionDb getDataWithSid:self.buttonModel.sid]) {
//        
//    }else {
//        //请求视频详细信息
//        if ([[Utility isExistenceNetwork]isEqualToString:@"NotReachable"]) {
//            [Utility errorAlert:@"暂无网络!"];
//        }else {
//            AppDelegate* appDelegate = [AppDelegate sharedInstance];
//            [MBProgressHUD showHUDAddedTo:appDelegate.window animated:YES];
//            
//            SectionInfoInterface *sectionInter = [[SectionInfoInterface alloc]init];
//            self.sectionInterface = sectionInter;
//            self.sectionInterface.delegate = self;
//            [self.sectionInterface getSectionInfoInterfaceDelegateWithUserId:[CaiJinTongManager shared].userId andSectionId:self.buttonModel.sid];
//        }
//    }
//}

//下载按钮 点击弹出框
-(void)downloadClicked
{
    //添加数据库
    Section *sectionDb = [[Section alloc]init];
     [sectionDb addDataWithSectionSaveModel:self.buttonModel];//基本信息
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    self.buttonModel.downloadState = 0;
    //下载
    [mDownloadService addDownloadTask:self.buttonModel];
}

#pragma -- SectionInfoInterface
-(void)getSectionInfoDidFinished:(SectionModel *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
            [MBProgressHUD hideHUDForView:appDelegate.window animated:YES];
            DownloadService *mDownloadService = appDelegate.mDownloadService;
            self.buttonModel.downloadState = 0;
            //下载
            [mDownloadService addDownloadTask:self.buttonModel];
        });
    });
    
}
-(void)getSectionInfoDidFailed:(NSString *)errorMsg {
    AppDelegate* appDelegate = [AppDelegate sharedInstance];
    [MBProgressHUD hideHUDForView:appDelegate.window animated:YES];
    [Utility errorAlert:errorMsg];
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
