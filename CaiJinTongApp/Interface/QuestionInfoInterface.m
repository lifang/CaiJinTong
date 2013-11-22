//
//  QuestionInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "LessonQuestionModel.h"
#import "ChapterQuestionModel.h"
#import "QuestionModel.h"
#import "AnswerModel.h"
@implementation QuestionInfoInterface

-(void)getQuestionInfoInterfaceDelegateWithUserId:(NSString *)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=getQuestionCategory&userId=18676";
    
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
                                [self.delegate getQuestionInfoDidFinished:dictionary];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                        }
                    }else {
                        [self.delegate getQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                }
            }
        }
    }else {
        [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
}
@end
