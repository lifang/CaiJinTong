//
//  DeleteNoteInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "DeleteNoteInterface.h"
@implementation DeleteNoteInterface

#if kUsingTestData
-(void)deleteNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId{
    NSString *path = [NSBundle pathForResource:@"DeleteNote" ofType:@"geojson" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self parseJsonData:jsonData];
    });
}
#else
-(void)deleteNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    //http://lms.finance365.com/api/ios.ashx?active=deleteNote&userId=17082&noteId=123
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=deleteNote&userId=%@&noteId=%@",kHost,userId,noteId];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#endif

-(void)parseJsonData:(id)jsonObject{
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"data = %@",jsonData);
            if (jsonData) {
                if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                    [self.delegate deleteNoteDidFinished:@"笔记删除成功"];
                }else
                    if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                        [self.delegate deleteNoteFailure:[jsonData objectForKey:@"Msg"]];
                    } else {
                        [self.delegate deleteNoteFailure:@"删除笔记失败"];
                    }
            }else {
                [self.delegate deleteNoteFailure:@"删除笔记失败"];
            }
        }else {
            [self.delegate deleteNoteFailure:@"删除笔记失败"];
        }
    }else {
        [self.delegate deleteNoteFailure:@"删除笔记失败"];
    }
}

#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self parseJsonData:jsonObject];
    }else {
        [self.delegate deleteNoteFailure:@"删除笔记失败"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate deleteNoteFailure:tipMsg];
    }];
}
@end