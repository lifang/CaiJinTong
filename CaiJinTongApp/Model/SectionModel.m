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

- (void)setSectionMoviePlayURL:(NSString *)sectionMoviePlayURL{
    if (sectionMoviePlayURL.length>0) {
        NSRange range = [sectionMoviePlayURL rangeOfString:@"http://v.ku6vms.com/phpvms/player/js/vid/"];
        if (range.location != NSNotFound && range.length != NSNotFound) {
            NSRange range2 = [sectionMoviePlayURL rangeOfString:@"/style"];
            NSString *keyWord = [sectionMoviePlayURL substringWithRange:NSMakeRange(range.location + range.length, range2.location - range.location - range.length)];
            
            _sectionMoviePlayURL = [NSString stringWithFormat:@"http://v.ku6vms.com/phpvms/player/getM3U8/vid/%@/v.m3u8",keyWord];
        }else{
            _sectionMoviePlayURL = sectionMoviePlayURL;
        }
    }else{
        _sectionMoviePlayURL = sectionMoviePlayURL;
    }
}

//- (void)setSectionMovieDownloadURL:(NSString *)sectionMovieDownloadURL{
//    if (sectionMovieDownloadURL.length>0) {
//        NSRange range = [sectionMovieDownloadURL rangeOfString:@"http://v.ku6vms.com/phpvms/player/js/vid/"];
//        if (range.location != NSNotFound && range.length != NSNotFound) {
//            NSRange range2 = [sectionMovieDownloadURL rangeOfString:@"/style"];
//            NSString *keyWord = [sectionMovieDownloadURL substringWithRange:NSMakeRange(range.location + range.length, range2.location - range.location - range.length)];
//            
//            _sectionMovieDownloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.ku6vms.com/phpvms/player/getM3U8/vid/%@/v.m3u8",keyWord]];
//        }else{
//            _sectionMovieDownloadURL = sectionMovieDownloadURL;
//        }
//    }else{
//        _sectionMovieDownloadURL = sectionMovieDownloadURL;
//    }
//}

@end
