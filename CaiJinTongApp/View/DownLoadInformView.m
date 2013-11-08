//
//  DownLoadInformView.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "DownLoadInformView.h"
#import "AppDelegate.h"
#import "DownloadService.h"

@implementation DownLoadInformView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    //pic
    NSString *path = [[NSBundle mainBundle] pathForResource:@"frame" ofType:@"png"];
    _mImageView.image = [[UIImage imageWithContentsOfFile:path] stretchableImageWithLeftCapWidth:15 topCapHeight:15];  // Todo use of myImage
    
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(viewTapped:)];
    tapGr.cancelsTouchesInView = NO;
    [self.mview addGestureRecognizer:tapGr];
    tapGr = nil;
}
-(void)viewTapped:(UITapGestureRecognizer*)tapGr{
    [self removeFromSuperview];
}

-(IBAction)cancleAction:(id)sender
{
    [self removeFromSuperview];
}

-(void)setNm1:(SectionSaveModel *)nm1 {
    _nm1 = nil;
    _nm1 = nm1;
    if (nm1.downloadState == 2) {
        _mLable.text = @"已经暂停下载";
        [_downStateBtn setImage:[UIImage imageNamed:@"download_continue.png"]
                       forState:UIControlStateNormal];
        [_downStateBtn addTarget:self action:@selector(continueAction) forControlEvents:UIControlEventTouchUpInside];
        [_canceLoadBtn addTarget:self action:@selector(canceDownloadAction) forControlEvents:UIControlEventTouchUpInside];
        
    }else {
        _mLable.text = @"正在下载中，请稍后....";
        [_downStateBtn addTarget:self action:@selector(pauseAction) forControlEvents:UIControlEventTouchUpInside];
        [_canceLoadBtn addTarget:self action:@selector(canceDownloadAction) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}
//暂停下载
-(void)pauseAction{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService stopTask:self.nm1];
    [self removeFromSuperview];
}

//继续下载
-(void)continueAction {
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService addDownloadTask:self.nm1];
    [self removeFromSuperview];
    
}
//取消下载
-(void)canceDownloadAction {
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
    DownloadService *mDownloadService = appDelegate.mDownloadService;
    [mDownloadService removeTask:self.nm1];
    [self removeFromSuperview];
}

@end
