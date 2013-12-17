//
//  AnswerListInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "AnswerListInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "AnswerModel.h"

@implementation AnswerListInterface
-(void)getAnswerListInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andLastAnswerID:(NSString*)lastAnswerID{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
//    http://wmi.finance365.com/api/ios.ashx?active=answerList&userId=17079&questionId=1263&pageIndex=1
    if (lastAnswerID) {
        self.interfaceUrl = [NSString stringWithFormat:@"%@active=answerList&userId=%@&questionId=%@&pageIndex=%@",kHost,userId,questionId,lastAnswerID];
    }else{
        self.interfaceUrl = [NSString stringWithFormat:@"%@active=answerList&userId=%@&questionId=%@",kHost,userId,questionId];
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
                            if (dictionary) {
                                QuestionModel *question = [[QuestionModel alloc]init];
                                question.questionId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"questionId"]];
                                question.pageIndex =[[dictionary objectForKey:@"pageIndex"]intValue];
                                question.pageCount =[[dictionary objectForKey:@"pageCount"]intValue];
                                
                                if (![[dictionary objectForKey:@"answerList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"answerList"]!=nil) {
                                    NSArray *array_answer = [dictionary objectForKey:@"answerList"];
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
                                if (question) {
                                    [self.delegate getAnswerListInfoDidFinished:question];
                                }
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getAnswerListInfoDidFailed:@"加载失败!"];
                        }
                    }
                }else {
                    [self.delegate getAnswerListInfoDidFailed:@"加载失败!"];
                }
            }
        }
    }else {
        [self.delegate getAnswerListInfoDidFailed:@"加载失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getAnswerListInfoDidFailed:@"加载失败!"];
}
@end
