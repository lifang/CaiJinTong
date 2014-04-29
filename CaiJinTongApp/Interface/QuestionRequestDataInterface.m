//
//  QuestionRequestDataInterface.m
//  CaiJinTongApp
//
//  Created by david on 14-4-23.
//  Copyright (c) 2014年 david. All rights reserved.
//

#import "QuestionRequestDataInterface.h"
#import "ASIFormDataRequest.h"
#import "HTMLParser.h"
#import "RichContextObj.h"
@implementation QuestionRequestDataInterface

//TODO::采纳回答
+(void)acceptAnswerWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerID:(NSString*)answerID andCorrectAnswerID:(NSString*)correctAnswerID withSuccess:(void(^)(NSString *msg))success withError:(void (^)(NSError *error))failure{
    if (!userId ||!questionId || !answerID || !correctAnswerID) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    
    //    http://wmi.finance365.com/api/ios.ashx?active=acceptAnswer&userId=17079&questionId=1263&answerId=20744&resultId=1647
    NSString *urlString = [NSString stringWithFormat:@"%@?active=acceptAnswer",kHost];
    DLog(@"采纳答案提交url:%@",urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [request setPostValue:[NSString stringWithFormat:@"%@",questionId] forKey:@"questionId"];
    [request setPostValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"answerId"];
    [request setPostValue:[NSString stringWithFormat:@"%@",correctAnswerID] forKey:@"resultId"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(@"采纳答案提交成功");
            }
        });
    } withFailure:failure];
}


//TODO::分页加载所有问答
+(void)downloadALLQuestionListWithUserId:(NSString *)userId andQuestionCategoryId:(NSString *)categoryId andLastQuestionID:(NSString*)lastQuestionID withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    

    //        http://wmi.finance365.com/api/ios.ashx?active=chapterQuestion&userId=18769&categoryId=58&feedbackId=1844
    NSString *urlString =  [NSString stringWithFormat:@"%@?active=chapterQuestion",kHost];
    DLog(@"分页加载所有问答url:%@",urlString);
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"POST"];
    [request setPostValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];

    if ([[NSString stringWithFormat:@"%d",CategoryType_AllQuestion] isEqualToString:categoryId]) {
        
    }else{
        [request setPostValue:[NSString stringWithFormat:@"%@",categoryId] forKey:@"categoryId"];
    }
    if (lastQuestionID) {
        [request setPostValue:[NSString stringWithFormat:@"%@",lastQuestionID] forKey:@"feedbackId"];
    }
    
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        
        NSDictionary *dic = [dicData objectForKey:@"ReturnObject"];
        if (!dic || dic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"获取数据失败"}]);
                }
            });
            return ;
        }
        NSArray *reslut = [QuestionRequestDataInterface parseJsonDicWithDic:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(reslut);
            }
        });
    } withFailure:failure];
}


//TODO::搜索问答列表
+(void)searchQuestionListWithUserId:(NSString *)userId andText:(NSString *)text withLastQuestionId:(NSString*)lastQuestionId withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    
    
    //    http://lms.finance365.com/api/ios.ashx?active=searchQuestion&userId=17082&content=ss&feedbackId=2021
    NSString *urlString = [NSString stringWithFormat:@"%@?active=searchQuestion&userId=%@&content=%@&feedbackId=%@",kHost,userId,text,lastQuestionId?:@"0"];
    DLog(@"搜索问答列表url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        
        NSDictionary *dic = [dicData objectForKey:@"ReturnObject"];
        if (!dic || dic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"没有搜索到相关数据"}]);
                }
            });
            return ;
        }
        NSArray *reslut = [QuestionRequestDataInterface parseJsonDicWithDic:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(reslut);
            }
        });
    } withFailure:failure];
}

//TODO::加载当前用户的问答
+(void)downloadUserQuestionListWithUserId:(NSString *)userId andIsMyselfQuestion:(NSString *)isMyselfQuestion andLastQuestionID:(NSString*)lastQuestionID withCategoryId:(NSString*)categoryId withSuccess:(void(^)(NSArray *questionModelArray))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    
    //    self.interfaceUrl = [NSString stringWithFormat:@"%@",kHost];
    //isMyselfQuestion=0 表示我提的问题
    //isMyselfQuestion=1 我回答过的问题
    //    self.interfaceUrl = [NSString stringWithFormat:@"http://lms.finance365.com/api/ios.ashx?active=getUserQuestion&userId=17079&isMyselfQuestion=%@",isMyselfQuestion];
    NSString *urlString =  nil;
    if (lastQuestionID) {
        if (categoryId) {
            urlString = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@&feedbackId=%@&categoryId=%@",kHost,userId,isMyselfQuestion,lastQuestionID,categoryId];
        }else{
            urlString = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@&feedbackId=%@",kHost,userId,isMyselfQuestion,lastQuestionID];
        }
        
    }else{
        if (categoryId) {
            urlString = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@&categoryId=%@",kHost,userId,isMyselfQuestion,categoryId];
        }else{
            urlString = [NSString stringWithFormat:@"%@?active=getUserQuestion&userId=%@&isMyselfQuestion=%@",kHost,userId,isMyselfQuestion];
        }
        
    }
    DLog(@"加载当前用户的问答url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        
        NSDictionary *dic = [dicData objectForKey:@"ReturnObject"];
        if (!dic || dic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"数据已经加载完成"}]);
                }
            });
            return ;
        }
        NSArray *reslut = [QuestionRequestDataInterface parseJsonDicWithDic:dic];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(reslut);
            }
        });
    } withFailure:failure];
}

//TODO::提交回答，回复，修改回复，追问，修改追问
+(void)submitAnswerWithUserId:(NSString *)userId andReaskTyep:(ReaskType)reaskType  andAnswerContent:(NSString *)answerContent andQuestionModel:(QuestionModel*)questionModel andAnswerID:(NSString*)answerID withSuccess:(void(^)(NSArray *answerModelArray))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    
    
    

    
    ASIFormDataRequest *request = nil;
    
    if (reaskType == ReaskType_ModifyReaskAnswer){
        reaskType = ReaskType_AnswerForReasking;
    }
    
    if (reaskType == ReaskType_ModifyReaskAnswer) {//修改回复
        //            lms.finance365.com/api/ios.ashx?active=replyquestion&userId=17082&questionid=&content=
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?active=replyquestion",kHost]]];
        [request setTimeOutSeconds:30];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
        [request setPostValue:[NSString stringWithFormat:@"%@",questionModel.questionId] forKey:@"questionid"];
    }else
        if (reaskType == ReaskType_Answer || reaskType == ReaskType_ModifyAnswer) {//回答
        //    http://lms.finance365.com/api/ios.ashx?active=submitAnswer&userId=17079&answerContent=%E5%9B%9E%E7%AD%94%E6%B5%8B%E8%AF%95&questionId=1592&resultId=0
            request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?active=submitAnswer",kHost]]];
            [request setTimeOutSeconds:30];
            [request setRequestMethod:@"POST"];
            [request setPostValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"answerContent"];
            [request setPostValue:[NSString stringWithFormat:@"%@",questionModel.questionId] forKey:@"questionid"];
            [request setPostValue:@"0" forKey:@"resultId"];
        
    }else{
        //    http://lms.finance365.com/api/ios.ashx?active=submitAddAnswer&userId=18676&type=3&id=1950&content=aaaaasaddsadsadsad&fid=2120
        //   追问：id字段传 AID ，回复追问的时候： id字段传ZID  FID是问题的编号
        request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?active=submitAddAnswer",kHost]]];
        [request setTimeOutSeconds:30];
        [request setRequestMethod:@"POST"];
        [request setPostValue:[NSString stringWithFormat:@"%@",answerContent] forKey:@"content"];
        [request setPostValue:[NSString stringWithFormat:@"%@",questionModel.questionId] forKey:@"fid"];
        [request setPostValue:[NSString stringWithFormat:@"%@",answerID] forKey:@"id"];
        [request setPostValue:@"1" forKey:@"resultId"];
        switch (reaskType) {
            case ReaskType_AnswerForReasking://回复追问
            {
                [request setPostValue:[NSString stringWithFormat:@"2"] forKey:@"type"];
            }
                break;
            case ReaskType_ModifyReask://修改追问
            {
                [request setPostValue:[NSString stringWithFormat:@"3"] forKey:@"type"];
            }
                break;
                
            case ReaskType_Reask://追问
            {
                [request setPostValue:[NSString stringWithFormat:@"1"] forKey:@"type"];                
            }
                break;
                
            default: break;
        }
    }
    
    [request setPostValue:[NSString stringWithFormat:@"%@",userId] forKey:@"userId"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        
        NSDictionary *dic = [dicData objectForKey:@"ReturnObject"];
        if (!dic || dic.count <= 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": @"提交数据失败"}]);
                }
            });
            return ;
        }
        ///////////////////begin////////////////////////////
        NSMutableArray *answerModelList = [NSMutableArray array];
        NSArray *answerArr = [dic objectForKey:@"AnswerQuestionList"];
        for (NSDictionary *answer_dic in answerArr) {
            AnswerModel *answer = [[AnswerModel alloc]init];
            answer.answerId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"resultId"]];
            answer.answerTime =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerTime"]];
            answer.answerUserId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerId"]];
            answer.answerUserNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerNick"]];
            answer.answerIsPraised = [NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isParise"]];
            answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
            answer.answerIsCorrect =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
            //            answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
            answer.pageIndex =[[answer_dic objectForKey:@"pageIndex"]intValue];
            answer.pageCount =[[answer_dic objectForKey:@"pageCount"]intValue];
            answer.answerContentType =  ReaskType_Answer;
            answer.questionModel = questionModel;
            answer.isLastAnswer = NO;
            answer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]]];
            [answerModelList addObject:answer];//添加回答
            
            NSArray *reaskArray = [answer_dic objectForKey:@"addList"];
            AnswerModel *lastAnswer = nil;
            for (NSDictionary *reaskDic in reaskArray) {
                //添加追问
                AnswerModel *reaskAnswer = [[AnswerModel alloc]init];
                reaskAnswer.answerId = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"ZID"]];
                //                reaskAnswer.answerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]];
                reaskAnswer.answerTime = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                reaskAnswer.answerReaskedUserID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addMemberID"]];
                reaskAnswer.answerContentType =ReaskType_Reask;
                reaskAnswer.questionModel = questionModel;
                reaskAnswer.isLastAnswer = NO;
                reaskAnswer.answerIsPraised = answer.answerIsPraised;
                reaskAnswer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:[NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]]];
                [answerModelList addObject:reaskAnswer];//添加追问
                lastAnswer = reaskAnswer;
                
                NSString *reAnswerId = [Utility filterValue:[reaskDic objectForKey:@"AID"]];
                NSString *content = [Utility filterValue:[reaskDic objectForKey:@"Answer"]];
                if (reAnswerId && ![reAnswerId isEqualToString:@""] && content) {
                    //对追问的回复
                    AnswerModel *reAnswer = [[AnswerModel alloc]init];
                    reAnswer.answerId = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AID"]];
                    //                    reAnswer.answerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"Answer"]];
                    reAnswer.answerIsAgree = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AgreeStatus"]];
                    reAnswer.answerreIsTeacher = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"IsTeacher"]];
                    reAnswer.answerUserNick = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"TeacherName"]];
                    reAnswer.questionModel = questionModel;
                    reAnswer.answerTime = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                    reAnswer.isLastAnswer = NO;
                    reAnswer.answerIsPraised = answer.answerIsPraised;
                    reAnswer.answerContentType = ReaskType_AnswerForReasking;
                    reAnswer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:content];
                    [answerModelList addObject:reAnswer];//添加回复
                    lastAnswer = reAnswer;
                }
            }
            
            if (lastAnswer) {
                lastAnswer.isLastAnswer = YES;
            }else{
                answer.isLastAnswer = YES;
            }
        }
        
        questionModel.answerList = answerModelList;
        //////////////end//////////////////
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(answerModelList);
            }
        });
    } withFailure:failure];
}


//TODO::点赞
+(void)pariseAnswerWithUserId:(NSString *)userId andQuestionId:(NSString *)questionId andAnswerId:(NSString*)answerId withSuccess:(void(^)(NSString *msg))success withError:(void (^)(NSError *error))failure{
    if (!userId ||!questionId || !answerId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@?active=answerPraise&userId=%@&questionId=%@&resultId=%@",kHost,userId,questionId,answerId];
    DLog(@"修改同学信息url:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    [request setTimeOutSeconds:30];
    [request setRequestMethod:@"GET"];
    [Utility requestDataWithASIRequest:request withSuccess:^(NSDictionary *dicData) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(@"赞成功");
            }
        });
    } withFailure:failure];
}


//TODO::获取用户问答的分类
+(void)downloadUserQuestionCategoryWithUserId:(NSString*)userId withSuccess:(void(^)(NSArray *userQuestionCategoryArray))success withError:(void (^)(NSError *error))failure{
    if (!userId) {
        if (failure) {
            failure([NSError errorWithDomain:@"" code:2001 userInfo:@{@"msg": @"请求参数不能为空"}]);
        }
        return;
    }
    __block NSArray *allQuestionTreeNodeArray = nil;//所有问答分类
    __block NSArray *myQuestionTreeNodeArray = nil;//我的提问
    __block NSArray *myAnswerTreeNodeArray = nil;//和我的回答分类
    __block  NSError *allQuestionCateforyDicError = nil;//解析所有分类出错
    __block  NSError *myQuestionCateforyDicError = nil;//解析我的分类出错
    __block NSError *error = nil;//网络出错
    dispatch_group_t group = dispatch_group_create();
    
    //加载所有分类
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (error) {
            return ;
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?active=getQuestionCategory&userId=%@",kHost,userId]]];
        [request startSynchronous];
        error = request.error;
        NSData *data = request.responseData;
        DLog(@"%@,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            return ;
        }
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            allQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg":@"获取数据失败"}];
            return ;
        }
        
        //解析所有分类
        NSString *status = [Utility filterValue:[dicData objectForKey:@"Status"]];
        if (!status || [status isEqualToString:@"error"] || [status isEqualToString:@"0"]) {
            allQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"Msg"]?:@"获取数据失败"}];
        }else{
            NSDictionary *dictionary =[dicData objectForKey:@"ReturnObject"];
            if (!dictionary || dictionary.count <= 0) {
                allQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"Msg"]?:@"获取数据失败"}];
            }else{
                allQuestionTreeNodeArray = [QuestionRequestDataInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"questionList"] withLevel:1 withRootContentID:[NSString stringWithFormat:@"%d",CategoryType_AllQuestion]];
                
            }
        }
        
    });
    
    //加载我的分类
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (error) {
            return ;
        }
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?active=getMyQuestionCategory&userId=%@",kHost,userId]]];
        [request startSynchronous];
        error = request.error;
        NSData *data = request.responseData;
        DLog(@"%@,%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding],error);
        if (error) {
            return ;
        }
        NSError *jsonError = nil;
        NSDictionary *dicData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonError];
        if (!dicData || dicData.count <= 0) {
            myQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg":@"获取数据失败"}];
            return ;
        }
        
        //解析我的分类
        NSString *status = [Utility filterValue:[dicData objectForKey:@"Status"]];
        if (!status || [status isEqualToString:@"error"] || [status isEqualToString:@"0"]) {
            myQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"Msg"]?:@"获取数据失败"}];
        }else{
            NSDictionary *dictionary =[dicData objectForKey:@"ReturnObject"];
            if (!dictionary || dictionary.count <= 0) {
                myQuestionCateforyDicError = [NSError errorWithDomain:@"" code:2006 userInfo:@{@"msg": [dicData objectForKey:@"Msg"]?:@"获取数据失败"}];
            }else{
                myQuestionTreeNodeArray = [QuestionRequestDataInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"mycategoryList"] withLevel:2 withRootContentID:[NSString stringWithFormat:@"%d",CategoryType_MyQuestion]];
                
                myAnswerTreeNodeArray = [QuestionRequestDataInterface getTreeNodeArrayFromArray:[dictionary objectForKey:@"myanswercategoryList"] withLevel:2 withRootContentID:[NSString stringWithFormat:@"%d",CategoryType_MyAnswer]];
                
            }
        }
        
    });
    
    //所有分类加载完后合并分类
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        if (error) {
            [Utility requestFailure:error tipMessageBlock:^(NSString *tipMsg) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (failure) {
                        failure([NSError errorWithDomain:@"" code:2002 userInfo:@{@"msg": tipMsg}]);
                    }
                });
            }];
            
            return ;
        }
        if (myQuestionCateforyDicError && allQuestionCateforyDicError) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failure) {
                    failure(myQuestionCateforyDicError?myQuestionCateforyDicError:allQuestionCateforyDicError);
                }
            });
            return;
        }
        
        //我的提问列表
        DRTreeNode *myQuestion = [[DRTreeNode alloc] init];
        myQuestion.noteContentID =[NSString stringWithFormat:@"%d",CategoryType_MyQuestion];
        myQuestion.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyQuestion];
        myQuestion.noteContentName = @"我的提问";
        myQuestion.childnotes = myQuestionTreeNodeArray;
        myQuestion.noteLevel = 1;
        //所有问答列表
        DRTreeNode *question = [[DRTreeNode alloc] init];
        question.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_AllQuestion];
        question.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_AllQuestion];
        question.noteContentName = @"所有问答";
        question.childnotes = allQuestionTreeNodeArray;
        question.noteLevel = 0;
        //我的回答列表
        DRTreeNode *myAnswer = [[DRTreeNode alloc] init];
        myAnswer.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswer];
        myAnswer.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswer];
        myAnswer.noteContentName = @"我的回答";
        myAnswer.childnotes = myAnswerTreeNodeArray;
        myAnswer.noteLevel = 1;
        //我的问答
        DRTreeNode *my = [[DRTreeNode alloc] init];
        my.noteContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswerAndQuestion];
        my.noteRootContentID = [NSString stringWithFormat:@"%d",CategoryType_MyAnswerAndQuestion];
        my.noteContentName = @"我的问答";
        my.childnotes = @[myQuestion,myAnswer];
        my.noteLevel = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                success(@[my,question]);
            }
        });
    });

}

//TODO::解析分类树形结构
+(NSMutableArray*)getTreeNodeArrayFromArray:(NSArray*)arr withLevel:(int)level withRootContentID:(NSString*)rootContentID{
    NSMutableArray *notes = [NSMutableArray array];
    for (NSDictionary *dic in arr) {
        DRTreeNode *note = [[DRTreeNode alloc] init];
        note.noteContentID = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionID"]];
        note.noteContentName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"questionName"]];
        note.noteLevel = level;
        note.noteRootContentID = rootContentID;
        note.childnotes = [QuestionRequestDataInterface getTreeNodeArrayFromArray:[dic objectForKey:@"questionNode"] withLevel:level+1 withRootContentID:note.noteRootContentID]; 
        [notes addObject:note];
    }
    return notes;
}


//TODO::解析json dic
+(NSArray*)parseJsonDicWithDic:(NSDictionary*)jsonDic{
    NSArray *array_chapterQuestionList =[jsonDic objectForKey:@"chapterQuestionList"];
    if (!array_chapterQuestionList || array_chapterQuestionList.count <= 0) {
        array_chapterQuestionList =[jsonDic objectForKey:@"questionList"];
    }
     NSMutableArray *resultList = [[NSMutableArray alloc]init];
    for (int i= 0; i<array_chapterQuestionList.count; i++) {
        NSDictionary *question_dic = [array_chapterQuestionList objectAtIndex:i];
        QuestionModel *question = [[QuestionModel alloc]init];
        question.questionId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionId"]];
        question.attachmentFileUrl = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"extUrl"]];
//        question.questionName = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questionName"]];
        question.questiontitle = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"questiontitle"]];
        question.askerId = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerId"]];
        question.askImg = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askImg"]];
        question.askerNick = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askerNick"]];
        question.askTime = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"askTime"]];
        question.praiseCount = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"praiseCount"]];
        question.isAcceptAnswer = [NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isAcceptAnswer"]];
        question.pageIndex =[[question_dic objectForKey:@"pageIndex"]intValue];
        question.pageCount =[[question_dic objectForKey:@"pageCount"]intValue];
        question.questionIsExtend = NO;
        question.isPraised =[NSString stringWithFormat:@"%@",[question_dic objectForKey:@"isPraised"]];
        NSString *content = [Utility filterValue:[question_dic objectForKey:@"questionName"]];
        if (!content ||[content isEqualToString:@""]) {
            content = [Utility filterValue:[question_dic objectForKey:@"questionname"]];
        }
        question.questionRichContentArray = [QuestionRequestDataInterface parseHTMLContent:content];
        [resultList addObject:question];//添加问题
        
        NSArray *array_answer = [question_dic objectForKey:@"answerList"];
        question.answerList = [[NSMutableArray alloc]init];
        for (int k=0; k<array_answer.count; k++) {
            NSDictionary *answer_dic = [array_answer objectAtIndex:k];
            AnswerModel *answer = [[AnswerModel alloc]init];
            answer.answerId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"resultId"]];
            answer.answerTime =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerTime"]];
            answer.answerUserId =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerId"]];
            answer.answerUserNick =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerNick"]];
            answer.answerIsPraised = [NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"isParise"]];
            answer.answerPraiseCount =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerPraiseCount"]];
            answer.answerIsCorrect =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"IsAnswerAccept"]];
            if (![question.isAcceptAnswer isEqualToString:@"1"]) {
                question.isAcceptAnswer = answer.answerIsCorrect;
            }
//            answer.answerContent =[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]];
            answer.pageIndex =[[answer_dic objectForKey:@"pageIndex"]intValue];
            answer.pageCount =[[answer_dic objectForKey:@"pageCount"]intValue];
            answer.answerContentType =  ReaskType_Answer;
            answer.questionModel = question;
            answer.isLastAnswer = NO;
            answer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:[NSString stringWithFormat:@"%@",[answer_dic objectForKey:@"answerContent"]]];
//            [resultList addObject:answer];//添加回答
            [question.answerList addObject:answer];
            
           
            NSArray *reaskArray = [answer_dic objectForKey:@"addList"];
            AnswerModel *lastAnswer = nil;
            for (NSDictionary *reaskDic in reaskArray) {
                 //添加追问
                AnswerModel *reaskAnswer = [[AnswerModel alloc]init];
                reaskAnswer.answerId = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"ZID"]];
//                reaskAnswer.answerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]];
                reaskAnswer.answerTime = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                reaskAnswer.answerReaskedUserID = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addMemberID"]];
                reaskAnswer.answerContentType =ReaskType_Reask;
                reaskAnswer.questionModel = question;
                reaskAnswer.isLastAnswer = NO;
                reaskAnswer.answerIsPraised = answer.answerIsPraised;
                reaskAnswer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:[NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"addQuestion"]]];
//                [resultList addObject:reaskAnswer];//添加追问
                [question.answerList addObject:reaskAnswer];
                lastAnswer = reaskAnswer;
                
                NSString *reAnswerId = [Utility filterValue:[reaskDic objectForKey:@"AID"]];
                NSString *content = [Utility filterValue:[reaskDic objectForKey:@"Answer"]];
                if (reAnswerId && ![reAnswerId isEqualToString:@""] && content) {
                    //对追问的回复
                    AnswerModel *reAnswer = [[AnswerModel alloc]init];
                    reAnswer.answerId = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AID"]];
//                    reAnswer.answerContent = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"Answer"]];
                    reAnswer.answerIsAgree = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"AgreeStatus"]];
                    reAnswer.answerreIsTeacher = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"IsTeacher"]];
                    reAnswer.answerUserNick = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"TeacherName"]];
                    reAnswer.answerTime = [NSString stringWithFormat:@"%@",[reaskDic objectForKey:@"CreateDate"]];
                    reAnswer.questionModel = question;
                    reAnswer.isLastAnswer = NO;
                    reAnswer.answerIsPraised = answer.answerIsPraised;
                    reAnswer.answerContentType = ReaskType_AnswerForReasking;
                    reAnswer.answerRichContentArray = [QuestionRequestDataInterface parseHTMLContent:content];
//                    [resultList addObject:reAnswer];//添加回复
                    [question.answerList addObject:reAnswer];
                    lastAnswer = reAnswer;
                }
            }
            if (lastAnswer) {
                lastAnswer.isLastAnswer = YES;
            }else{
                answer.isLastAnswer = YES;
            }
            
        }
    }
    
    return resultList;
}

//TODO::解析html字符串
+(NSArray*)parseHTMLContent:(NSString*)htmlString{
    NSError *error = nil;
    HTMLParser *parser = [[HTMLParser alloc] initWithString:htmlString error:&error];
    if (error) {
        NSLog(@"DRAttributeStringView :parser content error%@",error);
        return nil;
    }

    NSMutableArray *richObjArray = [NSMutableArray array];
    for (HTMLNode *node in parser.body.children) {
        [QuestionRequestDataInterface parseHTMLNode:node withRichContentArray:richObjArray];
    }
    return richObjArray;
}

///遍历html分支
+(void)parseHTMLNode:(HTMLNode*)node withRichContentArray:(NSMutableArray*)richContentArray{
    if ([node.tagName isEqualToString:@"img"]) {
        NSString *imageUrl = [node getAttributeNamed:@"src"];
        if (imageUrl) {
            NSString *extension = [[imageUrl pathExtension] lowercaseString];
            RichContextObj *richObj = [[RichContextObj alloc] init];
            richObj.richContentType = [Utility getFileTypeWithFileExtension:extension];
            richObj.richContext = nil;
            [richContentArray addObject:richObj];
        }
    }
    
    if (node.contents) {
        RichContextObj *richObj = [[RichContextObj alloc] init];
        richObj.richContentType = DRURLFileType_STRING;
        richObj.richContext = node.contents;
        [richContentArray addObject:richObj];
    }
    for (HTMLNode *child in node.children) {
        [QuestionRequestDataInterface parseHTMLNode:child withRichContentArray:richContentArray];
    }
}
@end
