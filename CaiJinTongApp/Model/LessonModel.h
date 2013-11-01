//
//  LessonModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonModel : NSObject

@property (nonatomic, strong) NSString *lessonId;
@property (nonatomic, strong) NSString *lessonName;
@property (nonatomic, strong) NSMutableArray *chapterList;

@end
