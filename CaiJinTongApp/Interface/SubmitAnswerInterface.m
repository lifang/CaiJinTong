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
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"answerContent"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
    if (resultId) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",resultId] forKey:@"resultId"];
    }
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
