//
//  CommentListInterface.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CommentListInterface.h"
#import "NSDictionary+AllKeytoLowerCase.h"
#import "NSString+URLEncoding.h"
#import "NSString+HTML.h"

#import "CommentModel.h"

@implementation CommentListInterface

-(void)getCommentListWithUserId:(NSString*)userId sectionId:(NSString *)sectionId pageIndex:(int)pageIndex
{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",sectionId] forKey:@"sectionId"];
    [reqheaders setValue:[NSString stringWithFormat:@"%d",pageIndex] forKey:@"pageIndex"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@?active=commentList",kHost];
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
                            NSArray *array_comment = [dictionary objectForKey:@"commentList"];
                            if (array_comment.count>0) {
                                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                                for (int i=0; i<array_comment.count; i++) {
                                    NSDictionary *dic_comment = [array_comment objectAtIndex:i];
                                    CommentModel *comment = [[CommentModel alloc]init];
                                    comment.commentAuthorName = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"nickName"]];
                                    comment.commentCreateDate = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"time"]];
                                    comment.commentContent = [NSString stringWithFormat:@"%@",[dic_comment objectForKey:@"content"]];
                                    comment.pageIndex = [[dic_comment objectForKey:@"pageIndex"]intValue];
                                    comment.pageCount = [[dic_comment objectForKey:@"pageCount"]intValue];
                                    
                                    [tempArray addObject:comment];
                                }
                                [self.delegate getCommentListInfoDidFinished:tempArray];
                            }
                        }
                        @catch (NSException *exception) {
                            [self.delegate getCommentListInfoDidFailed:@"加载失败!"];
                        }
                    }else
                        {
                            [self.delegate getCommentListInfoDidFailed:[jsonData objectForKey:@"Msg"]];
                        }
                }else {
                    [self.delegate getCommentListInfoDidFailed:@"加载失败!"];
                }
            }else {
                [self.delegate getCommentListInfoDidFailed:@"加载失败!"];
            }
        }else {
            [self.delegate getCommentListInfoDidFailed:@"加载失败!"];
        }
    }else {
        [self.delegate getCommentListInfoDidFailed:@"加载失败!"];
    }
}

-(void)requestIsFailed:(NSError *)error{
    [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
        [self.delegate getCommentListInfoDidFailed:tipMsg];
    }];
}
@end
