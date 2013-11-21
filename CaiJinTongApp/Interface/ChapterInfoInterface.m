//
//  ChapterInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChapterInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
#import "SectionModel.h"

@implementation ChapterInfoInterface
-(void)getChapterInfoInterfaceDelegateWithUserId:(NSString *)userId andChapterId:(NSString *)chapterId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    if(chapterId != nil) {
        [reqheaders setValue:[NSString stringWithFormat:@"%@",chapterId] forKey:@"chapterId"];
    }else{
        NSLog(@"参数为空,少添加一项");
    }
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=chapterInfo&userId=17079&sectionId=618";
    
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
                            NSDictionary *dictionary =[jsonData objectForKey:@"ReturnObject"];
                            if (dictionary) {
                                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                //章下面视频列表
                                if (![[dictionary objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"sectionList"]!=nil) {
                                    NSArray *array = [dictionary objectForKey:@"sectionList"];
                                    if (array.count>0) {
                                        NSMutableArray *sectionList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array.count; i++) {
                                            NSDictionary *dic_section = [array objectAtIndex:i];
                                            SectionModel *section = [[SectionModel alloc]init];
                                            section.sectionId = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionId"]];
                                            section.sectionImg = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionImg"]];
                                            section.sectionName = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionName"]];
                                            section.sectionProgress = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionProgress"]];
                                            [sectionList addObject:section];
                                        }
//                                        DLog(@"sectionList = %@",sectionList);
                                        if (sectionList.count>0) {
                                            [tempDic setObject:sectionList forKey:@"sectionList"];
                                        }
                                    }
                                }
                                [self.delegate getChapterInfoDidFinished:tempDic];
                                tempDic = nil;
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getChapterInfoDidFailed:@"获取章节列表失败!"];
                        }
                    }else {
                        [self.delegate getChapterInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getChapterInfoDidFailed:@"获取章节列表失败!"];
                }
            }
        }
    }else {
        [self.delegate getChapterInfoDidFailed:@"获取章节列表失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getChapterInfoDidFailed:@"获取章节列表失败!"];
}
@end
