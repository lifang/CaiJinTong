//
//  BaseImageInfo.h
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

@protocol BaseImageInfoDelegate;
@interface BaseImageInfo : NSObject

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) ASIFormDataRequest *request;
@property (nonatomic, strong) NSString *interfaceUrl;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSDictionary *bodys;
@property (nonatomic, assign) id<BaseImageInfoDelegate> baseDelegate;

-(void)connect;
@end

@protocol BaseImageInfoDelegate <NSObject>

@required
-(void)parseResult:(ASIHTTPRequest *)request;
-(void)requestIsFailed:(NSError *)error;

@optional

@end