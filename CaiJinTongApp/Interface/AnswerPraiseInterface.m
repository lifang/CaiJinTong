//
//  AnswerPraiseInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "AnswerPraiseInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation AnswerPraiseInterface

-(void)getAnswerPraiseInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andResultId:(NSString *)resultId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
    
//    http://wmi.finance365.com/api/ios.ashx?active=answerPraise&userId=18676&questionId=2165&resultId=2029
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=answerPraise&userId=%@&questionId=%@&resultId=%@",kHost,userId,questionId,resultId];
    
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
                        [self.delegate getAnswerPraiseInfoDidFinished:nil];
                    }else {
                        [self.delegate getAnswerPraiseInfoDidFailed:@"提交失败"];
                }
            }else {
                [self.delegate getAnswerPraiseInfoDidFailed:@"提交失败"];
            }
        }else {
            [self.delegate getAnswerPraiseInfoDidFailed:@"提交失败"];
        }
    }else {
        [self.delegate getAnswerPraiseInfoDidFailed:@"提交失败"];
    }
}
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getAnswerPraiseInfoDidFailed:@"提交失败"];
}
@end
