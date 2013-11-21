//
//  Section_chapterModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-20.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section_chapterModel : NSObject
@property (nonatomic, strong) NSString *sectionId;//视频id
@property (nonatomic, strong) NSString *sectionDownload;//下载地址
@property (nonatomic, strong) NSString *sectionName;//视频名称
@property (nonatomic, strong) NSString *sectionLastTime;//视频总的时长
@end
