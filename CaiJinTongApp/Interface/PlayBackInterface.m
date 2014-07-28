//
//  PlayBackInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PlayBackInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
@implementation PlayBackInterface
//status: incomplete:表示正在进行, completed:表示视频已经播放完毕   就是播放状态，没播放完成传incomplete    课程播放结束传  completed
-(void)getPlayBackInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId andTimeEnd:(NSString *)timeEnd andStatus:(NSString *)status andStartPlayDate:(NSString*)startPlayDate{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",timeEnd] forKey:@"timeEnd"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",status] forKey:@"status"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",startPlayDate] forKey:@"startPlayDate"];

    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=playBack",kHost];
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
                            [self.delegate getPlayBackInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getPlayBackDidFailed:@""];
                        }
                    }else {
                        [self.delegate getPlayBackDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getPlayBackDidFailed:@""];
                }
            }else {
                [self.delegate getPlayBackDidFailed:@""];
            }
        }else {
            [self.delegate getPlayBackDidFailed:@""];
        }
    }else {
        [self.delegate getPlayBackDidFailed:@""];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getPlayBackDidFailed:tipMsg];
    }];
}
@end
