//
//  QuestionInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "LessonQuestionModel.h"
#import "ChapterQuestionModel.h"
#import "QuestionModel.h"
#import "AnswerModel.h"
@implementation QuestionInfoInterface

-(void)getQuestionInfoInterfaceDelegateWithUserId:(NSString *)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=getQuestionCategory&userId=18676";
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [[request responseHeaders] allKeytoLowerCase];
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
                                [self.delegate getQuestionInfoDidFinished:dictionary];
//                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
//                                //问题章节列表
//                                if (![[dictionary objectForKey:@"questionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"questionList"]!=nil) {
//                                    NSArray *array_question = [dictionary objectForKey:@"questionList"];
//                                    if (array_question.count>0) {
//                                        NSMutableArray *lessonQuestionList = [[NSMutableArray alloc]init];
//                                        for (int i=0; i<array_question.count; i++) {
//                                            NSDictionary *lessonQuestion_dic = [array_question objectAtIndex:i];
//                                            LessonQuestionModel *lessonQuestion = [[LessonQuestionModel alloc]init];
//                                            lessonQuestion.lessonQuestionId = [NSString stringWithFormat:@"%@",[lessonQuestion_dic objectForKey:@"lessonQuestionId"]];
//                                            lessonQuestion.lessonQuestionName = [NSString stringWithFormat:@"%@",[lessonQuestion_dic objectForKey:@"lessonQuestionName"]];
//                                            //课程下的章列表
//                                            if (![[lessonQuestion_dic objectForKey:@"chapterQuestionList"]isKindOfClass:[NSNull class]] && [lessonQuestion_dic objectForKey:@"chapterQuestionList"]!=nil) {
//                                                NSArray *chapterQuestionList = [lessonQuestion_dic objectForKey:@"chapterQuestionList"];
//                                                if (chapterQuestionList.count>0) {
//                                                    lessonQuestion.chapterQuestionList = [[NSMutableArray alloc]init];
//                                                    for (int k=0; k<chapterQuestionList.count; k++) {
//                                                        NSDictionary *chapterQuestion_dic = [chapterQuestionList objectAtIndex:k];
//                                                        ChapterQuestionModel *chapterQuestion = [[ChapterQuestionModel alloc]init];
//                                                        chapterQuestion.chapterQuestionId = [NSString stringWithFormat:@"%@",[chapterQuestion_dic objectForKey:@"chapterQuestionId"]];
//                                                        chapterQuestion.chapterQuestionName = [NSString stringWithFormat:@"%@",[chapterQuestion_dic objectForKey:@"chapterQuestionName"]];
//                                                        [lessonQuestion.chapterQuestionList addObject:chapterQuestion];
//                                                    }
//                                                    DLog(@"chapterQuestionList = %@",lessonQuestion.chapterQuestionList);
//                                                }
//                                            }
//                                            [lessonQuestionList addObject:lessonQuestion];
//                                        }
//                                        if (lessonQuestionList.count>0) {
//                                            [tempDic setObject:lessonQuestionList forKey:@"questionList"];
//                                        }
//                                    }
//                                }
//                                if (tempDic) {
//                                    [self.delegate getQuestionInfoDidFinished:tempDic];
//                                    tempDic = nil;
//                                }
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                        }
                    }else {
                        [self.delegate getQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                }
            }
        }
    }else {
        [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
}
@end
