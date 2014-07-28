//
//  LessonInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-10-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"
#import "LessonModel.h"
#import "chapterModel.h"
#import "SectionModel.h"
#import "CommentModel.h"
//我这边统一做了一个status 的定义 ， status=-1;表示漏了参数，msg返回的是"查询超时"   status=0 表示没有查询出数据,msg: 返回的是"未搜索到任何数据"  status=1 表示数据查询成功
@implementation LessonInfoInterface
-(void)downloadLessonInfoWithLessonId:(NSString*)lessonId withUserId:(NSString*)userId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
   
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=lessonInfo&userId=%@&lessonId=%@",kHost,userId,lessonId];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connectMethod:@"GET"];
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
                                LessonModel *lessonModel = [[LessonModel alloc] init];
                                
                                //加载评论列表
                                NSMutableArray *commentArr = [NSMutableArray array];
                                for (NSDictionary *commentDic in [dictionary objectForKey:@"lessonCommentList"]) {
                                    CommentModel *comment = [[CommentModel alloc] init];
                                    comment.commentId= [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentId"]];
                                    comment.commentAuthorId = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentAuthorId"]];
                                    comment.commentAuthorName = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentAuthorName"]];
                                    comment.commentCreateDate = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"CreateDate"]];
                                    comment.commentContent = [NSString stringWithFormat:@"%@",[commentDic objectForKey:@"commentContent"]];
                                    [commentArr addObject:comment];
                                }
                                lessonModel.lessonCommentList = commentArr;
                                
                                //加载课程详细信息
                                if (![[dictionary objectForKey:@"lessonList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"lessonList"]!=nil) {
                                    NSArray *array = [dictionary objectForKey:@"lessonList"];
                                    if (array && array.count > 0) {
                                        NSDictionary *lessonDic = [array lastObject];
                                        lessonModel.lessonId = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonId"]];
                                        lessonModel.lessonCategoryId = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonCategoryId"]];
                                        lessonModel.lessonName = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonName"]];
                                        lessonModel.lessonImageURL = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"sectionImg"]];
                                        lessonModel.lessonStudyProgress = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"studyProgress"]];
                                        lessonModel.lessonDetailInfo = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonDetailInfo"]];
                                        lessonModel.lessonTeacherName = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonTeacherName"]];
                                        lessonModel.lessonDuration = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonDuration"]];
                                        lessonModel.lessonStudyTime = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonStudyTime"]];
                                        lessonModel.lessonScore = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonScore"]];
                                        lessonModel.lessonIsScored = [NSString stringWithFormat:@"%@",[lessonDic objectForKey:@"lessonIsScored"]];
                                        
                                        //设置章节
                                        NSArray *chapterList = [lessonDic objectForKey:@"chapterList"];
                                        NSMutableArray *chapterArr = [NSMutableArray array];
                                        for (NSDictionary *chapterDic in chapterList) {
                                            chapterModel *chapter = [[chapterModel alloc] init];
                                            chapter.chapterId = [NSString stringWithFormat:@"%@",[chapterDic objectForKey:@"chapterId"]];
                                            chapter.chapterName = [NSString stringWithFormat:@"%@",[chapterDic objectForKey:@"chapterName"]];
                                            //设置小节
                                            NSArray *sectionList = [chapterDic objectForKey:@"sectionList"];
                                            NSMutableArray *sectionArr = [NSMutableArray array];
                                            for (NSDictionary *sectionDic in sectionList) {
                                                SectionModel *section = [[SectionModel alloc] init];
                                                section.lessonCategoryId = lessonModel.lessonCategoryId;
                                                section.sectionId = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionId"]];
                                                section.sectionName = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionName"]];
                                                section.sectionMoviePlayURL = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionMoviePlayURL"]];
                                                section.sectionMovieDownloadURL = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionMovieDownloadURL"]];
                                                
                                                [sectionArr addObject:section];
                                            }
                                            chapter.sectionList = sectionArr;
                                            
                                            //设置小节笔记,应该是小节下面笔记
                                            NSArray *noteList = [chapterDic objectForKey:@"lessonNoteList"];
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
                                                [noteArr addObject:note];
                                            }
                                            chapter.chapterNoteList = noteArr;
                                            [chapterArr addObject:chapter];
                                        }
                                        lessonModel.chapterList = chapterArr;
                                    }
                                }
                                
                                [DRFMDBDatabaseTool updateLessonTreeDatasWithUserId:[CaiJinTongManager shared].user.userId withLessonArray:@[lessonModel] withFinished:^(BOOL flag) {
                                     [self.delegate getLessonInfoDidFinished:lessonModel];
                                }];
                               
                            }else {
                                [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                        }
                    }else {
                        [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                    }
                }else {
                    [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
                }
            }else {
                [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
            }
        }else {
            [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
        }
    }else {
        [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getLessonInfoDidFailed:tipMsg];
    }];
}

//地址转换
//+ (NSString *)convertURLString:(NSString *)urlString{
//    NSRange range = [urlString rangeOfString:@"http://v.ku6vms.com/phpvms/player/js/vid/"];
//    if (range.location!=NSNotFound && range.length!=NSNotFound) {
//        NSRange range2 = [urlString rangeOfString:@"/style"];
//        NSString *keyWord = [urlString substringWithRange:NSMakeRange(range.location+range.length, range2.location-range.location-range.length)];
//        NSURL *listUrl = [NSURL URLWithString:[NSString stringWithFormat:@"http://v.ku6vms.com/phpvms/player/getM3U8/vid/%@/v.m3u8",keyWord]];
//        NSError *error;
//        NSString *urlList = [NSString stringWithContentsOfURL:listUrl encoding:NSUTF8StringEncoding error:&error];
//        if (!error) {
//            DLog(@"%@",urlList);
//            NSArray *array = [urlList componentsSeparatedByString:@"#EXTINF:"];
//            
//            NSString *lastObj = [array lastObject];
//            
//            NSMutableString *mutableStr = [NSMutableString stringWithFormat:@"%@",lastObj];
//            
//            NSRange range1 = [mutableStr rangeOfString:@"http://"];
//            [mutableStr deleteCharactersInRange:NSMakeRange(0, range1.location)];
//            
//            NSRange range2 = [mutableStr rangeOfString:@"&ios=1"];
//            [mutableStr deleteCharactersInRange:NSMakeRange(range2.location+range2.length, mutableStr.length-range2.location-range2.length)];
//            
//            NSRange range3 = [mutableStr rangeOfString:@"&start="];
//            NSRange range4 = [mutableStr rangeOfString:@"&end="];
//            [mutableStr replaceCharactersInRange:NSMakeRange(range3.location+range3.length, range4.location-range3.location-range3.length) withString:@"0"];
//            
//            NSRange range5 = [mutableStr rangeOfString:@"&end="];
//            NSRange range6 = [mutableStr rangeOfString:@"&ts="];
//            
//            NSString *timeTotal = [mutableStr substringWithRange:NSMakeRange(range5.location+range5.length, range6.location-range5.location-range5.length)];
//            
//            NSRange range7 = [mutableStr rangeOfString:@"&ios=1"];
//            [mutableStr replaceCharactersInRange:NSMakeRange(range6.location+range6.length, range7.location-range6.location-range6.length) withString:timeTotal];
//            return [NSString stringWithFormat:@"%@",mutableStr];
//        }
//    }else {
//        return urlString;
//    }
//    return  nil;
//}
@end
