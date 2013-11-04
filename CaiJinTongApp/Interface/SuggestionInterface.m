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
-(void)getAskQuestionInterfaceDelegateWithUserId:(NSString *)userId andSuggestionContent:(NSString *)suggestionContent andSuggestionTime:(NSString *)suggestionTime{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",suggestionContent]
                  forKey:@"suggestionContent"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",suggestionTime] forKey:@"suggestionTime"];
    self.interfaceUrl = [NSString stringWithFormat:@"%@",kHost];
    
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
                            //                            NSDictionary *dictionary =[jsonData objectForKey:@"ReturnObject"];
                        }
                        @catch (NSException *exception) {
                            
                        }
                    }
                }else {
                    
                }
            }
        }
    }else {
        
    }
}
-(void)requestIsFailed:(NSError *)error{
    
}

@end
