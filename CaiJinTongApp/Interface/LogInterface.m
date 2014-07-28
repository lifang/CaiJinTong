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
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"userName"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",thePassWord] forKey:@"passWord"];
#if kRunScopeTest
    self.interfaceUrl = @"http://i-finance365-com-5we3gmhhky2y.runscope.net/_3G/LogIn";
#else
    self.interfaceUrl = @"http://i.finance365.com/_3G/LogIn";
#endif
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectLogin];
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
                if (jsonData) {
                    if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                        @try {
                            NSDictionary *staff = [jsonData objectForKey:@"ReturnObject"];
                            [self.delegate getLogInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLogInfoDidFailed:@"登录失败!"];
                        }
                    }else{
                        [self.delegate getLogInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getLogInfoDidFailed:@"登录失败!"];
                }
            }else{
                [self.delegate getLogInfoDidFailed:@"服务器连接失败，请稍后再试!"];
            }
        }else{
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSLog(@"%@",str);
            [self.delegate getLogInfoDidFailed:@"服务器连接失败，请稍后再试!"];
        }
    }else {
        [self.delegate getLogInfoDidFailed:@"登录失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    NSLog(@"%@",error);
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getLogInfoDidFailed:tipMsg];
    }];
//    [self.delegate getLogInfoDidFailed:@"登录失败!"];
}


@end
