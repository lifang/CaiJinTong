//
//  GradeInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "GradeInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation GradeInterface

-(void)getGradeInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andScore:(NSString *)score andContent:(NSString *)content {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    if (score) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",score] forKey:@"score"];
    }
    if (content) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
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
                            NSDictionary *dictionary =[jsonData objectForKey:@"ReturnObject"];
                            if (dictionary) {
                                [self.delegate getGradeInfoDidFinished:dictionary];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getGradeInfoDidFailed:@"打分失败!"];
                        }
                    }
                }else {
                    [self.delegate getGradeInfoDidFailed:@"打分失败!"];
                }
            }
        }
    }else {
        [self.delegate getGradeInfoDidFailed:@"打分失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getGradeInfoDidFailed:@"打分失败!"];
}
@end
