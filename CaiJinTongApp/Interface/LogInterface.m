//
//  LogInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "LogInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation LogInterface

-(void)getLogInterfaceDelegateWithName:(NSString *)theName andPassWord:(NSString *)thePassWord {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"user_name"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",thePassWord] forKey:@"user_password"];
    
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
                    NSString *text = [jsonData objectForKey:@"info"];
                    if (text.length == 0) {
                        @try {
                            NSDictionary *staff = [jsonData objectForKey:@"staff"];
                            [self.delegate getLogInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLogInfoDidFailed:@"登录失败!"];
                        }
                    }
                }else {
                    
                }
            }
        }
    }else {
        [self.delegate getLogInfoDidFailed:@"登录失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getLogInfoDidFailed:@"登录失败!"];
}

@end
