//
//  CommentModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject


@property (nonatomic, strong) NSString *commentId;//评论id
@property (nonatomic, strong) NSString *commentAuthorId;//评论作者id
@property (nonatomic, strong) NSString *commentAuthorName;//评论作者名称
@property (nonatomic, strong) NSString *commentCreateDate;//评论创建时间
@property (nonatomic, strong) NSString *commentContent;//评论内容
//以下过时
@property (nonatomic, strong) NSString *nickName;//评论者昵称
@property (nonatomic, strong) NSString *time;//评论时间
@property (nonatomic, strong) NSString *content;//评论内容
@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//
@end
