//
//  MyQuestionCategatoryInterface.m
//  CaiJinTongApp
//
//  Created by david on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MyQuestionCategatoryInterface.h"

@implementation MyQuestionCategatoryInterface
-(void)downloadMyQuestionCategoryDataWithUserId:(NSString*)userId withQuestionType:(QuestionAndAnswerScope)scope{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    self.questionScope = scope;
//http://lms.finance365.com/api/ios.ashx?active=getMyQuestionCategory&userId=17082&type=1
    NSString *type= @"1";//1:表示我的提问。2:表示我的回答
    if (scope == QuestionAndAnswerMYANSWER) {
        type = @"2";
    }else if (scope == QuestionAndAnswerMYQUESTION){
    type = @"1";
    }
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getMyQuestionCategory&userId=%@&type=%@",kHost,userId,type];
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
                                if (self.questionScope == QuestionAndAnswerMYANSWER) {
                                    [self.delegate getMyQuestionCategoryDataDidFinished:[MyQuestionCategatoryInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"] withRootContentID:@"-3"] withQuestionType:self.questionScope];
                                }else{
                                [self.delegate getMyQuestionCategoryDataDidFinished:[MyQuestionCategatoryInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"] withRootContentID:@"-1"] withQuestionType:self.questionScope];
                                }
                            }else {
                                [self.delegate getMyQuestionCategoryDataFailure:@"加载我的问答分类失败"];
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
    return [MyQuestionCategatoryInterface getTreeNodeArrayFromArray:arr withLevel:0 withRootContentID:rootContentID];
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