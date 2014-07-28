//
//  UserModel.m
//  CaiJinTongApp
//
//  Created by apple on 13-11-22.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
///归档
-(void)archiverUser{
    NSFileManager *fileManage = [NSFileManager defaultManager];
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"user.archive"];
    if ([fileManage fileExistsAtPath:filename]) {
        [fileManage removeItemAtPath:filename error:nil];
    }
    NSDictionary *dic = @{@"userName":(self.userName?:@""),@"userId":(self.userId?:@""),@"birthday":(self.birthday?:@""),@"sex":(self.sex?:@""),@"email":(self.email?:@""),@"mobile":(self.mobile?:@""),@"address":(self.address?:@""),@"userImg":(self.userImg?:@""),@"nickName":(self.nickName?:@"")};
     [NSKeyedArchiver archiveRootObject:dic toFile:filename];
}
///解归档
-(void)unarchiverUser{
    NSString *Path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [Path stringByAppendingPathComponent:@"user.archive"];
    NSDictionary *dic = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    self.userId = [dic objectForKey:@"userId"];
    self.userName = [dic objectForKey:@"userName"];
    self.birthday = [dic objectForKey:@"birthday"];
    self.sex = [dic objectForKey:@"sex"];
    self.email = [dic objectForKey:@"email"];
    self.mobile = [dic objectForKey:@"mobile"];
    self.address = [dic objectForKey:@"address"];
    self.userImg = [dic objectForKey:@"userImg"];
    self.nickName = [dic objectForKey:@"nickName"];
}
@end
