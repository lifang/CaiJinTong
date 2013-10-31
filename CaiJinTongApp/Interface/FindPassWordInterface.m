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
-(void)getFindPassWordInterfaceDelegateWithName:(NSString *)theName andEmail:(NSString *)theEmail {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"userName"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theEmail] forKey:@"userEmail"];
    
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
