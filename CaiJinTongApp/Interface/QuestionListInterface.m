//
//  QuestionListInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionListInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "AnswerModel.h"

@implementation QuestionListInterface

-(void)getQuestionListInterfaceDelegateWithUserId:(NSString *)userId andChapterQuestionId:(NSString *)chapterQuestionId andLastQuestionID:(NSString*)lastQuestionID {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    if (chapterQuestionId) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",chapterQuestionId] forKey:@"categoryId"];
    }
    if (lastQuestionID) {
         [reqheaders setValue:[NSString stringWithFormat:@"%@",lastQuestionID] forKey:@"feedbackId"];
    }
//        http://wmi.finance365.com/api/ios.ashx?active=chapterQuestion&userId=18769&categoryId=58&feedbackId=1844
self.interfaceUrl = [NSString stringWithFormat:@"%@?active=chapterQuestion",kHost];


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
                                        question.attachmentFileUrl = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"extUrl"]];
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
                                        question.isPraised =[NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isPraised"]];
                                        
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
                                                    answer.isPraised = [NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isParise"]];
                                                    answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
                                                    answer.IsAnswerAccept =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
                                                    answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
//                                                    answer.askPeopleId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"askPeopleId"]];
//                                                    answer.askPeopleNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"askPeopleNick"]];????
                                                    answer.pageIndex =[[answer_dic objectForKey:@"pageIndex"]intValue];
                                                    answer.pageCount =[[answer_dic objectForKey:@"pageCount"]intValue];
                                                    
                                                    //添加追问
                                                    NSArray *reaskArray = [answer_dic objectForKey:@"addList"];
                                                    NSMutableArray *reaskModelArr = [NSMutableArray array];
                                                    for (NSDictionary *reaskDic in reaskArray) {
                                                        Reaskmodel *reask = [[Reaskmodel alloc] init];
                                                        reask.reaskID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"ZID"]];
                                                        reask.reaskContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]];
                                                        reask.reaskDate = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                                                        reask.reaskingAnswerID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addMemberID"]];
                                                        //对追问的回复
                                                        reask.reAnswerID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AID"]];
                                                        reask.reAnswerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"Answer"]];
                                                        reask.reAnswerIsAgree = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AgreeStatus"]];
                                                        reask.reAnswerIsTeacher = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"IsTeacher"]];
                                                        reask.reAnswerNickName = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"TeacherName"]];
                                                        [reaskModelArr addObject:reask];
                                                    }
                                                    answer.reaskModelArray = reaskModelArr;
                                                    
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
                                    [self.delegate getQuestionListInfoDidFinished:tempDic];
                                    tempDic = nil;
                                }else{
                                    [self.delegate getQuestionListInfoDidFailed:@"没有相关数据!"];
                                }
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
                        }
                    }else {
                        [self.delegate getQuestionListInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                   [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
                }
            }else {
                [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
            }
        }else {
            [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
        }
    }else {
        [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
    }
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
//                                if (![[dictionary objectForKey:@"questionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"questionList"]!=nil)  {
//                                    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
//                                    NSArray *array_chapterQuestionList =[dictionary objectForKey:@"questionList"];
//                                    if (array_chapterQuestionList.count>0) {
//                                        NSMutableArray *chapterQuestionList = [[NSMutableArray alloc]init];
//                                        
//                                        for (int i= 0; i<array_chapterQuestionList.count; i++) {
//                                            NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
//                                            QuestionModel *question = [[QuestionModel alloc]init];
//                                            question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
//                                            question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionName"]];
//                                            question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
//                                            question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
//                                            question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
//                                            question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
//                                            question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];
//                                            question.isAcceptAnswer = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isAcceptAnswer"]];
//                                            question.pageIndex =[[question_dic objectForKey:@"pageIndex"]intValue];
//                                            question.pageCount =[[question_dic objectForKey:@"pageCount"]intValue];
//                                            
//                                            if (![[question_dic objectForKey:@"answerList"]isKindOfClass:[NSNull class]] && [question_dic objectForKey:@"answerList"]!=nil) {
//                                                NSArray *array_answer = [question_dic objectForKey:@"answerList"];
//                                                if (array_answer.count>0) {
//                                                    question.answerList = [[NSMutableArray alloc]init];
//                                                    for (int k=0; k<array_answer.count; k++) {
//                                                        NSDictionary *answer_dic = [array_answer objectAtIndex:k];
//                                                        AnswerModel *answer = [[AnswerModel alloc]init];
//                                                        answer.resultId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"resultId"]];
//                                                        answer.answerTime =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerTime"]];
//                                                        answer.answerId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerId"]];
//                                                        answer.answerNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerNick"]];
//                                                        answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
//                                                        answer.IsAnswerAccept =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
//                                                        answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
//                                                        answer.pageIndex =[[answer_dic objectForKey:@"pageIndex"]intValue];
//                                                        answer.pageCount =[[answer_dic objectForKey:@"pageCount"]intValue];
//                                                        [question.answerList addObject:answer];
//                                                    }
//                                                }
//                                            }
//                                            [chapterQuestionList addObject:question];
//                                        }
//                                        if (chapterQuestionList.count>0) {
//                                            [tempDic setObject:chapterQuestionList forKey:@"chapterQuestionList"];
//                                        }
//                                    }
//                                    if (tempDic.count>0) {
//                                        [self.delegate getQuestionListInfoDidFinished:tempDic];
//                                        tempDic = nil;
//                                    }
//                                }else {
//                                    [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//                                }
//                            }else {
//                                [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//                            }
//                        }
//                        @catch (NSException *exception) {
//                            [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//                        }
//                    }else {
//                        [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//                    }
//                }else {
//                    [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//                }
//            }else {
//                [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//            }
//        }else {
//            [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//        }
//    }else {
//        [self.delegate getQuestionListInfoDidFailed:@"加载失败!"];
//    }
//}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getQuestionListInfoDidFailed:tipMsg];
    }];
}
@end
