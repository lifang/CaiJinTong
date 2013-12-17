//
//  UserModel.h
//  CaiJinTongApp
//
//  Created by apple on 13-11-22.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *userImg;
@property (strong,nonatomic) NSString *nickName;
@end
