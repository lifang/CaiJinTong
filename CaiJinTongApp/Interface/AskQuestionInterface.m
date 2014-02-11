//
//  AskQuestionInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "AskQuestionInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation AskQuestionInterface
-(void)getAskQuestionInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andQuestionName:(NSString *)questionName andQuestionContent:(NSString *)content{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionName] forKey:@"title"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
//    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=askQuestion&userId=17079&sectionId=42&title=ios接口测试&content=IOS接口测试测试";
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=askQuestion",kHost];
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
                            [self.delegate getAskQuestionInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getAskQuestionDidFailed:@"请求失败!"];
                        }
                    }else {
                        [self.delegate getAskQuestionDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getAskQuestionDidFailed:@"请求失败!"];
                }
            }else {
                [self.delegate getAskQuestionDidFailed:@"请求失败!"];
            }
        }else {
            [self.delegate getAskQuestionDidFailed:@"请求失败!"];
        }
    }else {
        [self.delegate getAskQuestionDidFailed:@"请求失败!"];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getAskQuestionDidFailed:tipMsg];
    }];
}
@end
