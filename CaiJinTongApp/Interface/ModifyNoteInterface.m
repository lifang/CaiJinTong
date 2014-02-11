//
//  ModifyNoteInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "ModifyNoteInterface.h"

@implementation ModifyNoteInterface

#if kUsingTestData
-(void)modifyNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId withNoteContent:(NSString*)noteContent{
    NSString *path = [NSBundle pathForResource:@"ModifyNote" ofType:@"geojson" inDirectory:[[NSBundle mainBundle] bundlePath]];
    self.modifyContent = noteContent;
    NSData *data = [NSData dataWithContentsOfFile:path];
    id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self parseJsonData:jsonData];
    });
}
#else
-(void)modifyNoteWithUserId:(NSString*)userId withNoteId:(NSString*)noteId withNoteContent:(NSString*)noteContent{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",noteId] forKey:@"noteId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",noteContent] forKey:@"noteContent"];
    self.modifyContent = noteContent;
    //http://lms.finance365.com/api/ios.ashx?active=modifyNote&userId=17082&noteId=123&noteContent=jhdhffjiofj
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=modifyNote",kHost];
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
                    [self.delegate modifyNoteDidFinished:@"笔记修改成功"];
                }else
                    if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                        [self.delegate modifyNoteFailure:[jsonData objectForKey:@"Msg"]];
                    } else {
                        [self.delegate modifyNoteFailure:@"修改笔记失败"];
                    }
            }else {
                [self.delegate modifyNoteFailure:@"修改笔记失败"];
            }
        }else {
            [self.delegate modifyNoteFailure:@"修改笔记失败"];
        }
    }else {
        [self.delegate modifyNoteFailure:@"修改笔记失败"];
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
        [self.delegate modifyNoteFailure:@"修改笔记失败"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate modifyNoteFailure:tipMsg];
    }];
}
@end
