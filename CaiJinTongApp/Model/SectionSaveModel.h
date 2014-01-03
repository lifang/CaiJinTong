//
//  SectionSaveModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionSaveModel : NSObject

@property (nonatomic, strong) NSString *sid;//视频id
@property (nonatomic, strong) NSString *lessonId;//课程id
@property (nonatomic, strong) NSString *name;//视频名称
@property (nonatomic, strong) NSString *fileUrl;//下载地址
@property (nonatomic, strong) NSString *playUrl;//在线播放地址
@property (nonatomic, strong) NSString *localFileUrl;//本地地址
@property (nonatomic, assign) NSUInteger downloadState; //0下载中，1下载完成，2下载暂停，3下载失败，4未下载
@property (nonatomic, assign) double downloadPercent;//下载百分比 0--1 浮点数
@property (nonatomic, strong) NSString *contentLength;//大小

@property (nonatomic, strong) NSString *sectionStudy;//已经学习时间
@property (nonatomic, strong) NSString *sectionFinishedDate;//保存到数据库日期
@property (nonatomic, strong) NSString *sectionLastTime;//视频总的时长

@property (nonatomic, strong) NSString *sectionImg;//视频封面图片
@property (nonatomic, strong) NSString *lessonInfo;//视频简介
@property (nonatomic, strong) NSString *sectionTeacher;//讲师
@property (nonatomic, strong) NSMutableArray *noteList;//笔记列表
@property (nonatomic, strong) NSMutableArray *sectionList;//章节目录
@end
