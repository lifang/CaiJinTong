//
//  QuestionInfoInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionInfoInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "LessonQuestionModel.h"
#import "ChapterQuestionModel.h"
#import "QuestionModel.h"
#import "AnswerModel.h"
@implementation QuestionInfoInterface

-(void)getQuestionInfoInterfaceDelegateWithUserId:(NSString *)userId {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    
//    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=getQuestionCategory&userId=18676";
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=getQuestionCategory&userId=%@",kHost,userId];
    self.baseDelegate = self;
    self.headers = reqheaders;
    [self connect];
}

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
                                [self.delegate getQuestionInfoDidFinished:[QuestionInfoInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"]]];
                            }else {
                                [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
                        }
                    }else
                        if ([[jsonData objectForKey:@"Status"]intValue] == 0){
                            [self.delegate getQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                        } else {
                            [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
                        }
                }else {
                    [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
                }
            }else {
                [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
            }
        }else {
            [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
        }
    }else {
        [self.delegate getQuestionInfoDidFailed:@"加载所有问答失败"];
    }
}


-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getQuestionInfoDidFailed:tipMsg];
    }];
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr{
    NSMutableArray *array = [QuestionInfoInterface getTreeNodeArrayFromArray:arr withLevel:1 withRootContentID:[NSString stringWithFormat:@"%d",CategoryType_AllQuestion]];
    return array;
}

+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withLevel:(int)level withRootContentID:(NSString*)rootContentID{
    NSMutableArray *notes = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DRTreeNode *note = [[DRTreeNode alloc] init];
        note.noteContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        note.noteContentName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionName"]];
        note.noteLevel = level;
        note.noteRootContentID = rootContentID;
        note.childnotes = [QuestionInfoInterface getTreeNodeArrayFromArray:[dic objectForKey:@"questionNode"] withLevel:level+1 withRootContentID:note.noteRootContentID];
        [notes addObject:note];
    }
    return notes;
}


@end
