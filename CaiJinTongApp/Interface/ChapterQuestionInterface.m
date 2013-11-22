//
//  ChapterQuestionInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterQuestionInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
#import "QuestionModel.h"
#import "AnswerModel.h"

@implementation ChapterQuestionInterface

-(void)getChapterQuestionInterfaceDelegateWithUserId:(NSString *)userId andChapterQuestionId:(NSString *)chapterQuestionId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",chapterQuestionId] forKey:@"chapterQuestionId"];
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=chapterQuestion&userId=17079&categoryId=42";
    
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
                            if (![[dictionary objectForKey:@"chapterQuestionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"chapterQuestionList"]!=nil)  {
                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                NSArray *array_chapterQuestionList =[dictionary objectForKey:@"chapterQuestionList"];
                                if (array_chapterQuestionList.count>0) {
                                    NSMutableArray *chapterQuestionList = [[NSMutableArray alloc]init];
                                    
                                    for (int i= 0; i<array_chapterQuestionList.count; i++) {
                                        NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
                                        QuestionModel *question = [[QuestionModel alloc]init];
                                        question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
                                        question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionName"]];
                                        question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
                                        question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
                                        question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
                                        question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
                                        question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];
                                        question.isAcceptAnswer = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isAcceptAnswer"]];
                                        question.questiontitle = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questiontitle"]];
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
                                        [chapterQuestionList addObject:question];
                                    }
                                    if (chapterQuestionList.count>0) {
                                        [tempDic setObject:chapterQuestionList forKey:@"chapterQuestionList"];
                                    }
                                }
                                if (tempDic.count>0) {
                                    [self.delegate getChapterQuestionInfoDidFinished:tempDic];
                                    tempDic = nil;
                                }
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getChapterQuestionInfoDidFailed:@"加载失败!"];
                        }
                    }else {
                        [self.delegate getChapterQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getChapterQuestionInfoDidFailed:@"加载失败!"];
                }
            }
        }
    }else {
        [self.delegate getChapterQuestionInfoDidFailed:@"加载失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getChapterQuestionInfoDidFailed:@"加载失败!"];
}
@end

