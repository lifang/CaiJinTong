//
//  SectionInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SectionInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "NoteModel.h"
#import "CommentModel.h"
#import "Section_chapterModel.h"
@implementation SectionInfoInterface

-(void)getSectionInfoInterfaceDelegateWithUserId:(NSString *)userId andSectionId:(NSString *)sectionId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    
//    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=sectionInfo&userId=17082&sectionId=3748";
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=sectionInfo&userId=17082&sectionId=%@",kHost,sectionId?:@""];
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
                                SectionModel *section = [[SectionModel alloc]init];
                                section.sectionId = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionId"]];
                                section.sectionImg = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionImg"]];
                                section.sectionName = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionName"]];
                                section.sectionProgress = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionProgress"]];
                                section.sectionSD = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionSD"]];
                                section.sectionHD = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionHD"]];
                                section.sectionScore = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionScore"]];
                                section.isGrade = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"isGrade"]];
                                section.lessonInfo = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"lessonInfo"]];
                                section.sectionTeacher = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionTeacher"]];
                                section.sectionDownload = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionDownload"]];
                                section.sectionStudy = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionStudy"]];
                                section.sectionLastTime = [NSString stringWithFormat:@"%@",[dictionary objectForKey:@"sectionLastTime"]];
            
                                //笔记列表
                                if (![[dictionary objectForKey:@"noteList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"noteList"]!=nil) {
                                    NSArray *array_note = [dictionary objectForKey:@"noteList"];
                                    if (array_note.count>0) {
                                        section.noteList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array_note.count; i++) {
                                            NSDictionary *dic_note = [array_note objectAtIndex:i];
                                            NoteModel *note = [[NoteModel alloc]init];
                                            note.noteId = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteId"]];
                                            note.noteTime = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteTime"]];
                                            note.noteText = [NSString stringWithFormat:@"%@",[dic_note objectForKey:@"noteText"]];
                                            [section.noteList addObject:note];
                                        }
                                    }
                                }
                                //评论列表
                                if (![[dictionary objectForKey:@"commentList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"commentList"]!=nil) {
                                    NSArray *array_comment = [dictionary objectForKey:@"commentList"];
                                    if (array_comment.count>0) {
                                        section.commentList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array_comment.count; i++) {
                                            NSDictionary *dic_comment = [array_comment objectAtIndex:i];
                                            CommentModel *comment = [[CommentModel alloc]init];
                                            comment.nickName = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"nickName"]];
                                            comment.time = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"time"]];
                                            comment.content = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"content"]];
                                            comment.pageIndex = [[dic_comment objectForKey:@"pageIndex"]intValue];
                                            comment.pageCount = [[dic_comment objectForKey:@"pageCount"]intValue];
                                            [section.commentList addObject:comment];
                                        }
                                    }
                                }
                                //章节目录
                                if (![[dictionary objectForKey:@"sectionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"sectionList"]!=nil) {
                                    NSArray *array_section = [dictionary objectForKey:@"sectionList"];
                                    if (array_section.count>0) {
                                        section.sectionList = [[NSMutableArray alloc]init];
                                        for (int i=0; i<array_section.count; i++) {
                                            NSDictionary *dic_section = [array_section objectAtIndex:i];
                                            Section_chapterModel *section_chapter = [[Section_chapterModel alloc]init];
                                            section_chapter.sectionId = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionId"]];
                                            section_chapter.sectionDownload = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionDownload"]];
                                            section_chapter.sectionName = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionName"]];
                                            section_chapter.sectionLastTime = [NSString stringWithFormat:@"%@",[dic_section objectForKey:@"sectionLastTime"]];
                                            [section.sectionList addObject:section_chapter];
                                        }
                                    }
                                    DLog(@"se = %@",section.sectionList);
                                }
                                if (section) {
                                    [self.delegate getSectionInfoDidFinished:section];
                                    section = nil;
                                }
                            }else {
                                [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
                        }
                    }else {
                        [self.delegate getSectionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
                }
            }else {
                [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
            }
        }else {
            [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
        }
    }else {
        [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSectionInfoDidFailed:@"获取视频详细信息失败!"];
}
@end
