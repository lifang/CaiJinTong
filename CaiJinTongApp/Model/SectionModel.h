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
@property (nonatomic, strong) NSString *sectionImg;//视频封面图片
@property (nonatomic, strong) NSString *sectionName;//视频名称
@property (nonatomic, strong) NSString *sectionProgress;//视频学习进度

@property (nonatomic, strong) NSString *sectionSD;//标清
@property (nonatomic, strong) NSString *sectionHD;//高清
@property (nonatomic, strong) NSString *sectionScore;//视频分数
@property (nonatomic, strong) NSString *isGrade;//判断“我”是否打过分
@property (nonatomic, strong) NSString *lessonInfo;//视频简介
@property (nonatomic, strong) NSString *sectionTeacher;//讲师
@property (nonatomic, strong) NSString *sectionDownload;//下载地址
@property (nonatomic, strong) NSString *sectionStudy;//已经学习时间
@property (nonatomic, strong) NSString *sectionLastTime;//视频总的时长

@property (nonatomic, strong) NSMutableArray *noteList;//笔记列表
@property (nonatomic, strong) NSMutableArray *commentList;//评论列表
@property (nonatomic, strong) NSMutableArray *sectionList;//章节目录

@end
