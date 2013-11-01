//
//  CommentModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject

@property (nonatomic, strong) NSString *nickName;//评论者昵称
@property (nonatomic, strong) NSString *time;//评论时间
@property (nonatomic, strong) NSString *content;//评论内容
@property (nonatomic, assign) int pageIndex;//
@property (nonatomic, assign) int pageCount;//
@end
