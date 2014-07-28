//
//  LearningMatarilasCategoryInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-1-16.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "LearningMatarilasCategoryInterface.h"

@implementation LearningMatarilasCategoryInterface
-(void)downloadLearningMatarilasCategoryDataWithUserId:(NSString*)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
//    http://lms.finance365.com/api/ios.ashx?active=getkmcategory&userId=17082
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getkmcategory&userId=%@",kHost,userId];
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
                                [self.delegate getLearningMatarilasCategoryDataDidFinished:[LearningMatarilasCategoryInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"]]];
                            }else {
                                [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getLearningMatarilasCategoryDataFailure:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
                        }
                }else {
                    [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
                }
            }else {
                [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
            }
        }else {
            [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
        }
    }else {
        [self.delegate getLearningMatarilasCategoryDataFailure:@"获取课程分类列表失败!"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getLearningMatarilasCategoryDataFailure:tipMsg];
    }];
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr{
    NSMutableArray *mutableArray = [LearningMatarilasCategoryInterface getTreeNodeArrayFromArray:arr withLevel:0 withRootContentID:nil];
    DRTreeNode *note = [[DRTreeNode alloc] init];
    note.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_ALL];
    note.noteContentName = @"全部";
    note.noteLevel = 0;
    [mutableArray insertObject:note atIndex:0];
    [DRFMDBDatabaseTool deleteMaterialCategoryListWithUserId:[CaiJinTongManager shared].user.userId withFinished:^(BOOL flag) {
        if (flag) {
            [DRFMDBDatabaseTool insertMaterialCategoryListWithUserId:[CaiJinTongManager shared].user.userId withMaterialCategoryArray:mutableArray withFinished:^(BOOL flag) {
                
            }];
        }
    }];
    
    return mutableArray;
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
        note.childnotes = [LearningMatarilasCategoryInterface getTreeNodeArrayFromArray:[dic objectForKey:@"childCategorys"] withLevel:level+1 withRootContentID:note.noteRootContentID];
        [notes addObject:note];
    }
    return notes;
}
@end
