//
//  SectionModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionModel : NSObject

@property (nonatomic, strong) NSString *sectionId;//视频id
@property (nonatomic, strong) NSString *lessonId;//课程id
@property (nonatomic, strong) NSString *lessonCategoryId;//课程所属分类
@property (nonatomic, strong) NSString *sectionName;//视频名称
@property (strong,nonatomic) NSString *sectionLastPlayTime;//最后一次播放时间点
@property (strong,nonatomic) NSString *sectionMoviePlayURL;//视频播放url
@property (strong,nonatomic) NSString *sectionMovieDownloadURL;//视频下载url
@property (strong,nonatomic) NSString *sectionMovieLocalURL;//视频本地播放地址
@property (strong,nonatomic) NSString *sectionFinishedDate;//最后播放结束日期
@property (strong,nonatomic) NSString *sectionFileDownloadSize;//已经下载大小
@property (strong,nonatomic) NSString *sectionFileTotalSize;//总共大小
@property (strong,nonatomic) NSMutableArray *sectionNoteList;//小节对应的笔记
@property (assign,nonatomic) DownloadStatus sectionMovieFileDownloadStatus;
@property (strong,nonatomic) NSString *sectionChapterId;//章节信息

///复制对象，主要存储在本地的对象
-(void)copySection:(SectionModel*)section;
@end
