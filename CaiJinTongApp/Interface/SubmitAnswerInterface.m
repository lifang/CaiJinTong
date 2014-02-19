//
//  SubmitAnswerInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SubmitAnswerInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation SubmitAnswerInterface
//answerID:一个答案的id
-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andReaskTyep:(ReaskType)reask andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andResultId:(NSString *)resultId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    self.reaskType = reask;
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
//    http://lms.finance365.com/api/ios.ashx?active=submitAddAnswer&userId=18676&type=3&id=1950&content=aaaaasaddsadsadsad&fid=2120
//   追问：id字段传 AID ，回复追问的时候： id字段传ZID  FID是问题的编号
    switch (self.reaskType) {
        case ReaskType_AnswerForReasking://回复追问
        {
            [reqheaders setValue:[NSString stringWithFormat:@"2"] forKey:@"type"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"fid"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"id"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
            self.interfaceUrl = [NSString stringWithFormat:@"%@?active=submitAddAnswer",kHost];
        }
            break;
        case ReaskType_ModifyAnswer://修改回复
        {
//            lms.finance365.com/api/ios.ashx?active=replyquestion&userId=17082&questionid=&content=
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
             [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionid"];
            self.interfaceUrl = [NSString stringWithFormat:@"%@?active=replyquestion",kHost];
        }
            break;
        case ReaskType_ModifyReask://修改追问
        {
            [reqheaders setValue:[NSString stringWithFormat:@"3"] forKey:@"type"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"fid"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"id"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
            self.interfaceUrl = [NSString stringWithFormat:@"%@?active=submitAddAnswer",kHost];
        }
            break;
            
        case ReaskType_Reask://追问
        {
            [reqheaders setValue:[NSString stringWithFormat:@"1"] forKey:@"type"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"fid"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"id"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
            self.interfaceUrl = [NSString stringWithFormat:@"%@?active=submitAddAnswer",kHost];
        }
            break;
        default:{//回答
            //    http://lms.finance365.com/api/ios.ashx?active=submitAnswer&userId=17079&answerContent=%E5%9B%9E%E7%AD%94%E6%B5%8B%E8%AF%95&questionId=1592&resultId=0
            [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"answerContent"];
            [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
            [reqheaders setValue:@"0" forKey:@"resultId"];
            self.interfaceUrl = [NSString stringWithFormat:@"%@?active=submitAnswer",kHost];
        }
            break;
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
                        [self.delegate getSubmitAnswerInfoDidFinished:nil withReaskType:self.reaskType];
                    }else {
                        [self.delegate getSubmitAnswerDidFailed:@"提交信息失败" withReaskType:self.reaskType];
                    }
                }else {
                    [self.delegate getSubmitAnswerDidFailed:@"提交信息失败" withReaskType:self.reaskType];
                }
            }else {
                [self.delegate getSubmitAnswerDidFailed:@"提交信息失败" withReaskType:self.reaskType];
            }
        }else {
            [self.delegate getSubmitAnswerDidFailed:@"提交信息失败" withReaskType:self.reaskType];
        }
    }else {
        [self.delegate getSubmitAnswerDidFailed:@"提交信息失败" withReaskType:self.reaskType];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getSubmitAnswerDidFailed:tipMsg withReaskType:self.reaskType];
    }];
}
@end
