//
//  SectionModel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionModel.h"

@implementation SectionModel
-(void)copySection:(SectionModel*)section{
    if (section) {
        self.sectionMovieFileDownloadStatus = section.sectionMovieFileDownloadStatus;
        self.sectionMovieLocalURL = section.sectionMovieLocalURL;
        self.sectionLastPlayTime = section.sectionLastPlayTime;
        self.sectionFileDownloadSize = section.sectionFileDownloadSize;
        self.sectionFileTotalSize = section.sectionFileTotalSize;
        self.sectionFinishedDate = section.sectionFinishedDate;
    }
}
@end
