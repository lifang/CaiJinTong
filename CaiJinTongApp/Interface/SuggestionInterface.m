//
//  SuggestionInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SuggestionInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation SuggestionInterface
-(void)getAskQuestionInterfaceDelegateWithUserId:(NSString *)userId andSuggestionContent:(NSString *)suggestionContent{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",suggestionContent]
                  forKey:@"content"];
    
    self.interfaceUrl = @"http://i.finance365.com/_3G/AddAdvice";

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
                DLog(@"%@",[jsonData objectForKey:@"Msg"]);
                if (jsonData) {
                    if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                        @try {
                            [self.delegate getSuggestionInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSuggestionInfoDidFailed:@"上传失败"];
                        }
                    }else {
                        [self.delegate getSuggestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getSuggestionInfoDidFailed:@"上传失败"];
                }
            }
        }
    }else {
        [self.delegate getSuggestionInfoDidFailed:@"上传失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSuggestionInfoDidFailed:@"上传失败"];
}

@end
