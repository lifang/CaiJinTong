//
//  LessonListForCategory.m
//  CaiJinTongApp
//
//  Created by david on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonListForCategory.h"

@implementation LessonListForCategory
-(void)downloadLessonListForCategoryId:(NSString*)categoryId withUserId:(NSString*)userId withPageIndex:(int)pageIndex withSortType:(LESSONSORTTYPE)sortType{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    self.lessonCategoryId = categoryId;
    //sortType : 1:最近播放学习，2:学习进度排序，3:名称排序
    NSString *sort = @"1";
    switch (sortType) {
        case LESSONSORTTYPE_CurrentStudy:
            sort = @"1";
            break;
        case LESSONSORTTYPE_ProgressStudy:
            sort = @"2";
            break;
        case LESSONSORTTYPE_LessonName:
            sort = @"3";
            break;
        default:
            break;
    }
//    http://lms.finance365.com/api/ios.ashx?active=lessonList&userId=17082&lessonCategoryId=80&pageIndex=3&sortType=1
    //后台所有的分页第一页都是从1开始
    if (categoryId && ![categoryId isEqualToString:[NSString stringWithFormat:@"%d",CategoryType_ALL]]) {
           self.interfaceUrl = [NSString stringWithFormat:@"%@?active=lessonList&userId=%@&lessonCategoryId=%@&pageIndex=%d&sortType=%@",kHost,userId,categoryId,pageIndex+1,sort];
    }else{
       self.interfaceUrl = [NSString stringWithFormat:@"%@?active=lessonList&userId=%@&lessonCategoryId=0&pageIndex=%d&sortType=%@",kHost,userId,pageIndex+1,sort];
    }

    self.baseDelegate = self;
    self.headers = reqheaders;
    [self connect];
}

#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject !=nil) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)jsonObject;
                DLog(@"data = %@",jsonData);
                if (jsonData) {
                    if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                        @try {
                            NSDictionary *dictionary =[jsonData objectForKey:@"ReturnObject"];
                            if (dictionary) {
                                self.currentPageIndex = [[dictionary objectForKey:@"pageIndex"] integerValue]-1;
                                self.allDataCount = [[dictionary objectForKey:@"pageCount"] integerValue];
                                NSArray *lessonArr = [dictionary objectForKey:@"courseList"];
                                NSMutableArray *lessonList = [NSMutableArray array];
                                for (NSDictionary *dic in lessonArr) {
                                    LessonModel *model = [[LessonModel alloc] init];
                                    model.lessonId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"courseID"]];
                                    model.lessonName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CourseName"]];
                                    model.lessonImageURL = [NSString stringWithFormat:@"%@",[dic objectForKey:@"CoursePhoto"]];
                                    model.lessonStudyProgress = [NSString stringWithFormat:@"%@",[dic objectForKey:@"studyProgress"]];
                                    [lessonList addObject:model];
                                }
                                [DRFMDBDatabaseTool updateLessonObjListWithUserId:[CaiJinTongManager shared].user.userId withLessonObjArray:lessonList withFinished:^(BOOL flag) {
                                    [self.delegate getLessonListDataForCategoryDidFinished:lessonList withCurrentPageIndex:self.currentPageIndex withTotalCount:self.allDataCount];
                                }];
                            }else {
                                [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getLessonListDataForCategoryFailure:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
                        }
                }else {
                    [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
                }
            }else {
                [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
            }
        }else {
            [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
        }
    }else {
        [self.delegate getLessonListDataForCategoryFailure:@"获取课程列表失败!"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getLessonListDataForCategoryFailure:tipMsg];
    }];
}

@end

