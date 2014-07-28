//
//  chapterModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface chapterModel : NSObject

@property (nonatomic, strong) NSString *chapterId;//章id
@property (nonatomic, strong) NSString *chapterName;//章名称
@property (nonatomic, strong) NSString *chapterImg;//过时
@property (strong,nonatomic)  NSMutableArray *sectionList;//小节列表
@property (strong,nonatomic)  NSMutableArray *chapterNoteList;//章下的笔记，其实是小节下的笔记，后台返回数据问题
@end
