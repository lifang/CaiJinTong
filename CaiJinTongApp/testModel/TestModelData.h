//
//  TestModelData.h
//  CaiJinTongApp
//
//  Created by david on 13-12-19.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LessonModel.h"
#import "chapterModel.h"
#import "SectionModel.h"
#import "CategoryModel.h"
#import "DRTreeNode.h"
@interface TestModelData : NSObject
+(NSArray*)getLessonArr;
+(NSArray*)getChapterArr;
+(NSArray*)getSectionArr;
+(LessonModel*)getLesson;
+(chapterModel*)getChapter;
//+(SectionModel*)getSection;
+(CategoryModel*)getCategory;
+(CategoryModel*)getCategoryTree;
+(SectionModel*)getSectionOld;//课程
+(DRTreeNode*)getTreeNodeFromCategoryModel:(CategoryModel*)categoryModel;
+(NSMutableArray*)getTreeNodeArrayFromDictionary:(NSDictionary*)dic;
+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr;
+(NSMutableArray *)getQuestion;

+(SectionModel *)getSectionInfo;
@end
