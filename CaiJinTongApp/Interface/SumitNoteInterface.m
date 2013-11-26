//
//  SumitNoteInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SumitNoteInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation SumitNoteInterface

-(void)getSumitNoteInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andNoteTime:(NSString *)noteTime andNoteText:(NSString *)noteText{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",noteText] forKey:@"noteText"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",noteTime] forKey:@"noteTime"];

    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=submitNote&userId=17082&sectionId=2690&noteTime=2013-11-21 11:00&noteText=做笔记";
    
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
                            [self.delegate getSumitNoteInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSumitNoteDidFailed:@"笔记提交失败!"];
                        }
                    }else {
                        [self.delegate getSumitNoteDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getSumitNoteDidFailed:@"连接失败!"];
                }
            }
        }
    }else {
        [self.delegate getSumitNoteDidFailed:@"连接失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSumitNoteDidFailed:@"连接失败!"];
}
@end
