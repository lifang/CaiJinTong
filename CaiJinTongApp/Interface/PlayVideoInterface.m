//
//  PlayVideoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PlayVideoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation PlayVideoInterface
static PlayVideoInterface *defaultPlayVideoInter = nil;
+(id)defaultPlayVideoInterface{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultPlayVideoInter = [[PlayVideoInterface alloc] init];
    });
    return defaultPlayVideoInter;
}
-(void)getPlayVideoInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andTimeStart:(NSString *)timeStart {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timeStart] forKey:@"timeStart"];
//    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=playVideo&userId=17082&sectionId=2690&timeStart=2013-11-20 15:52";
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=playVideo&userId=%@&sectionId=%@&timeStart=%@",kHost,userId,sectionId,timeStart];
//    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=playVideo&userId=17082&sectionId=%@&timeStart=%@",kQuestHost,sectionId,timeStart];
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
                            
                            [self.delegate getPlayVideoInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getPlayVideoInfoDidFailed:@"加载数据失败!"];
                        }
                    }else {
                        [self.delegate getPlayVideoInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getPlayVideoInfoDidFailed:@"加载数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getPlayVideoInfoDidFailed:@"加载数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPlayVideoInfoDidFailed:@"加载数据失败!"];
}

@end
