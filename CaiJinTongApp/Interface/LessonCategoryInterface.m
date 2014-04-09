//
//  LessonCategoryInterface.m
//  CaiJinTongApp
//
//  Created by david on 13-12-24.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LessonCategoryInterface.h"

@implementation LessonCategoryInterface
-(void)downloadLessonCategoryDataWithUserId:(NSString*)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
//    http://lms.finance365.com/api/ios.ashx?active=lessonCategory&userId=17082
   self.interfaceUrl = [NSString stringWithFormat:@"%@?active=lessonCategory&userId=%@",kHost,userId];
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate

-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [request responseHeaders];
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
                                //课程分类
                                [self.delegate getLessonCategoryDataDidFinished:[LessonCategoryInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"]]];
                            }else {
                                [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getLessonCategoryDataFailure:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
                    }
                }else {
                    [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
                }
            }else {
                [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
            }
        }else {
            [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
        }
    }else {
        [self.delegate getLessonCategoryDataFailure:@"获取课程分类列表失败!"];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getLessonCategoryDataFailure:tipMsg];
    }];
}
+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr{
    NSMutableArray *noteArray = [LessonCategoryInterface getTreeNodeArrayFromArray:arr withLevel:0 withRootContentID:nil];
    [DRFMDBDatabaseTool deleteLessonCategoryListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(BOOL flag) {
        if (flag) {
            [DRFMDBDatabaseTool insertLessonCategoryListWithUserId:[CaiJinTongManager shared].user.userId withLessonCategoryArray:noteArray withFinished:^(BOOL flag) {
                
            }];
        }
    }];
    return noteArray;
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withLevel:(int)level withRootContentID:(NSString*)rootContentID{
    NSMutableArray *notes = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DRTreeNode *note = [[DRTreeNode alloc] init];
        note.noteContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        note.noteContentName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionName"]];
        note.noteLevel = level;
        if (level <= 0 || [note.noteContentID isEqualToString:@"-1"] || [note.noteContentID isEqualToString:@"-3"]) {
            note.noteRootContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        }else{
            note.noteRootContentID = rootContentID;
        }
        note.childnotes = [LessonCategoryInterface getTreeNodeArrayFromArray:[dic objectForKey:@"childCategorys"] withLevel:level+1 withRootContentID:note.noteRootContentID];
        [notes addObject:note];
    }
    return notes;
}
@end
