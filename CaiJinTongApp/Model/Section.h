//
//  Section.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseDao.h"
#import "SectionSaveModel.h"

@interface Section : BaseDao

-(SectionSaveModel *)getDataWithSid:(NSString *) sid;//获取信息
-(void)deleteDataWithSid:(NSString *) sid;//删除
-(BOOL)addDataWithSectionSaveModel:(SectionSaveModel *)model;
-(BOOL)updateTheStateWithSid:(NSString *) sid andDownloadState:(NSUInteger)downloadState;//更新下载状态信息
-(int)HasTheDataDownloadWithSid:(NSString *)sid;//判断是否下载完成
//TODO 判断下载状态 将下载状态改为暂停状态2 同时在启动的时候将状态改为2暂停。
-(BOOL)updatePercentDown:(double)length BySid:(NSString *)sid;//更新下载大小
-(float)getPercentDownBySid:(NSString *)sid;
-(float)getContentLengthBySid:(NSString *)sid ;//获取文章长度
-(BOOL)updateContentLength:(double)length BySid:(NSString *)sid;//更新文章的长度大小
@end
