//
//  EditInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "EditInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation EditInfoInterface
-(void)getEditInfoInterfaceDelegateWithUserId:(NSString *)userId andBirthday:(NSString *)birthday andSex:(NSString *)sex andAddress:(NSString *)address andImage:(NSData *)image  withNickName:(NSString*)nickName{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    NSString *timespan = [Utility getNowDateFromatAnDate];
    NSString *strKey = [NSString stringWithFormat:@"%@%@",timespan,MDKey];
    NSString *md5Key = [Utility createMD5:strKey];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timespan] forKey:@"timespan"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",md5Key] forKey:@"token"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",birthday] forKey:@"birthday"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sex] forKey:@"sex"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",address] forKey:@"address"];
     [reqheaders setValue:[NSString stringWithFormat:@"%@",address] forKey:@"nickname"];
//    [reqheaders setValue:image forKey:@"userImg"];
    
    self.interfaceUrl = @"http://i.finance365.com/_3G/EditInfo";
    
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
                if (jsonData) {
                    if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                        @try {
                            NSDictionary *staff = [jsonData objectForKey:@"ReturnObject"];
                            [self.delegate getEditInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getEditInfoDidFailed:@"登录失败!"];
                        }
                    }else if ([[jsonData objectForKey:@"Status"]intValue] == 3) {
                        [self.delegate getEditInfoDidFailed:@"请求过期!"];
                    }
                }else {
                    [self.delegate getEditInfoDidFailed:@"登录失败!"];
                }
            }
        }
    }else {
        [self.delegate getEditInfoDidFailed:@"登录失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getEditInfoDidFailed:@"登录失败!"];
}



@end
