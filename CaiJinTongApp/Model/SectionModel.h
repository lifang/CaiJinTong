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
@property (strong,nonatomic) NSMutableArray *sectionNoteList;//小节对应的笔记
//以下过时
@property (nonatomic, strong) NSString *sectionImg;//过时
@property (nonatomic, strong) NSString *sectionProgress;//过时
@property (nonatomic, strong) NSString *sectionSD;//过时
@property (nonatomic, strong) NSString *sectionHD;//过时
@property (nonatomic, strong) NSString *sectionScore;//过时
@property (nonatomic, strong) NSString *isGrade;//过时
@property (nonatomic, strong) NSString *lessonInfo;//过时
@property (nonatomic, strong) NSString *sectionTeacher;//过时
@property (nonatomic, strong) NSString *sectionDownload;//过时
@property (nonatomic, strong) NSString *sectionStudy;//过时
@property (nonatomic, strong) NSString *sectionLastTime;//过时

@property (nonatomic, strong) NSMutableArray *noteList;//过时
@property (nonatomic, strong) NSMutableArray *commentList;//过时
@property (nonatomic, strong) NSMutableArray *sectionList;//过时

@end
