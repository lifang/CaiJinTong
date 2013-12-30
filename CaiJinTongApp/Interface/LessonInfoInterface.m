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
//    http://lms.finance365.com/api/ios.ashx?active=lessonInfo&userId=17082&lessonId=181
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
                                                section.sectionId = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionId"]];
                                                section.sectionName = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionName"]];
                                                section.sectionMoviePlayURL = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionMoviePlayURL"]];
                                                section.sectionMovieDownloadURL = [NSString stringWithFormat:@"%@",[sectionDic objectForKey:@"sectionMovieDownloadURL"]];
                                                //设置小节笔记
                                                NSArray *noteList = [sectionDic objectForKey:@"sectionNoteList"];
                                                NSMutableArray *noteArr = [NSMutableArray array];
                                                for (NSDictionary *noteDic in noteList) {
                                                    NoteModel *note = [[NoteModel alloc] init];
                                                    
                                                    [noteArr addObject:note];
                                                }
                                                section.sectionNoteList = noteArr;
                                                [sectionArr addObject:section];
                                            }
                                            chapter.sectionList = sectionArr;
                                            
                                            //设置小节笔记,应该是小节下面笔记
                                            NSArray *noteList = [chapterDic objectForKey:@"lessonNoteList"];
                                            NSMutableArray *noteArr = [NSMutableArray array];
                                            for (NSDictionary *noteDic in noteList) {
                                                NoteModel *note = [[NoteModel alloc] init];
                                                
                                                [noteArr addObject:note];
                                            }
                                            chapter.chapterNoteList = noteArr;
                                            [chapterArr addObject:chapter];
                                        }
                                        lessonModel.chapterList = chapterArr;
                                    }
                                }
                                
                                [self.delegate getLessonInfoDidFinished:lessonModel];
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
    [self.delegate getLessonInfoDidFailed:@"获取课程列表失败!"];
}
@end
