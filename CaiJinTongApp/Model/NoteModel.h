//
//  NoteModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SectionModel.h"
@interface NoteModel : NSObject
/*
 笔记对象
 */
@property (nonatomic, strong) NSString *noteId;//笔记id
@property (nonatomic, strong) NSString *noteTime;//笔记创建时间
@property (nonatomic, strong) NSString *noteText;//笔记内容
@property (nonatomic, strong) NSString *noteSectionId;//笔记对应小节id
@property (nonatomic, strong) NSString *noteSectionName;//笔记对应小节名称
@property (nonatomic, strong) NSString *noteSectionMoviePlayURL;//笔记对应小节视频url
@property (nonatomic, strong) NSString *noteSectionLastPlayTime;//笔记对应小节最近播放进度
@property (nonatomic, strong) NSString *noteChapterId;//笔记对应章id
@property (nonatomic, strong) NSString *noteChapterName;//笔记对应章名称
@property (nonatomic, strong) NSString *noteLessonId;//笔记对应 课程id
@property (nonatomic, strong) NSString *noteLessonName;//笔记对应课程名称
@end
