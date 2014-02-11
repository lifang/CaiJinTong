//
//  GetUserQuestionInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "GetUserQuestionInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "QuestionModel.h"
#import "AnswerModel.h"
@implementation GetUserQuestionInterface

-(void)getGetUserQuestionInterfaceDelegateWithUserId:(NSString *)userId andIsMyselfQuestion:(NSString *)isMyselfQuestion andLastQuestionID:(NSString*)lastQuestionID withCategoryId:(NSString*)categoryId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",isMyselfQuestion] forKey:@"isMyselfQuestion"];
    
//    self.interfaceUrl = [NSString stringWithFormat:@"%@",kHost];
    //isMyselfQuestion=0 表示我提的问题
    //isMyselfQuestion=1 我回答过的问题
//    self.interfaceUrl = [NSString stringWithFormat:@"http://lms.finance365.com/api/ios.ashx?active=getUserQuestion&userId=17079&isMyselfQuestion=%@",isMyselfQuestion];
    if (lastQuestionID) {
        self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@&feedbackId=%@&categoryId=%@",kHost,userId,isMyselfQuestion,lastQuestionID,categoryId];
    }else{
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@&categoryId=%@",kHost,userId,isMyselfQuestion,categoryId];
    }
    
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
                            if (![[dictionary objectForKey:@"questionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"questionList"]!=nil)  {
                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                NSArray *array_chapterQuestionList =[dictionary objectForKey:@"questionList"];
                                if (array_chapterQuestionList.count>0) {
                                    NSMutableArray *chapterQuestionList = [[NSMutableArray alloc]init];
                                    
                                    for (int i= 0; i<array_chapterQuestionList.count; i++) {
                                        NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
                                        QuestionModel *question = [[QuestionModel alloc]init];
                                        question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
                                        question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionname"]];
                                        question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
                                        question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
                                        question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
                                        question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
                                        question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];

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
                                                    answer.isPraised = [NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isParise"]];
                                                    answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
                                                    answer.IsAnswerAccept =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
                                                    if (answer.IsAnswerAccept && [answer.IsAnswerAccept isEqualToString:@"1"]) {
                                                        question.isAcceptAnswer = @"1";
                                                    }
                                                    answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
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
                                                    
//                                                    for (int index = 0;index < 4;index++) {
//                                                        Reaskmodel *reask = [[Reaskmodel alloc] init];
//                                                        reask.reaskID = [NSString stringWithFormat:@"%d",index];
//                                                        reask.reaskContent = @"今天去哪儿？";
//                                                        reask.reaskDate = @"2013-12-20";
//                                                        reask.reaskingAnswerID = @"123";
//                                                        //对追问的回复
//                                                        reask.reAnswerID = @"132";
//                                                        reask.reAnswerContent = @"去上海外滩观光吧";
//                                                        reask.reAnswerIsAgree = @"1";
//                                                        reask.reAnswerIsTeacher = @"1";
//                                                        reask.reAnswerNickName = @"王大头";
//                                                        [reaskModelArr addObject:reask];
//                                                    }
//                                                    
                                                    
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
                                 [self.delegate getUserQuestionInfoDidFinished:tempDic];
//                                if (tempDic.count>0) {
//                                    [self.delegate getUserQuestionInfoDidFinished:tempDic];
//                                    tempDic = nil;
//                                }
                            }else {
                                [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
                        }
                    }else{
                        [self.delegate getUserQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
                }
            }else {
                [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
            }
        }else {
            [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
        }
    }else {
        [self.delegate getUserQuestionInfoDidFailed:@"加载失败!"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getUserQuestionInfoDidFailed:tipMsg];
    }];
}
@end
