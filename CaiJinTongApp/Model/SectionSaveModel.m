//
//  SectionSaveModel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionSaveModel.h"
#import "Section.h"
@implementation SectionSaveModel

#pragma mark - ASIProgressDelegate
- (void)setProgress:(float)newProgress
{
    if (_downloadPercent == 0 || (newProgress - _downloadPercent > 0.00001)) {
        _downloadPercent =newProgress;

        DLog(@"下载百分比%f",_downloadPercent);
        
        Section *sectionDb = [[Section alloc]init];
        [sectionDb updatePercentDown:newProgress BySid:self.sid];
        //TODO:发送更新下载进度通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DownloadProcessing" object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:@"SectionSaveModel"]];
    }
}

@end
