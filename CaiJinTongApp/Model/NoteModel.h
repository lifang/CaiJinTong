//
//  NoteModel.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-1.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject

@property (nonatomic, strong) NSString *noteId;
@property (nonatomic, strong) NSString *noteTitle;
@property (nonatomic, strong) NSString *noteTime;
@property (nonatomic, strong) NSString *noteText;

@end
