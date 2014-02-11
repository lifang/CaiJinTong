//
//  AcceptAnswerInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "AcceptAnswerInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation AcceptAnswerInterface

-(void)getAcceptAnswerInterfaceDelegateWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andCorrectAnswerID:(NSString*)correctAnswerID{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"answerId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",correctAnswerID] forKey:@"resultId"];
//    http://wmi.finance365.com/api/ios.ashx?active=acceptAnswer&userId=17079&questionId=1263&answerId=20744&resultId=1647
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=acceptAnswer",kHost];
    
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
                    [self.delegate getAcceptAnswerInfoDidFinished:nil];
                }else {
                    [self.delegate getAcceptAnswerInfoDidFailed:@"采纳答案提交失败"];
                }
            }else {
                [self.delegate getAcceptAnswerInfoDidFailed:@"采纳答案提交失败"];
            }
        }else {
            [self.delegate getAcceptAnswerInfoDidFailed:@"采纳答案提交失败"];
        }
    }else {
        [self.delegate getAcceptAnswerInfoDidFailed:@"采纳答案提交失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getAcceptAnswerInfoDidFailed:tipMsg];
    }];
}
@end
