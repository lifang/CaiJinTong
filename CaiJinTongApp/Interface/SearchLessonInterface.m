//
//  SearchLessonInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SearchLessonInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
#import "SectionModel.h"

@implementation SearchLessonInterface

-(void)getSearchLessonInterfaceDelegateWithUserId:(NSString *)userId andText:(NSString *)text withPageIndex:(int)pageIndex withSortType:(LESSONSORTTYPE)sortType{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",text] forKey:@"text"];
//    http://lms.finance365.com/api/ios.ashx?active=searchLesson&userId=17082&pageIndex=1&text=%E9%87%91%E6%97%A5&sortType=1
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
    self.interfaceUrl =  [NSString stringWithFormat:@"%@?active=searchLesson&userId=%@&pageIndex=%d&text=%@&sortType=%@&pageCount=12",kHost,userId,pageIndex+1,text?:@"",sort];
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
                                    [self.delegate getSearchLessonListDataForCategoryDidFinished:lessonList withCurrentPageIndex:self.currentPageIndex withTotalCount:self.allDataCount];
                                }];
                               
                            }else {
                                [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getSearchLessonListDataForCategoryFailure:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
                        }
                }else {
                    [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
                }
            }else {
                [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
            }
        }else {
            [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
        }
    }else {
        [self.delegate getSearchLessonListDataForCategoryFailure:@"搜索课程失败!"];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getSearchLessonListDataForCategoryFailure:tipMsg];
    }];
}

//-(void)parseResult:(ASIHTTPRequest *)request{
//    NSDictionary *resultHeaders = [[request responseHeaders] allKeytoLowerCase];
//    if (resultHeaders) {
//        NSData *data = [[NSData alloc]initWithData:[request responseData]];
//        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//        if (jsonObject !=nil) {
//            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
//                NSDictionary *jsonData=(NSDictionary *)jsonObject;
//                DLog(@"data = %@",jsonData);
//                if (jsonData) {
//                    if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
//                        @try {
//                            NSDictionary *dictionary =[jsonData objectForKey:@"ReturnObject"];
//                            if (dictionary) {
//                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
//                                if (![[dictionary objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"sectionList"]!=nil) {
//                                    NSArray *array = [dictionary objectForKey:@"sectionList"];
//                                    if (array.count>0) {
//                                        NSMutableArray *sectionList = [[NSMutableArray alloc]init];
//                                        for (int i=0; i<array.count; i++) {
//                                            NSDictionary *dic_section = [array objectAtIndex:i];
//                                            SectionModel *section = [[SectionModel alloc]init];
//                                            section.sectionId = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionId"]];
//                                            section.sectionImg = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionImg"]];
//                                            section.sectionName = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionName"]];
//                                            section.sectionProgress = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionProgress"]];
//                                            [sectionList addObject:section];
//                                        }
//                                        DLog(@"sectionList = %@",sectionList);
//                                        if (sectionList.count>0) {
//                                            [tempDic setObject:sectionList forKey:@"sectionList"];
//                                        }
//                                    }
//                                }
//                                if (tempDic) {
//                                    [self.delegate getSearchLessonInfoDidFinished:tempDic];
//                                    tempDic = nil;
//                                }
//                            }else {
//                                [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//                            }
//                        }
//                        @catch (NSException *exception) {
//                            [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//                        }
//                    }else {
//                        [self.delegate getSearchLessonInfoDidFailed:[jsonData objectForKey:@"Msg"]];
//                    }
//                }else {
//                    [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//                }
//            }else {
//                [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//            }
//        }else {
//            [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//        }
//    }else {
//        [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//    }
//}
//-(void)requestIsFailed:(NSError *)error{
//    [self.delegate getSearchLessonInfoDidFailed:@"搜索失败!"];
//}
@end
