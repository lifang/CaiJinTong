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
    
    self.interfaceUrl = @"http://lms.finance365.com/api/ios.ashx?active=getQuestionCategory&userId=18676";
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}
#pragma mark - BaseInterfaceDelegate
-(NSMutableDictionary *)setDictionary:(NSDictionary *)dic WithLevel:(int)level{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    [mutableDic setObject:[NSString stringWithFormat:@"%d",level] forKey:@"level"];
    return mutableDic;
}
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
                                if (![[dictionary objectForKey:@"questionList"]isKindOfClass:[NSNull class]] && [dictionary objectForKey:@"questionList"]!=nil) {
                                    NSMutableArray *array_chapterQuestionList =[NSMutableArray arrayWithArray:[dictionary objectForKey:@"questionList"]];
                                    if (array_chapterQuestionList.count>0) {
                                        for (int i= 0; i<array_chapterQuestionList.count; i++) {
                                            int level = 2;
                                            //层级1
                                            NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
                                            NSMutableDictionary *dic = [self setDictionary:question_dic WithLevel:level];
                                            //层级2
                                            NSMutableArray *array2 = [NSMutableArray arrayWithArray:[dic objectForKey:@"questionNode"]];
                                            if (array2.count>0) {
                                                int level2 = 4;
                                                for (int j=0; j<array2.count; j++) {
                                                    NSDictionary *question_dic2 = [array2 objectAtIndex:j];
                                                    NSMutableDictionary *dic2 = [self setDictionary:question_dic2 WithLevel:level2];
                                                    //层级3
                                                    NSMutableArray *array3 = [NSMutableArray arrayWithArray:[dic2 objectForKey:@"questionNode"]];
                                                    if (array3.count>0) {
                                                        int level3 = 6;
                                                        for (int m=0; m<array3.count; m++) {
                                                            NSDictionary *question_dic3 = [array3 objectAtIndex:m];
                                                            NSMutableDictionary *dic3 = [self setDictionary:question_dic3 WithLevel:level3];
                                                            //层级4
                                                            NSMutableArray *array4 = [NSMutableArray arrayWithArray:[dic3 objectForKey:@"questionNode"]];
                                                            if (array4.count>0) {
                                                                int level4 = 8;
                                                                for (int n=0; n<array4.count; n++) {
                                                                    NSDictionary *question_dic4 = [array4 objectAtIndex:m];
                                                                    NSMutableDictionary *dic4 = [self setDictionary:question_dic4 WithLevel:level4];
                                                                    //层级5
                                                                    NSMutableArray *array5 = [NSMutableArray arrayWithArray:[dic4 objectForKey:@"questionNode"]];
                                                                    if (array5.count>0) {
                                                                        int level5 = 10;
                                                                        for (int x=0; x<array5.count; x++) {
                                                                            NSDictionary *question_dic5 = [array5 objectAtIndex:x];
                                                                            NSMutableDictionary *dic5 = [self setDictionary:question_dic5 WithLevel:level5];
                                                                            
                                                                            [array5 replaceObjectAtIndex:x withObject:dic5];
                                                                        }
                                                                        [dic4 removeObjectForKey:@"questionNode"];
                                                                        [dic4 setObject:array5 forKey:@"questionNode"];
                                                                    }
                                                                    
                                                                    
                                                                    [array4 replaceObjectAtIndex:n withObject:dic4];
                                                                }
                                                                [dic3 removeObjectForKey:@"questionNode"];
                                                                [dic3 setObject:array4 forKey:@"questionNode"];
                                                            }
                                                            
                                                            [array3 replaceObjectAtIndex:m withObject:dic3];
                                                        }
                                                        [dic2 removeObjectForKey:@"questionNode"];
                                                        [dic2 setObject:array3 forKey:@"questionNode"];
                                                    }
                                                    
                                                    [array2 replaceObjectAtIndex:j withObject:dic2];
                                                }
                                                [dic removeObjectForKey:@"questionNode"];
                                                [dic setObject:array2 forKey:@"questionNode"];
                                            }
                                            
                                            [array_chapterQuestionList replaceObjectAtIndex:i withObject:dic];
                                          }
                                        NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]init];
                                        [tempDic setObject:array_chapterQuestionList forKey:@"questionList"];
                                        [self.delegate getQuestionInfoDidFinished:tempDic];
                                    }
                                }
                                
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                        }
                    }else {
                        [self.delegate getQuestionInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                    }
                }else {
                    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
                }
            }
        }
    }else {
        [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getQuestionInfoDidFailed:@"获取问题失败!"];
}
@end
