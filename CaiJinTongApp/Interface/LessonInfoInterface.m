//
//  LessonInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
#import "LessonModel.h"
#import "chapterModel.h"
#import "SectionModel.h"
//我这边统一做了一个status 的定义 ， status=-1;表示漏了参数，msg返回的是"查询超时"   status=0 表示没有查询出数据,msg: 返回的是"未搜索到任何数据"  status=1 表示数据查询成功
@implementation LessonInfoInterface
-(void)getLessonInfoInterfaceDelegateWithUserId:(NSString *)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
   
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=lessonInfo&userId=18676";
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    
    NSDictionary *resultHeaders = [[request responseHeaders] allKeytoLowerCase];
    if (resultHeaders) {
        NSString *str = [request responseString];
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
                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                //课程列表
                                if (![[dictionary objectForKey:@"lessonList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"lessonList"]!=nil) {
                                    NSArray *array = [dictionary objectForKey:@"lessonList"];
                                    if (array.count>0) {
                                        NSMutableArray *lessonList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array.count; i++) {
                                            NSDictionary *dic_lessoon = [array objectAtIndex:i];
                                            LessonModel *lesson = [[LessonModel alloc]init];
                                            lesson.lessonId = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonId"]];
                                            lesson.lessonName = [NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"lessonName"]];
                                            
                                            NSArray *arr_chapter = [dic_lessoon objectForKey:@"chapterList"];
                                            if (arr_chapter.count >0) {
                                                lesson.chapterList = [[NSMutableArray alloc]init];
                                                for (int k=0; k<arr_chapter.count; k++) {
                                                    NSDictionary *dic_chapter = [arr_chapter objectAtIndex:k];
                                                    chapterModel *chapter = [[chapterModel alloc]init];
                                                    chapter.chapterId = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterId"]];
                                                    chapter.chapterName = [NSString stringWithFormat:@"%@",[dic_chapter objectForKey:@"chapterName"]];
                                                    chapter.chapterImg =[NSString stringWithFormat:@"%@",[dic_lessoon objectForKey:@"sectionImg"]];
                                                    [lesson.chapterList addObject:chapter];
                                                }
//                                                DLog(@"chapterList = %@",lesson.chapterList);
                                            }
                                            [lessonList  addObject:lesson];
                                        }
//                                        DLog(@"lessonList = %@",lessonList);
                                        if (lessonList.count>0) {
                                            [tempDic setObject:lessonList forKey:@"lessonList"];
                                        }
                                    }
                                }
                                
                                [self.delegate getLessonInfoDidFinished:tempDic];
                                tempDic = nil;
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                        }
                    }
                }else {
                    [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                }
            }
        }
    }else {
        [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
}
@end
