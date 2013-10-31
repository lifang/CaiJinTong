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
//        NSString *result = [resultHeaders objectForKey:@"result"];
//        if ([result isEqualToString:@"success"]) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject !=nil) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *jsonData=(NSDictionary *)jsonObject;
                DLog(@"data = %@",jsonData);
            }
        }
//            NSString *jsonStr = [[NSString alloc] initWithString:[request responseString]];
//        DLog(@"jsonStr = %@",jsonStr);
//            id jsonObj; //= [jsonStr objectFromJSONString];
//            [jsonStr release];
//        
//            if (jsonObj) {
//                @try {
//                }
//                @catch (NSException *exception) {
//                    
//                }
//            }
//        }
    }
}
-(void)requestIsFailed:(NSError *)error{

}

@end
