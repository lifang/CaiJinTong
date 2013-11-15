//
//  QuestionModel.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "QuestionModel.h"

@implementation QuestionModel
-(void)setIsAcceptAnswer:(NSString *)isAcceptAnswer{
    _isAcceptAnswer = isAcceptAnswer;
    if (self.isAcceptAnswer) {
        for (AnswerModel *answer in self.answerList) {
            answer.IsAnswerAccept = isAcceptAnswer;
        }
    }
}
@end
