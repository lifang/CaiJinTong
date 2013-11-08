//
//  SectionSaveModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-6.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SectionSaveModel : NSObject

@property (nonatomic, strong) NSString *sid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *fileUrl;
@property (nonatomic, assign) NSUInteger downloadState; //0下载中，1下载完成，2下载暂停，3下载失败，4未下载
@property (nonatomic, assign) double downloadPercent;//下载百分比 0--1 浮点数
@property (nonatomic, strong) NSString *contentLength;//大小
@property (nonatomic, strong) NSString *sectionStudy;//已经学习时间
@property (nonatomic, strong) NSString *sectionLastTime;//视频总的时长
@end
