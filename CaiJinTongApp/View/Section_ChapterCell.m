//
//  Section_ChapterCell.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "Section_ChapterCell.h"
@implementation Section_ChapterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

#pragma mark 收到下载通知处理
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)beginReceiveNotification{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name: @"downloadStart"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name: @"downloadFinished"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name: @"downloadFailed"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name:@"removeDownLoad"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reveiceNotification:)
                                                 name:@"stopDownLoad"
                                               object:nil];
}

-(void)reveiceNotification:(NSNotification*)notification{
    SectionModel *sectionModel = [notification.userInfo objectForKey:@"SectionSaveModel"];
    if (sectionModel && [sectionModel.sectionId isEqualToString:self.sectionModel.sectionId]) {
        if (sectionModel.sectionMovieLocalURL &&![sectionModel.sectionMovieLocalURL isEqualToString:@""]) {
            self.sectionModel = sectionModel;
        }
    }
}

#pragma mark --

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(IBAction)playBtClicked:(id)sender{
 [[NSNotificationCenter defaultCenter] postNotificationName:self.isMoviePlayView?@"changePlaySectionMovieOnLine": @"startPlaySectionMovieOnLine" object:nil userInfo:@{@"sectionModel": self.sectionModel}];
}

-(void)setSectionModel:(SectionModel *)sectionModel{
    _sectionModel = sectionModel;
    self.btn.buttonModel = sectionModel;
    self.sliderFrontView.clipsToBounds = YES;
    if (sectionModel && sectionModel.sectionMovieFileDownloadStatus == DownloadStatus_Downloaded) {
        [self.playBt setHidden:YES];
    }else{
        [self.playBt setHidden:NO];
    }
    
    if (_sectionModel.sectionFileTotalSize && ![_sectionModel.sectionFileTotalSize isEqualToString:@""]) {
        self.lengthLab.text = [NSString stringWithFormat:@"%@/%@",[Utility convertFileSizeUnitWithBytes:_sectionModel.sectionFileDownloadSize],[Utility convertFileSizeUnitWithBytes:_sectionModel.sectionFileTotalSize]];
        long long totalSize =_sectionModel.sectionFileTotalSize.longLongValue;
        long long downloadSize =_sectionModel.sectionFileDownloadSize.longLongValue;
        self.sliderFrontView.frame = CGRectMake(0, 0, CGRectGetWidth(self.sliderBackView.frame) *((double)downloadSize/totalSize), CGRectGetHeight(self.sliderBackView.frame));
    }else{
        self.sliderFrontView.frame = CGRectMake(0, 0, 0, CGRectGetHeight(self.sliderBackView.frame));
        self.lengthLab.text = @"";
    }
    
    switch (sectionModel.sectionMovieFileDownloadStatus) {
        case DownloadStatus_Downloaded:
        {
            self.statusLab.text = @"已下载";
        }
            
            break;
        case DownloadStatus_UnDownload:
        {
            self.statusLab.text = @"未下载";
        }
            
            break;
        case DownloadStatus_Downloading:
        {
            self.statusLab.text = @"下载中...";
            AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication]delegate];
            DownloadService *mDownloadService = appDelegate.mDownloadService;
            [mDownloadService addDownloadTask:_sectionModel];
        }
            
            break;
        case DownloadStatus_Pause:
        {
            self.statusLab.text = @"继续下载";
        }
            
            break;
        default:
            break;
    }
    
}

@end
