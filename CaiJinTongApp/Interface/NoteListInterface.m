//
//  NoteListInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-7.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "NoteListInterface.h"

@implementation NoteListInterface
#if kUsingTestData
-(void)downloadNoteListWithUserId:(NSString*)userId withPageIndex:(int)pageIndex{
    NSString *path = [NSBundle pathForResource:@"noteList" ofType:@"geojson" inDirectory:[[NSBundle mainBundle] bundlePath]];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *str =[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    __block id jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self parseJsonData:jsonData];
    });
}
#else
-(void)downloadNoteListWithUserId:(NSString*)userId withPageIndex:(int)pageIndex{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    //    http://lms.finance365.com/api/ios.ashx?active=noteList&userId=17082&pageIndex=0
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=noteList&userId=%@&pageIndex=%d",kHost,userId,pageIndex+1];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#endif

#pragma mark - BaseInterfaceDelegate

-(void)parseJsonData:(id)jsonObject{
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"data = %@",jsonData);
            if (jsonData) {
                if ([[jsonData objectForKey:@"Status"]intValue] == 1) {
                    @try {
                        //设置小节笔记,应该是小节下面笔记
                        NSArray *noteList = [jsonData objectForKey:@"ReturnObject"];
                        NSMutableArray *noteArr = [NSMutableArray array];
                        for (NSDictionary *noteDic in noteList) {
                            NoteModel *note = [[NoteModel alloc] init];
                            note.noteId = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"noteId"]];
                            note.noteTime = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"noteCreateDate"]];
                            note.noteText = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"noteContent"]];
                            note.noteSectionId = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"sectionId"]];
                            note.noteSectionName = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"sectionName"]];
                            note.noteSectionMoviePlayURL = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"sectionMoviePlayURL"]];
                            note.noteChapterId = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"chapterId"]];
                            note.noteChapterName = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"chapterName"]];
                            note.noteLessonId = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"lessonId"]];
                            note.noteLessonName = [NSString stringWithFormat:@"%@",[noteDic objectForKey:@"lessonName"]];
                            
                            [noteArr addObject:note];
                        }
                        [self.delegate getNoteListDataDidFinished:noteArr withCurrentPageIndex:0 withTotalCount:0];
                    }
                    @catch (NSException *exception) {
                        [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
                    }
                }else
                    if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                        [self.delegate getNoteListDataFailure:[jsonData objectForKey:@"Msg"]];
                    } else {
                        [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
                    }
            }else {
                [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
            }
        }else {
            [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
        }
    }else {
        [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
    }
}
-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        [self parseJsonData:jsonObject];
    }else {
        [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getNoteListDataFailure:@"获取笔记列表失败"];
}

@end
