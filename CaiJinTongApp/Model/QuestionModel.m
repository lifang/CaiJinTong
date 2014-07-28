//
//  QuestionModel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel
//-(void)setIsAcceptAnswer:(NSString *)isAcceptAnswer{
//    _isAcceptAnswer = isAcceptAnswer;
//    if (self.isAcceptAnswer) {
//        for (AnswerModel *answer in self.answerList) {
//            answer.IsAnswerAccept = isAcceptAnswer;
//        }
//    }
//}

-(void)setAskerNick:(NSString *)askerNick{
    if (askerNick ) {
        if ([askerNick isEqualToString:@"<null>"]) {
            _askerNick = @"";
        }else if (askerNick.length > MAX_CONTENT_LENGTH){
            _askerNick = [NSString stringWithFormat:@"%@......",[askerNick substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _askerNick = askerNick;
        }
        
    }else{
        _askerNick = askerNick;
    }
}

-(void)setQuestionName:(NSString *)questionName{
    if (questionName ) {
        if ([questionName isEqualToString:@"<null>"]) {
            _questionName = @"";
        }else if (questionName.length > MAX_CONTENT_LENGTH){
            _questionName = [NSString stringWithFormat:@"%@......",[questionName substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _questionName = questionName;
        }
        
    }else{
        _questionName = questionName;
    }
}

-(void)setQuestiontitle:(NSString *)questiontitle{
    if (questiontitle ) {
        if ([questiontitle isEqualToString:@"<null>"]) {
            _questiontitle = @"";
        }else if (questiontitle.length > MAX_CONTENT_LENGTH){
            _questiontitle = [NSString stringWithFormat:@"%@......",[questiontitle substringToIndex:MAX_CONTENT_LENGTH]];
        }else{
            _questiontitle = questiontitle;
        }
        
    }else{
        _questiontitle = questiontitle;
    }
}
@end
