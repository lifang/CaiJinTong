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
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@",kHost];
    
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
                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                //问题章节列表
                                if (![[dictionary objectForKey:@"questionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"questionList"]!=nil) {
                                    NSArray *array_question = [dictionary objectForKey:@"questionList"];
                                    if (array_question.count>0) {
                                        NSMutableArray *lessonQuestionList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array_question.count; i++) {
                                            NSDictionary *lessonQuestion_dic = [array_question objectAtIndex:i];
                                            LessonQuestionModel *lessonQuestion = [[LessonQuestionModel alloc]init];
                                            lessonQuestion.lessonQuestionId = [NSString stringWithFormat:@"%@",[lessonQuestion_dic objectForKey:@"lessonQuestionId"]];
                                            lessonQuestion.lessonQuestionName = [NSString stringWithFormat:@"%@",[lessonQuestion_dic objectForKey:@"lessonQuestionName"]];
                                            //课程下的章列表
                                            if (![[lessonQuestion_dic objectForKey:@"chapterQuestionList"]isKindOfClass:[NSNull class]] && [lessonQuestion_dic objectForKey:@"chapterQuestionList"]!=nil) {
                                                NSArray *chapterQuestionList = [lessonQuestion_dic objectForKey:@"chapterQuestionList"];
                                                if (chapterQuestionList.count>0) {
                                                    lessonQuestion.chapterQuestionList = [[NSMutableArray alloc]init];
                                                    for (int k=0; k<chapterQuestionList.count; k++) {
                                                        NSDictionary *chapterQuestion_dic = [chapterQuestionList objectAtIndex:k];
                                                        ChapterQuestionModel *chapterQuestion = [[ChapterQuestionModel alloc]init];
                                                        chapterQuestion.chapterQuestionId = [NSString stringWithFormat:@"%@",[chapterQuestion_dic objectForKey:@"chapterQuestionId"]];
                                                        chapterQuestion.chapterQuestionName = [NSString stringWithFormat:@"%@",[chapterQuestion_dic objectForKey:@"chapterQuestionName"]];
                                                        [lessonQuestion.chapterQuestionList addObject:chapterQuestion];
                                                    }
                                                    DLog(@"chapterQuestionList = %@",lessonQuestion.chapterQuestionList);
                                                }
                                            }
                                            [lessonQuestionList addObject:lessonQuestion];
                                        }
                                        if (lessonQuestionList.count>0) {
                                            [tempDic setObject:lessonQuestionList forKey:@"questionList"];
                                        }
                                    }
                                }
                                //最近问题
                                if (![[dictionary objectForKey:@"nowQuestionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"nowQuestionList"]!=nil) {
                                    NSArray *array_nowList = [dictionary objectForKey:@"nowQuestionList"];
                                    if (array_nowList.count>0) {
                                        NSMutableArray *nowList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array_nowList.count; i++) {
                                            NSDictionary *question_dic = [array_nowList objectAtIndex:i];
                                            QuestionModel *question = [[QuestionModel alloc]init];
                                            question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
                                            question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionName"]];
                                            question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
                                            question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
                                            question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
                                            question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
                                            question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];
                                            question.isAcceptAnswer = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isAcceptAnswer"]];
                                            question.pageIndex =[[question_dic objectForKey:@"pageIndex"]intValue];
                                            question.pageCount =[[question_dic objectForKey:@"pageCount"]intValue];
                                            
                                            if (![[question_dic objectForKey:@"answerList"]isKindOfClass:[NSNull class]] && [question_dic objectForKey:@"answerList"]!=nil) {
                                                NSArray *array_answer = [question_dic objectForKey:@"answerList"];
                                                if (array_answer.count>0) {
                                                    question.answerList = [[NSMutableArray alloc]init];
                                                    for (int k=0; k<array_answer.count; k++) {
                                                        NSDictionary *answer_dic = [array_answer objectAtIndex:k];
                                                        AnswerModel *answer = [[AnswerModel alloc]init];
                                                        answer.resultId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"resultId"]];
                                                        answer.answerTime =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerTime"]];
                                                        answer.answerId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerId"]];
                                                        answer.answerNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerNick"]];
                                                        answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
                                                        answer.IsAnswerAccept =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
                                                        answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
                                                        answer.pageIndex =[[answer_dic objectForKey:@"pageIndex"]intValue];
                                                        answer.pageCount =[[answer_dic objectForKey:@"pageCount"]intValue];
                                                        [question.answerList addObject:answer];
                                                    }
                                                }
                                            }
                                            [nowList addObject:question];
                                        }
                                        if (nowList.count>0) {
                                            [tempDic setObject:nowList forKey:@"nowQuestionList"];
                                        }
                                    }
                                }
                                if (tempDic) {
                                    [self.delegate getQuestionInfoDidFinished:tempDic];
                                    tempDic = nil;
                                }
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                        }
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
