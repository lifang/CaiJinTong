//
//  AnswerModel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//
//允许最长的字符
#define MAX_CONTENT_LENGTH  5000

#import "AnswerModel.h"

@implementation Reaskmodel
-(void)setReaskContent:(NSString *)reaskContent{
    if (reaskContent ) {
        if ([reaskContent isEqualToString:@"<null>"]) {
            _reaskContent = @"";
        }else if (reaskContent.length > MAX_CONTENT_LENGTH){
            _reaskContent = [NSString stringWithFormat:@"%@......",[reaskContent substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _reaskContent = reaskContent;
        }
        
    }else{
        _reaskContent = reaskContent;
    }
}

-(void)setReAnswerContent:(NSString *)reAnswerContent{
    if (reAnswerContent ) {
        if ([reAnswerContent isEqualToString:@"<null>"]) {
            _reAnswerContent = @"";
        }else if (reAnswerContent.length > MAX_CONTENT_LENGTH){
            _reAnswerContent = [NSString stringWithFormat:@"%@......",[reAnswerContent substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _reAnswerContent = reAnswerContent;
        }
        
    }else{
        _reAnswerContent = reAnswerContent;
    }
}

-(void)setReAnswerNickName:(NSString *)reAnswerNickName{
    if (reAnswerNickName) {
        if ([reAnswerNickName isEqualToString:@"<null>"]) {
            _reAnswerNickName = @"";
        }else{
            _reAnswerNickName = reAnswerNickName;
        }
    }else{
        _reAnswerNickName = reAnswerNickName;
    }
}

-(void)setReaskNickName:(NSString *)reaskNickName{
    if (reaskNickName) {
        if ([reaskNickName isEqualToString:@"<null>"]) {
            _reaskNickName = @"";
        }else{
            _reaskNickName = reaskNickName;
        }
    }else{
        _reaskNickName = reaskNickName;
    }
}
@end

@implementation AnswerModel
-(void)setAnswerNick:(NSString *)answerNick{
    if (answerNick) {
        if ([answerNick isEqualToString:@"<null>"]) {
            _answerNick = @"";
        }else{
            _answerNick = answerNick;
        }
    }else{
        _answerNick = answerNick;
    }
}

-(void)setAnswerContent:(NSString *)answerContent{
    if (answerContent ) {
        if ([answerContent isEqualToString:@"<null>"]) {
            _answerContent = @"";
        }else if (answerContent.length > MAX_CONTENT_LENGTH){
            _answerContent = [NSString stringWithFormat:@"%@......",[answerContent substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _answerContent = answerContent;
        }
        
    }else{
        _answerContent = answerContent;
    }
}
@end

