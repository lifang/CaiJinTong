//
//  MyQuestionCategatoryInterface.m
//  CaiJinTongApp
//
//  Created by david on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionCategatoryInterface.h"

@implementation MyQuestionCategatoryInterface
-(void)downloadMyQuestionCategoryDataWithUserId:(NSString*)userId{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
//    http://lms.finance365.com/api/ios.ashx?active=getMyQuestionCategory&userId=17082
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getMyQuestionCategory&userId=%@",kHost,userId];
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
                            NSArray *questionCategory =nil;
                            if (dictionary) {
                                //课程分类
                                questionCategory = [MyQuestionCategatoryInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"mycategoryList"] withRootContentID:@"-1"];
                            }
                            
                            NSArray *myAnswerCategoryArr = [MyQuestionCategatoryInterface getTreeNodeArrayFromArray:[jsonData objectForKey:@"myanswercategoryList"] withRootContentID:@"-3"];
                            if (self.delegate && [self.delegate respondsToSelector:@selector(getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:withMyQuestionCategorynodes:)]) {
                                [self.delegate getMyQuestionCategoryDataDidFinishedWithMyAnswerCategorynodes:myAnswerCategoryArr withMyQuestionCategorynodes:questionCategory];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getMyQuestionCategoryDataFailure:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
                        }
                }else {
                    [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
                }
            }else {
                [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
            }
        }else {
            [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
        }
    }else {
        [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withRootContentID:(NSString*)rootContentID{
    return [MyQuestionCategatoryInterface getTreeNodeArrayFromArray:arr withLevel:2 withRootContentID:rootContentID];
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withLevel:(int)level withRootContentID:(NSString*)rootContentID{
    NSMutableArray *notes = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DRTreeNode *note = [[DRTreeNode alloc] init];
        note.noteContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        note.noteContentName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionName"]];
        note.noteLevel = level;
        note.noteRootContentID = rootContentID;
        note.childnotes = [MyQuestionCategatoryInterface getTreeNodeArrayFromArray:[dic objectForKey:@"questionNode"] withLevel:level+1 withRootContentID:note.noteRootContentID];
        [notes addObject:note];
    }
    return notes;
}
@end