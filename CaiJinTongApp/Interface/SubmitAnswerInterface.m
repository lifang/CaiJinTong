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

-(void)getSubmitAnswerInterfaceDelegateWithUserId:(NSString *)userId andAnswerContent:(NSString *)answerContent andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"answerContent"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
    if (resultId) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
    }
//    http://lms.finance365.com/api/ios.ashx?active=submitAnswer&userId=17079&answerContent=%E5%9B%9E%E7%AD%94%E6%B5%8B%E8%AF%95&questionId=1592&resultId=0
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=submitAnswer&userId=%@&answerContent=%@&questionId=%@&resultId=%@",kHost,userId,answerContent,questionId,resultId];
    
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
                        [self.delegate getSubmitAnswerInfoDidFinished:nil];
                    }else {
                        [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
                    }
                }else {
                    [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
                }
            }else {
                [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
            }
        }else {
            [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
        }
    }else {
        [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSubmitAnswerDidFailed:@"提交信息失败"];
}
@end
