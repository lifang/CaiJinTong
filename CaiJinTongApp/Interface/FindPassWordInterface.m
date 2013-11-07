//
//  FindPassWordInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "FindPassWordInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

@implementation FindPassWordInterface
-(void)getFindPassWordInterfaceDelegateWithName:(NSString *)theName{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"userName"];
    
    self.interfaceUrl = @"http://i.finance365.com/_3G/FindPassword";
    
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
                            NSDictionary *staff = [jsonData objectForKey:@"ReturnObject"];
                            [self.delegate getFindPassWordInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getFindPassWordInfoDidFailed:@"加载失败!"];
                        }
                    }else if ([[jsonData objectForKey:@"Status"]intValue] == 3) {
                        [self.delegate getFindPassWordInfoDidFailed:@"请求过期!"];
                    }
                }else {
                    [self.delegate getFindPassWordInfoDidFailed:@"加载失败!"];
                }
            }
        }
    }else {
        [self.delegate getFindPassWordInfoDidFailed:@"加载失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getFindPassWordInfoDidFailed:@"加载失败!"];
}

@end
